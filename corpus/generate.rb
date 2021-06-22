require 'disk-corpus'
require 'memory-corpus'

['adjectives.txt', 'nouns.txt', 'adverbs.txt', 'verbs.txt'].each do |source|
  dir = File.dirname(__FILE__)
  words = IO.readlines(File.join(dir, source)).map(&:strip)
  groups = Hash[words.group_by(&:length).sort_by(&:first)]

  min = groups.keys.min
  max = groups.keys.max

  words = {}
  cumulative = {}

  total = 0
  min.upto(max) do |len|
    if !groups[len]
      cumulative[len] = cumulative[len - 1]
      words[len] = []
    else
      words[len] = groups[len]
      total += words[len].length
      cumulative[len] = total
    end
  end

  out_dir = File.realpath(File.join(dir, '..', 'lib', 'corpus'))

  header = Spicy::Header.new
  header.min_length = words.keys.min

  cumulative.values.each do |count|
    header.cumulative << count
  end

  fixed_file = File.join(out_dir, File.basename(source, '.txt') + '-fixed.bin')
  File.open(fixed_file, 'wb') do |w|
    puts "Write #{fixed_file}."
    width = words.keys.max
    header.write(w)
    words.values.flatten.each do |word|
      padding = "\0" * (width - word.length)
      w.write(word + padding)
    end
  end

  packed_file = File.join(out_dir, File.basename(source, '.txt') + '.bin')
  File.open(packed_file, 'wb') do |w|
    puts "Write #{packed_file}."
    header.write(w)
    w.write(words.values.flatten.join("\0"))
  end
end
