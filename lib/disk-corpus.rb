require 'yaml'
require 'bindata'
require 'seek'

module Spicy
end

module Spicy::Disk
  module Files
    def self.dir
      @@dir ||= File.join(File.dirname(__FILE__), 'corpus')
    end

    def self.adjectives
      @@adjectives ||= File.join(dir, 'adjectives.bin')
    end

    def self.nouns
      @@nouns ||= File.join(dir, 'nouns.bin')
    end

    def self.colors
      @@colors ||= File.join(dir, 'colors.bin')
    end
  end

  class Header < BinData::Record
    endian :little
    uint8 :width
    uint8 :min_length
    uint8 :group_count, :value => lambda { cumulative.length }
    array :cumulative, :type => :uint32, :initial_length => :group_count
  end

  class WordList
    include Spicy::Seek

    def initialize(file_name)
      @file = File.open(file_name, 'r')
      header = Header.read(@file)
      @origin = @file.pos

      @width = header.width.to_i
      @min = header.min_length.to_i
      @max = @min + header.cumulative.count - 1

      @cumulative = Hash[(@min..@max).zip(header.cumulative.to_a.map(&:to_i))]
    end

    def close
      @file.close
    end

    def word(*args)
      self.seek(*args) do |index, _|
        @file.seek(@origin + index * @width, IO::SEEK_SET)
        @file.read(@width).strip
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

    def color(*args)
      generate(:colors, *args)
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
