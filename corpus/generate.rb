require 'yaml'
require 'disk-corpus'

['adjectives.yaml', 'nouns.yaml'].each do |source|
  dir = File.dirname(__FILE__)
  words = YAML.load_file(File.join(dir, source))
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
  file = File.join(out_dir, File.basename(source, '.yaml') + '.bin')
  File.open(file, 'w') do |w|
    header = Spicy::Disk::Header.new
    width = words.values.flatten.map(&:length).max
    header.width = width
    header.min_length = words.keys.min
    cumulative.values.each do |count|
      header.cumulative << count
    end
    header.write(w)
    words.values.flatten.each do |word|
      padding = "\0" * (width - word.length)
      w.write(word + padding)
    end
  end

  file = File.join(out_dir, source)
  File.open(file, 'w') do |f|
    f.write(YAML.dump({ 'cumulative' => cumulative, 'words' => words }))
  end
end
