require 'csv'
puts "EventManager Initialized"
def is_number?(number)
  if number == '1' or number == '2' or number == '3' or number == '4' or number == '5' or number == '6' or number == '7' or number == '8' or number == '9' or number == '0'
    return true
  else
    return false
  end
end
def find_length(number)
  i = 0
  new_number = ''
  while i < number.length
    if is_number?(number[i])
      new_number += number[i]
    end
    i = i +  1
  end
  new_number.length
end
def clean_number(number)
  number_length = find_length(number)
  if number_length < 10
    "BAD"
  elsif number_length = 10
    number
  elsif number_length == 11 && number[0] == '1'
   number[1..10]
#    puts "number: #{number}"
  elsif number_length == 11 && number[0] != '1'
    "BAD"
  elsif number_length > 11
    "BAD"
  else
  end
end
contents = CSV.open "event_attendees.csv", headers: true

contents.each do |row|
  number = row[5]
  phone_number = clean_number(number)
  puts phone_number
end


