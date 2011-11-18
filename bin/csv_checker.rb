#!/usr/bin/env ruby
# csv_checker.rb

# 20111118
# 0.9.0

# Changes since 0.7/8: 
# 1. - require 'SimpleCSV.rbd/SimpleCSV'
# 2. - require 'Switches'
# 3. + require 'ostruct'
# 4. + require 'fastercsv'
# 5. I put back all of the vaguely sensible separation of concerns and methods as per 0.7.x.  
# 6. + FasterCSV::Row#to_h, so as it would work with the code I'd written to do the checks without modification so as to add warnings and errors to each row.  
# 7. ~ state_codes(), so as to strip each line of whitespace before the line endings.  
# 8. ~ state_codes(), to make use of FasterCSV.  
# 9. ~ parse(), so as to strip each line of whitespace before the line endings.  
# 10. ~ parse(), to make use of FasterCSV.  
# 11. ~ check_message, so as it returns a string and not a hash as it should have been in 0.8.2, but it was a litle hard to read that one.  

# Notes: 
# 1. I've bothered in this version to fix the issue with extraneous whitespace before the end of each row (and specifically the issue with one of the lines in data/data.csv having a line ending of "\r \r\n"), not least of which because FasterCSV, perhaps quite rightly barfed at the CSV files as they are issuing a MalformedCSV error.  

# Todo: 
# 1. + require 'optparse'.  

require 'ostruct'
require 'fastercsv'

class FasterCSV::Row
  
  def to_h
    headers.inject({}){|h,e| h[e] = self[headers.index(e)]; h}
  end
  
end

def switches
  @switches ||= begin
    switches = OpenStruct.new
    switches.data_file = '../data/data.csv'
    switches.states_file = '../data/states.csv'
    switches.filter_type = 'everything'
    switches.checks_file = '../config/checks.rb'
    switches.filters_file = '../config/filters.rb'
    switches
  end
end

def state_codes
  @state_codes ||= begin
    csv_string = File.read(switches.states_file).split("\r\n").collect{|e| e.strip}.join("\r\n")
    FasterCSV.parse(csv_string).collect{|row| row[0]}
  end
end

def checks
  @checks ||= instance_eval(File.read(switches.checks_file))
end

def check_message(parsed_row, check)
  check[:warning] ? check[:warning].call(parsed_row) : check[:error].call(parsed_row)
end

def check(parsed_row)
  checks.inject({:warnings => [], :errors => []}) do |h, check|
    (check[:warning] ? h[:warnings] : h[:errors]) << check_message(parsed_row, check) if !check[:test].call(parsed_row)
    h
  end
end

def filterer
  @filterer ||= if (filter_found = instance_eval(File.read(switches.filters_file))[switches.filter_type.to_sym])
    filter_found
  else
    raise 'filter unrecognized'
  end
end

def parse(data_file)
  csv_string = File.read(data_file).split("\r\n").collect{|e| e.strip}.join("\r\n")
  rows = []
  FasterCSV.parse(csv_string, :headers => true) do |row|
    rows << row.to_h.merge(check(row))
  end
  rows
end

def filter(parsed_csv)
  parsed_csv.select{|e| filterer.call(e)}
end

def display(filtered_csv)
  filtered_csv.each{|e| p e}
end

def main
  parsed_csv = parse(switches.data_file)
  filtered_csv = filter(parsed_csv)
  display(filtered_csv)
end

main
