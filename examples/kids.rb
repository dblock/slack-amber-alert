require 'hyperclient'

api = Hyperclient.new('http://www.missingkidsbot.org/api/missing_kids/')

api.missing_kids.each do |missing_kid|
  puts missing_kid.title
end
