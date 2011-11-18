#!/usr/bin/env ruby
# csv_checker.rb

# 20111117, 18
# 0.8.1

# Changes since 0.7: 
# 1. I've removed a number of methods and replaced what was a reasonable separation of concerns, and instead using SimpleCSV's class method select().  
# 0/1
# 2. With a view to making this quite short, I am removing the method wrappers and instead turning all but one variable into locals and using it directly.  

require '../lib/SimpleCSV.rbd/SimpleCSV'
require '../lib/Switches'

switches ||= Switches.new{|s| s.set :d, :data_file, :default => '../data/data.csv'; s.set :s, :states_file, :default => '../data/states.csv'; s.set :f, :filter_type, :default => 'everything'; s.set :c, :checks_file, :default => '../config/checks.rb'; s.set :filters_file, :default => '../config/filters.rb'}
state_codes ||= CSVFile.collect(switches.states_file, :row_separator => "\r\r\n", :columns => ['code', 'name']){|row| row['code']}
@checks ||= instance_eval(File.read(switches.checks_file))
filterer ||= (filter_found = instance_eval(File.read(switches.filters_file))[switches.filter_type.to_sym]) ? filter_found : (raise 'filter unrecognized')

def check_message(parsed_row, check)
  check[:warning] ? {:warning => check[:warning].call(parsed_row)} : {:error => check[:error].call(parsed_row)}
end

def check(parsed_row)
  @checks.inject({:warnings => [], :errors => []}) do |h, check|
    (check[:warning] ? h[:warnings] : h[:errors]) << check_message(parsed_row, check) if !check[:test].call(parsed_row)
    h
  end
end

CSVFile.select(switches.data_file, :headers => true, :row_separator => "\r\r\n"){|row| filterer.call(row.merge(check(row)))}.each{|e| p e}
