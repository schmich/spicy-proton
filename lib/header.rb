require 'bindata'

module Spicy
  class Header < BinData::Record
    endian :little
    uint8 :min_length
    uint8 :group_count, :value => lambda { cumulative.length }
    array :cumulative, :type => :uint32, :initial_length => :group_count

    def self.cumulative(f)
      header = read(f)
      min = header.min_length.to_i
      max = min + header.cumulative.count - 1
      Hash[(min..max).zip(header.cumulative.to_a.map(&:to_i))]
    end
  end
end
