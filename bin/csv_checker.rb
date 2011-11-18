#!/usr/bin/env ruby
# csv_checker.rb

# 20111117, 18
# 0.6.0

# Changes since 0.5: 
# 1. check() has one less test prior to inserting a message or warning.  
# 2. + filterer() (I had to think of a name!), which returns which filter to apply to filter.  
# 3. ~ filter(), so as it makes use of filterer().  

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
    if !check[:test].call(parsed_row)
      if check[:warning]
        warnings << check[:warning].call(parsed_row)
      elsif check[:error]
        errors << check[:error].call(parsed_row)
      end
    end
  end
  {:warnings => warnings, :errors => errors}
end

def parse(data_file)
  CSVFile.collect(data_file, :headers => true, :row_separator => "\r\r\n"){|row| row.merge(check(row))}
end

def filterer
  @filterer ||= case switches.filter_type
  when 'clean'; Proc.new{|e| e[:warnings].empty? && e[:errors].empty?}
  when 'unclean'; Proc.new{|e| !e[:warnings].empty? || !e[:errors].empty?}
  when 'warnings'; Proc.new{|e| !e[:warnings].empty?}
  when 'no_warnings'; Proc.new{|e| e[:warnings].empty?}
  when 'errors'; Proc.new{|e| !e[:errors].empty?}
  when 'no_errors'; Proc.new{|e| e[:errors].empty?}
  when 'everything'; Proc.new{|e| true}
  else; raise 'filter unrecognized'
  end
end

def filter(parsed_data)
  parsed_data.select{|e| filterer.call(e)}
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
