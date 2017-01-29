require 'json'
require 'yaml'
require 'securerandom'
require 'files'

module Spicy
  class BinaryCorpus
    private_class_method :new

    def self.use
      file = File.open(Files.combined, 'r')
      begin
        corpus = new(file)
        yield corpus
      ensure
        file.close
      end
    end

    def initialize(file)
      @file = file
      @meta = {}
      self.class.corpus.keys.each do |set|
        bytes = @file.read(3 * 4)
        start, count, size = bytes.unpack('L*')
        @meta[set] = {
          start: start,
          count: count,
          size: size
        }
      end
    end

    def self.generate
      dir = File.dirname(__FILE__)
      sources = corpus.values

      sets = sources.map do |source|
        terms = YAML.load_file(source)
        {
          terms: terms,
          start: 0,
          count: terms.count,
          size: terms.map(&:length).max
        }
      end

      start = (3 * 4) * sets.length
      sets.each do |set|
        set[:start] = start
        start += set[:count] * set[:size]
      end

      File.open(Files.combined, 'w+') do |f|
        meta = []
        sets.each do |set|
          meta << set[:start]
          meta << set[:count]
          meta << set[:size]
        end

        f.write(meta.pack('L*'))

        sets.each do |set|
          set[:terms].each do |term|
            padding = "\0" * (set[:size] - term.length)
            f.write(term + padding)
          end
        end
      end
    end

    def adjective
      read_random(:adjectives)
    end

    def noun
      read_random(:nouns)
    end

    def color
      read_random(:colors)
    end

    private

    def read_random(set)
      set = @meta[set]
      index = SecureRandom.random_number(set[:count])
      @file.seek(set[:start] + index * set[:size], IO::SEEK_SET)
      @file.read(set[:size]).strip
    end

    def self.corpus
      {
        adjectives: Files.adjectives,
        nouns: Files.nouns,
        colors: Files.colors
      }
    end
  end
end
