require 'yaml'
require 'binary'
require 'files'

module Spicy
  class Proton
    def initialize
      dir = File.dirname(__FILE__)
      @adjectives = YAML.load_file(Files.adjectives)
      @nouns = YAML.load_file(Files.nouns)
      @colors = YAML.load_file(Files.colors)
    end

    def self.adjective
      BinaryCorpus.use(&:adjective)
    end

    def self.noun
      BinaryCorpus.use(&:noun)
    end

    def self.color
      BinaryCorpus.use(&:color)
    end

    def self.pair(separator = '-')
      BinaryCorpus.use do |b|
        "#{b.adjective}#{separator}#{b.noun}"
      end
    end

    def self.format(format)
      BinaryCorpus.use do |b|
        self.format_with(b, format)
      end
    end

    def adjective
      random(adjectives)
    end

    def noun
      random(nouns)
    end

    def color
      random(colors)
    end

    def pair(separator = '-')
      "#{self.adjective}#{separator}#{self.noun}"
    end

    def format(format)
      self.class.format_with(self, format)
    end

    attr_accessor :adjectives, :nouns, :colors

    private

    def self.format_with(source, format)
      format.gsub(/%([anc])/) do
        case $1
        when 'a'
          source.adjective
        when 'n'
          source.noun
        when 'c'
          source.color
        end
      end
    end

    def random(set)
      index = SecureRandom.random_number(set.count)
      set[index]
    end
  end
end
