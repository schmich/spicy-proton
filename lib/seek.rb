require 'securerandom'

module Spicy
  module Seek
    private

    def seek(opts = {}, &found)
      min = opts[:min]
      max = opts[:max]
      length = opts[:length]
      rand = opts[:rand] # adds support for a supplied Random instance, pre-seeded

      if !length.nil? && (!min.nil? || !max.nil?)
        raise ArgumentError, 'length cannot be specified if min or max are specified.'
      end

      if !min.nil? && !max.nil? && min > max
        raise ArgumentError, 'min must be no more than max.'
      end

      min = [min || length || @min, @min].max
      max = [max || length || @max, @max].min

      rand_min = @cumulative[min - 1] || 0
      rand_max = (@cumulative[max] || @cumulative[@max]) - 1

      # Adds support to use a user-supplied Random instance
      index = rand(rand_min, rand_max, rand)

      min.upto(max) do |len|
        if @cumulative[len] > index
          return yield(index)
        end
      end

      nil
    end

    def rand(low, high, rand)
      range = high - low + 1

      rand.nil? ? low + SecureRandom.random_number(range) : low + rand.rand(range)
    end
  end
end
