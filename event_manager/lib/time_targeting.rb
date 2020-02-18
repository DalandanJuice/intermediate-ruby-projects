require 'csv'
require 'erb'
puts "Event Manager Initialized"
contents = CSV.open("event_attendees.csv")
hours = Hash.new(0)
days = Hash.new(0)
length = 0
contents.each_with_index do |row,index|
  next if index == 0 
  date = DateTime.strptime(row[1], '%m/%d/%y %k:%M')
  # hours[date.hour] += 1
  hour = date.hour
  day = date.wday
  days[day] += 1
  hours[hour] += 1
  length += 1
end
def find_peak_count(date)
  greatest = 0
  date.each do |key, value|
    if value > greatest
      greatest = value
    end
  end
  greatest
end

def include_peak_keys(date)
  peak_key = find_peak_count(date)
  peak_keys = []
  date.each do |key, value|
    if value == peak_key
      peak_keys.push(key)
    end
  end
  peak_keys
end

puts hours
peak_hours = include_peak_keys(hours)
peak_days = include_peak_keys(days)
template = File.read("timetable.erb")
csv_template = "<%=days.each { |day, registered_count|  'day,registered_count'}%>"
erb_template = ERB.new(csv_template)
result = erb_template.result(binding)
filename = "peakdays.csv"
def generate_csv(filename,hash,column)
  File.open(filename,'w') do |file|
    file.puts "#{column[0]}, #{column[1]}"
    hash.each do |key, value|
      file.puts("#{key}, #{value}")
    end
  end
end
full_days = %w[Sunday Monday Tuesday Wednesday thursday Friday Saturday]
puts days
puts full_days[peak_days[0]]
