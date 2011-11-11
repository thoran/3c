#!/usr/bin/env ruby
# csv_checker

# 20111110
# 0.0.0

require 'SimpleCSV.rbd/SimpleCSV'
require 'String/integerQ'
require 'Switches'

@switches = (
  Switches.new do |s|
    s.set :d, :data_file, :default => '../data/data.csv'
    s.set :s, :states_file, :default => '../data/states.csv'
  end
)

# Names cannot be less than four characters
def step_1(parsed_row)
  parsed_row['Name'] && parsed_row['Name'].size >= 4
end

# The code denoting state must be in the file states.csv
def step_2(parsed_row)
  state_codes.include?(parsed_row['State'])
end

# The salary must be an integer and not a float
def step_3(parsed_row)
  parsed_row['Salary'] && parsed_row['Salary'].integer?
end

# The postcode must exist
def step_4(parsed_row)
  parsed_row['Postcode'].nil?
end

def verify(parsed_row)
  p step_1(parsed_row)
  p step_2(parsed_row)
  p step_3(parsed_row)
  p step_4(parsed_row)
end

def state_codes
  @state_codes ||= (
    csv_file = CSVFile.new(@switches.states_file, :row_separator => "\r\r\n")
    csv_file.columns = ['code', 'name']
    csv_file.read.collect{|e| e['code']}
  )
end

def parse_data
  SimpleCSV.parse(@switches.data_file, :headers => true, :row_separator => "\r\r\n") do |row|
    p row
    verify(row)
  end
end

def main
  parse_data
end

main
