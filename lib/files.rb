module Spicy
  module Files
    def self.dir
      @@dir ||= File.join(File.dirname(__FILE__), 'corpus')
    end

    def self.adjectives
      @@adjectives ||= File.join(dir, 'adjectives.yaml')
    end

    def self.nouns
      @@nouns ||= File.join(dir, 'nouns.yaml')
    end

    def self.colors
      @@colors ||= File.join(dir, 'colors.yaml')
    end

    def self.combined
      @@combined ||= File.join(dir, 'combined.bin')
    end
  end
end
