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
Spicy::Proton.format('%a/%a/%n')    # => "dapper/festive/fedora"

# With length constraints.
Spicy::Proton.adjective(max: 5)     # => "dank"
Spicy::Proton.noun(min: 10)         # => "interpolation"
Spicy::Proton.adjective(length: 8)  # => "medieval"
Spicy::Proton.noun(min: 5, max: 7)  # => "dolphin"
```

When generating multiple specimens, instance methods are faster. The instance keeps the word corpus in memory. The instance methods are the same as their class method counterparts.

```ruby
require 'spicy-proton'

generator = Spicy::Proton.new
1000.times do 
  generator.adjective
  generator.noun(min: 7)
  generator.pair
  generator.pair('.')
  generator.format('%a-%n')
end
```

Instances give you access to the raw word lists as well:

```ruby
generator.adjectives    # => ["dreadful", "methodist", "necessary", "tough", ...]
generator.nouns         # => ["rustling", "fiance", "infield", "chatter", ...]
```

## Credits

Inspired by [btford/adj-noun](https://github.com/btford/adj-noun). Thanks to [NLTK](http://www.nltk.org/) for the word corpus.

## License

Copyright &copy; 2017 Chris Schmich  
MIT License. See [LICENSE](LICENSE) for details.
