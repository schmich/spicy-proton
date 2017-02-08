# Spicy::Proton

Generate a random English adjective-noun word pair. Works with Ruby 1.9.x and newer.

[![Gem Version](https://badge.fury.io/rb/spicy-proton.svg)](http://rubygems.org/gems/spicy-proton)
[![Build Status](https://travis-ci.org/schmich/spicy-proton.svg?branch=master)](https://travis-ci.org/schmich/spicy-proton)

## Quick Start

`gem install spicy-proton`

```ruby
require 'spicy-proton'

puts Spicy::Proton.pair
# => "decadent-inquisition"
```

## Usage

When generating single or infrequent specimens, class methods are faster and use less memory.

```ruby
require 'spicy-proton'

Spicy::Proton.adjective             # => "extreme"
Spicy::Proton.noun                  # => "loan"
Spicy::Proton.pair                  # => "opportune-spacesuit"
Spicy::Proton.pair(':')             # => "hip:squash"
Spicy::Proton.adverb                # => "energetically"
Spicy::Proton.verb                  # => "refrained"
Spicy::Proton.format('%a/%a/%n')    # => "dapper/festive/fedora"
Spicy::Proton.format('%b %v')       # => "artfully stained"

# With length constraints.
Spicy::Proton.adjective(max: 5)     # => "dank"
Spicy::Proton.noun(min: 10)         # => "interpolation"
Spicy::Proton.adjective(length: 8)  # => "medieval"
Spicy::Proton.noun(min: 5, max: 7)  # => "dolphin"
Spicy::Proton.adverb(min: 0)        # => "prophetically"
Spicy::Proton.verb(max: 100)        # => "sparkles"
```

When generating multiple specimens, instance methods are faster. The instance keeps the word corpus in memory. The instance methods are the same as their class method counterparts.

```ruby
require 'spicy-proton'

gen = Spicy::Proton.new
1000.times do 
  gen.adjective
  gen.noun(min: 7)
  gen.pair
  gen.pair('.')
  gen.adverb(length: 6)
  gen.verb(max: 5)
  gen.format('The %a %n %b %v the %n.')
end
```

Instances also provide raw word lists in length order:

```ruby
gen.adjectives    # => ["aft", "apt", "bad", "big", ...]
gen.nouns         # => ["ad", "ax, "ox", "pi", ...]
gen.adverbs       # => ["no", "aft", "ago", "all", ...]
gen.verbs         # => ["am", "be", "do", "go", ...]
```

## Credits

Inspired by [btford/adj-noun](https://github.com/btford/adj-noun). Thanks to [NLTK](http://www.nltk.org/) for the word corpus.

## License

Copyright &copy; 2017 Chris Schmich  
MIT License. See [LICENSE](LICENSE) for details.
