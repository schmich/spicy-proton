require 'forwardable'
require 'disk-corpus'
require 'memory-corpus'

module Spicy
  class Proton
    extend Forwardable

    def initialize
      @corpus = Memory::Corpus.new
    end

    def self.adjective(min: nil, max: nil)
      Disk::Corpus.use do |c|
        c.adjective(min: min, max: max)
      end
    end

    def self.noun(min: nil, max: nil)
      Disk::Corpus.use do |c|
        c.noun(min: min, max: max)
      end
    end

    def self.color(min: nil, max: nil)
      Disk::Corpus.use do |c|
        c.color(min: min, max: max)
      end
    end

    def self.pair(separator = '-')
      Disk::Corpus.use do |c|
        "#{c.adjective}#{separator}#{c.noun}"
      end
    end

    def self.format(format)
      Disk::Corpus.use do |c|
        self.format_with(c, format)
      end
    end

    def format(format)
      self.class.format_with(self, format)
    end

    def_delegators :@corpus, :adjective, :noun, :color, :pair, :adjectives, :nouns, :colors

    private

    def self.format_with(source, format)
      format.gsub(/%([anc%])/) do
        case $1
        when 'a'
          source.adjective
        when 'n'
          source.noun
        when 'c'
          source.color
        when '%'
          '%'
        end
      end
    end
  end
end
