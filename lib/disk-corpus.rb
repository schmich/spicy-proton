require 'seek'
require 'header'

module Spicy
end

module Spicy::Disk
  module Files
    def self.dir
      @@dir ||= File.join(File.dirname(__FILE__), 'corpus')
    end

    def self.adjectives
      @@adjectives ||= File.join(dir, 'adjectives-fixed.bin')
    end

    def self.nouns
      @@nouns ||= File.join(dir, 'nouns-fixed.bin')
    end
  end

  class WordList
    include Spicy::Seek

    def initialize(file_name)
      @file = File.open(file_name, 'rb')

      @cumulative = Spicy::Header.cumulative(@file)
      @min = @cumulative.keys.min
      @max = @cumulative.keys.max

      @origin = @file.pos
    end

    def close
      @file.close
    end

    def word(*args)
      seek(*args) do |index|
        @file.seek(@origin + index * @max, IO::SEEK_SET)
        @file.read(@max).strip
      end
    end
  end
  
  class Corpus
    private_class_method :new

    def self.use
      corpus = new
      begin
        yield corpus
      ensure
        corpus.close
      end
    end

    def initialize
      @lists = {}
    end

    def close
      @lists.values.each(&:close)
    end

    def adjective(*args)
      generate(:adjectives, *args)
    end

    def noun(*args)
      generate(:nouns, *args)
    end

    private

    def generate(type, *args)
      @lists[type] ||= begin
        WordList.new(Files.send(type))
      end
      @lists[type].word(*args)
    end
  end
end
