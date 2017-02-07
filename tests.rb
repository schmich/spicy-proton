require 'minitest'
require 'minitest/autorun'
require './lib/spicy-proton'

class Tests < Minitest::Test
  def test_adjective
    generators { |gen| assert_generated(gen, :adjective) }
  end

  def test_noun
    generators { |gen| assert_generated(gen, :noun) }
  end

  def test_pair
    generators { |gen|
      pair = gen.pair
      assert_string(pair)
      assert(pair.length >= 3)
      assert(pair.index('-') > 0)
    }
  end

  def test_pair_separator
    generators { |gen|
      pair = gen.pair(':')
      assert_string(pair)
      assert(pair.length >= 3)
      assert(pair.index(':') > 0)
    }
  end

  def test_format
    generators { |gen|
      fmt = gen.format('%a:1%n:2')
      assert_string(fmt)
      assert(fmt.length >= 7)
      assert(fmt.index(':1') > 0)
      assert(fmt.index(':2') > fmt.index(':1'))
      fmt = gen.format('%%')
      assert_equal('%', fmt)
      fmt = gen.format('%z')
      assert_equal('%z', fmt)
    }
  end

  def test_min
    generators { |gen|
      assert_generated(gen, :noun, min: 8)
      assert_generated(gen, :adjective, min: 8)
    }
  end

  def test_max
    generators { |gen|
      assert_generated(gen, :noun, max: 4)
      assert_generated(gen, :adjective, max: 4)
    }
  end

  def test_min_max
    generators { |gen|
      assert_generated(gen, :noun, min: 3, max: 4)
      assert_generated(gen, :adjective, min: 3, max: 4)
    }
  end

  def test_invert_min_max
    generators { |gen|
      [:adjective, :noun].each do |type|
        assert_error(ArgumentError) do
          gen.send(type, min: 2, max: 1)
        end
      end
    }
  end

  def test_bad_min
    generators { |gen|
      [:adjective, :noun].each do |type|
        word = gen.send(type, min: 1000)
        assert_nil(word)
      end
    }
  end

  def test_bad_max
    generators { |gen|
      [:adjective, :noun].each do |type|
        word = gen.send(type, max: 0)
        assert_nil(word)
      end
    }
  end

  def test_large_range
    generators { |gen|
      [:adjective, :noun].each do |type|
        word = gen.send(type, min: 0, max: 10000)
        assert_string(word)
      end
    }
  end

  def test_equal_min_max
    generators { |gen|
      [:adjective, :noun].each do |type|
        word = gen.send(type, min: 6, max: 6)
        assert_string(word)
        assert_equal(6, word.length)
      end
    }
  end

  def test_length
    generators { |gen|
      [:adjective, :noun].each do |type|
        word = gen.send(type, length: 4)
        assert_string(word)
        assert_equal(4, word.length)
      end
    }
  end

  def test_length_min_max
    generators { |gen|
      [:adjective, :noun].each do |type|
        assert_error(ArgumentError) do
          gen.send(type, length: 5, min: 4)
        end
        assert_error(ArgumentError) do
          gen.send(type, length: 5, max: 7)
        end
      end
    }
  end

  private

  def generators(&block)
    block.call(Spicy::Proton)
    block.call(Spicy::Proton.new)
  end

  def assert_error(type, &block)
    error = nil
    begin
      block.call
    rescue => e
      error = e
    ensure
      refute_equal(nil, error)
      assert_equal(type, error.class)
    end
  end

  def assert_generated(source, type, opts = {})
    min, max = opts[:min], opts[:max]
    string = source.send(type, min: min, max: max)
    assert(string.length >= min) if min
    assert(string.length <= max) if max
    assert_string(string)
  end

  def assert_string(string)
    refute_nil(string)
    assert(string.is_a?(String))
    assert(string.length > 0)
    string
  end
end
