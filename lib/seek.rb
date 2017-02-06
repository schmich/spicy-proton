require 'securerandom'

module Spicy
  module Seek
    private

    def seek(opts = {}, &found)
      min, max, length = opts[:min], opts[:max], opts[:length]

      if !length.nil? && (!min.nil? || !max.nil?)
        raise ArgumentError.new('length cannot be specified if min or max are specified.')
      end

      if !min.nil? && !max.nil? && min > max
        raise ArgumentError.new('min must be no more than max.')
      end

      min = [min || length || @min, @min].max
      max = [max || length || @max, @max].min

      rand_min = @cumulative[min - 1] || 0
      rand_max = (@cumulative[max] || @cumulative[@max]) - 1
      index = rand(rand_min, rand_max)

      min.upto(max) do |len|
        if @cumulative[len] > index
          return found.call(index)
        end
      end

      nil
    end

    def rand(low, high)
      range = high - low + 1
      low + SecureRandom.random_number(range)
    end
  end
end
