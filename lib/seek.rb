require 'securerandom'

module Spicy
  module Seek
    def seek(min: nil, max: nil, length: nil, &found)
      if !length.nil? && (!min.nil? || !max.nil?)
        raise ArgumentError.new('length cannot be specified if min or max are specified.')
      end

      if !min.nil? && !max.nil? && min > max
        raise ArgumentError.new('min must be no more than max.')
      end

      min = [min || length || @min, @min].max
      max = [max || length || @max, @max].min

      rand_min = @cumulative[min - 1] || 0
      rand_max = @cumulative[max] || @cumulative[@max]
      index = SecureRandom.random_number(rand_min...rand_max)

      min.upto(max) do |len|
        if @cumulative[len] > index
          return found.call(index, len)
        end
      end

      nil
    end
  end
end
