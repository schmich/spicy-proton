# Spicy::Proton
Generate a random adjective-noun pair.

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

Spicy::Proton.adjective           # => "extreme"
Spicy::Proton.noun                # => "loan"
Spicy::Proton.color               # => "burgundy"
Spicy::Proton.pair                # => "opportune-spacesuit"
Spicy::Proton.pair(':')           # => "hip:squash"
Spicy::Proton.format('%a/%c/%n')  # => "slippery/ultramarine/rattler"
```

When generating multiple specimens, instance methods are faster. The instance keeps the word corpus in memory.

```ruby
require 'spicy-proton'

generator = Spicy::Proton.new
1000.times do 
  generator.adjective
  generator.noun
  generator.pair
  generator.pair(':')
  generator.format('%a/%c/%n')
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
