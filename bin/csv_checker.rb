#!/usr/bin/env ruby
# csv_checker.rb

# 20111110
# 0.1.0

require 'Array/not_emptyQ'
require 'Object/inQ'
require 'Object/not_nilQ'
require 'SimpleCSV.rbd/SimpleCSV'
require 'String/integerQ'
require 'Switches'

@switches = (
  Switches.new do |s|
    s.set :d, :data_file, :default => '../data/data.csv'
    s.set :s, :states_file, :default => '../data/states.csv'
    s.set :o, :output, :default => 'everything' # clean, unclean, warnings, no_warnings, errors, no_errors, everything
  end
)

# Names cannot be less than four characters
def step_1(parsed_row)
  parsed_row['Name'] && parsed_row['Name'].size >= 4
end

# The code denoting state must be in the file states.csv
def step_2(parsed_row)
  parsed_row['State'].in?(state_codes)
end

# The salary must be an integer and not a float
def step_3(parsed_row)
  parsed_row['Salary'] && parsed_row['Salary'].integer?
end

# The postcode must exist
def step_4(parsed_row)
  parsed_row['Postcode'].not_nil?
end

def warn(parsed_row, step)
  @warnings << (
    case step
    when 1; "Warning: Names cannot be less than four characters...  #{parsed_row['Name']} is #{parsed_row['Name'].size} characters.}"
    when 2; "Warning: The code denoting state must be in the file states.csv (ie. in the range 1..8)...  State is outside this range and is #{parsed_row['State']}.}"
    when 3; "Warning: The salary must be an integer and not a float...  Salary is not an integer and is a float with the value, #{parsed_row['Salary']}.}"
    end
  )
end

def error(parsed_row)
  @errors << "Error: The postcode must exist...  The postcode is missing.}"
end

def verify(parsed_row)
  warn(parsed_row, 1) unless step_1(parsed_row)
  warn(parsed_row, 2) unless step_2(parsed_row)
  warn(parsed_row, 3) unless step_3(parsed_row)
  error(parsed_row) unless step_4(parsed_row)
end

def state_codes
  @state_codes ||= (
    csv_file = CSVFile.new(@switches.states_file, :row_separator => "\r\r\n")
    csv_file.columns = ['code', 'name']
    csv_file.read.collect{|e| e['code']}
  )
end

def parse
  parsed_data = []
  SimpleCSV.parse(@switches.data_file, :headers => true, :row_separator => "\r\r\n") do |row|
    @warnings = []
    @errors = []
    verify(row)
    parsed_data << row.merge(:warnings => @warnings, :errors => @errors)
  end
  parsed_data
end

def filter(parsed_data)
  if @switches.output == 'clean'
    parsed_data.select{|e| e[:warnings].empty? && e[:errors].empty?}
  elsif @switches.output == 'unclean'
    parsed_data.select{|e| e[:warnings].not_empty? || e[:errors].not_empty?}
  elsif @switches.output == 'warnings'
    parsed_data.select{|e| e[:warnings].not_empty?}
  elsif @switches.output == 'no_warnings'
    parsed_data.select{|e| e[:warnings].empty?}
  elsif @switches.output == 'errors'
    parsed_data.select{|e| e[:errors].not_empty?}
  elsif @switches.output == 'no_errors'
    parsed_data.select{|e| e[:errors].empty?}
  elsif @switches.output == 'everything'
    parsed_data
  end
end

def output(filtered_data)
  filtered_data.each{|e| p e}
end

def main
  parsed_data = parse
  filtered_data = filter(parsed_data)
  output(filtered_data)
end

main
