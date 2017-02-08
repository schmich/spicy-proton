module Spicy
  module Corpus
    def adjective(*args)
      generate(:adjectives, *args)
    end

    def noun(*args)
      generate(:nouns, *args)
    end

    def verb(*args)
      generate(:verbs, *args)
    end

    def adverb(*args)
      generate(:adverbs, *args)
    end

    def pair(separator = '-')
      "#{adjective}#{separator}#{noun}"
    end

    def format(format)
      format.gsub(/%([anbv%])/) do
        case $1
        when 'a'
          adjective
        when 'n'
          noun
        when 'b'
          adverb
        when 'v'
          verb
        when '%'
          '%'
        end
      end
    end
  end
end
