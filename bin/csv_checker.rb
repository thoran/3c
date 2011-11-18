#!/usr/bin/env ruby
# csv_checker.rb

# 20111117, 18
# 0.5.0

# Changes since 0.4: 
# 1. Removed all of the core extensions used here or in config/checks.rb.  
# 2. Moved @warnings and @errors from parse() into check(), where they should have been, and made them locals, thereby removing two effectively global instance variables.  
# 3. Made use of a new method on SimpleCSV's eigenclass: collect(), which shortens the required amount of code quite a bit.  

require '../lib/SimpleCSV.rbd/SimpleCSV'
require '../lib/Switches'

def switches
  @switches ||= Switches.new do |s|
    s.set :d, :data_file, :default => '../data/data.csv'
    s.set :s, :states_file, :default => '../data/states.csv'
    s.set :f, :filter_type, :default => 'everything' # clean, unclean, warnings, no_warnings, errors, no_errors, everything
    s.set :c, :checks_file, :default => '../config/checks.rb'
  end
end

def state_codes
  @state_codes ||= CSVFile.collect(switches.states_file, :row_separator => "\r\r\n", :columns => ['code', 'name']){|row| row['code']}
end

def checks
  @checks ||= instance_eval(File.read(switches.checks_file))
end

def check(parsed_row)
  warnings, errors = [], []
  checks.each do |check|
    if check[:warning] && !check[:test].call(parsed_row)
      warnings << check[:warning].call(parsed_row)
    elsif check[:error] && !check[:test].call(parsed_row)
      errors << check[:error].call(parsed_row)
    end
  end
  {:warnings => warnings, :errors => errors}
end

def parse(data_file)
  CSVFile.collect(data_file, :headers => true, :row_separator => "\r\r\n"){|row| row.merge(check(row))}
end

def filter(parsed_data)
  case switches.filter_type
  when 'clean'; parsed_data.select{|e| e[:warnings].empty? && e[:errors].empty?}
  when 'unclean'; parsed_data.select{|e| !e[:warnings].empty? || !e[:errors].empty?}
  when 'warnings'; parsed_data.select{|e| !e[:warnings].empty?}
  when 'no_warnings'; parsed_data.select{|e| e[:warnings].empty?}
  when 'errors'; parsed_data.select{|e| !e[:errors].empty?}
  when 'no_errors'; parsed_data.select{|e| e[:errors].empty?}
  when 'everything'; parsed_data
  else; raise 'filter unrecognized'
  end
end

def display(filtered_data)
  filtered_data.each{|e| p e}
end

def main
  parsed_data = parse(switches.data_file)
  filtered_data = filter(parsed_data)
  display(filtered_data)
end

main
