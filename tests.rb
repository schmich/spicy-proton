require 'minitest'
require 'minitest/autorun'
require './lib/spicy-proton'

class Tests < Minitest::Test
  def test_single_word
    types.each do |type|
      corpus { |c| assert_generated(c, type) }
    end
  end

  def test_pair
    corpus { |c|
      pair = c.pair
      assert_string(pair)
      assert(pair.length >= 3)
      assert(pair.index('-') > 0)
    }
  end

  def test_pair_separator
    corpus { |c|
      pair = c.pair(':')
      assert_string(pair)
      assert(pair.length >= 3)
      assert(pair.index(':') > 0)
    }
  end

  def test_format
    corpus { |c|
      fmt = c.format('%a1%n2%b3%v4')
      assert_string(fmt)
      assert(fmt.length >= 12)
      assert(fmt.index('1') > 0)
      assert(fmt.index('2') > fmt.index('1'))
      assert(fmt.index('3') > fmt.index('2'))
      assert(fmt.index('4') > fmt.index('3'))
      assert_nil(fmt.index('%a'))
      assert_nil(fmt.index('%n'))
      assert_nil(fmt.index('%b'))
      assert_nil(fmt.index('%v'))
      fmt = c.format('%%')
      assert_equal('%', fmt)
      fmt = c.format('%z')
      assert_equal('%z', fmt)
    }
  end

  def test_min
    types.each do |type|
      corpus { |c|
        assert_generated(c, type, min: 8)
      }
    end
  end

  def test_max
    types.each do |type|
      corpus { |c|
        assert_generated(c, type, max: 4)
      }
    end
  end

  def test_min_max
    types.each do |type|
      corpus { |c|
        assert_generated(c, type, min: 3, max: 4)
      }
    end
  end

  def test_invert_min_max
    types.each do |type|
      corpus { |c|
        assert_error(ArgumentError) do
          c.send(type, min: 2, max: 1)
        end
      }
    end
  end

  def test_bad_min
    types.each do |type|
      corpus { |c|
        word = c.send(type, min: 1000)
        assert_nil(word)
      }
    end
  end

  def test_bad_max
    types.each do |type|
      corpus { |c|
        word = c.send(type, max: 0)
        assert_nil(word)
      }
    end
  end

  def test_large_range
    types.each do |type|
      corpus { |c|
        word = c.send(type, min: 0, max: 10000)
        assert_string(word)
      }
    end
  end

  def test_equal_min_max
    types.each do |type|
      corpus { |c|
        word = c.send(type, min: 6, max: 6)
        assert_string(word)
        assert_equal(6, word.length)
      }
    end
  end

  def test_length
    types.each do |type|
      corpus { |c|
        word = c.send(type, length: 4)
        assert_string(word)
        assert_equal(4, word.length)
      }
    end
  end

  def test_length_min_max
    types.each do |type|
      corpus { |c|
        assert_error(ArgumentError) do
          c.send(type, length: 5, min: 4)
        end
        assert_error(ArgumentError) do
          c.send(type, length: 5, max: 7)
        end
      }
    end
  end

  def test_word_lists
    c = Spicy::Proton.new
    refute(c.adjectives.empty?)
    refute(c.nouns.empty?)
    refute(c.adverbs.empty?)
    refute(c.verbs.empty?)
  end

  private

  def corpus(&block)
    block.call(Spicy::Proton)
    block.call(Spicy::Proton.new)
  end

  def types
    [:adjective, :noun, :adverb, :verb]
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
