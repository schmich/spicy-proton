require 'minitest'
require 'minitest/autorun'
require './lib/spicy-proton'

class Tests < Minitest::Test
  def test_binary_adjective
    assert_string(Spicy::Proton, :adjective)
  end

  def test_binary_noun
    assert_string(Spicy::Proton, :noun)
  end

  def test_binary_color
    assert_string(Spicy::Proton, :color)
  end

  def test_binary_pair
    assert_string(Spicy::Proton, :pair)
  end

  def test_generator_adjective
    assert_string(Spicy::Proton.new, :adjective)
  end

  def test_generator_noun
    assert_string(Spicy::Proton.new, :noun)
  end

  def test_generator_color
    assert_string(Spicy::Proton.new, :color)
  end

  def test_generator_pair
    assert_string(Spicy::Proton.new, :pair)
  end

  private

  def assert_string(source, type)
    string = source.send(type)
    refute_nil(string)
    assert(string.is_a?(String))
    assert(string.length > 0)
    string
  end
end
