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

  def test_color
    generators { |gen| assert_generated(gen, :color) }
  end

  def test_pair
    generators { |gen|
      pair = assert_generated(gen, :pair)
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
      fmt = gen.format('%a:1%c:2%n')
      assert_string(fmt)
      assert(fmt.length >= 7)
      assert(fmt.index(':1') > 0)
      assert(fmt.index(':2') > 0)
      fmt = gen.format('%%')
      assert_equal('%', fmt)
    }
  end

  private

  def generators(&block)
    block.call(Spicy::Proton)
    block.call(Spicy::Proton.new)
  end

  def assert_generated(source, type)
    string = source.send(type)
    assert_string(string)
  end

  def assert_string(string)
    refute_nil(string)
    assert(string.is_a?(String))
    assert(string.length > 0)
    string
  end
end
