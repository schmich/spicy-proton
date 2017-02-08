require 'json'
require 'yaml'

file = ARGV[0]
if !file || !file.end_with?('.json')
  puts 'JSON file name required.'
  exit 1
end

words = JSON.load(File.read(file)).sort_by { |w| [w.length, w] }
yaml = YAML.dump(words)

out = File.basename(file, '.json') + '.yaml'
File.open(out, 'w') do |w|
  w.write(yaml)
end

puts "Dumped to #{out}."
