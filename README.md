# Spicy::Proton
Generate a random adjective-noun word pair. Works with Ruby 1.9.x and newer.

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
Spicy::Proton.color                 # => "burgundy"
Spicy::Proton.pair                  # => "opportune-spacesuit"
Spicy::Proton.pair(':')             # => "hip:squash"
Spicy::Proton.format('%a/%c/%n')    # => "slippery/ultramarine/rattler"

# With length constraints.
Spicy::Proton.adjective(max: 5)     # => "foamy"
Spicy::Proton.noun(min: 10)         # => "translucence"
Spicy::Proton.color(min: 5, max: 7) # => "indigo"
Spicy::Proton.noun(length: 8)       # => "morality"
```

When generating multiple specimens, instance methods are faster. The instance keeps the word corpus in memory. The instance methods are the same as their static counterparts.

```ruby
require 'spicy-proton'

generator = Spicy::Proton.new
1000.times do 
  generator.adjective
  generator.noun(min: 7)
  generator.color(length: 4) 
  generator.pair
  generator.pair(':')
  generator.format('%a-%c-%n')
end
```

Instances give you access to the raw word lists as well:

```ruby
generator.adjectives    # => ["dreadful", "methodist", "necessary", "tough", ...]
generator.nouns         # => ["rustling", "fiance", "infield", "chatter", ...]
generator.colors        # => ["alizarin", "amaranth", "amber", "amethyst", ...]
```

## License

Copyright &copy; 2017 Chris Schmich  
MIT License. See [LICENSE](LICENSE) for details.
