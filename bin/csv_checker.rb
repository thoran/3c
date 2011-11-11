#!/usr/bin/env ruby
# csv_checker.rb

# 20111111
# 0.3.0

$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib')))

require 'Array/not_emptyQ'
require 'Object/inQ'
require 'Object/not_nilQ'
require 'SimpleCSV.rbd/SimpleCSV'
require 'String/integerQ'
require 'Switches'

checks = [
  {
    :warning => Proc.new{|parsed_row| "Names cannot be less than four characters...  #{parsed_row['Name']} is only #{parsed_row['Name'].size} characters."}, 
    :test => Proc.new{|parsed_row| parsed_row['Name'] && parsed_row['Name'].size >= 4}
  },
  {
    :warning => Proc.new{|parsed_row| "The code denoting state must be in the file states.csv (ie. in the range 1..8)...  #{parsed_row['State']} is outside this range."}, 
    :test => Proc.new{|parsed_row| parsed_row['State'].in?(state_codes)}
  },
  {
    :warning => Proc.new{|parsed_row| "The salary must be an integer and not a float...  #{parsed_row['Salary']} is not an integer."}, 
    :test => Proc.new{|parsed_row| parsed_row['Salary'] && parsed_row['Salary'].integer?}
  },
  {
    :error => Proc.new{|parsed_row| "The postcode must exist...  The postcode is missing."},
    :test => Proc.new{|parsed_row| parsed_row['Postcode'].not_nil?}
  }
]

@switches = (
  Switches.new do |s|
    s.set :d, :data_file, :default => '../data/data.csv'
    s.set :s, :states_file, :default => '../data/states.csv'
    s.set :o, :output, :default => 'everything' # clean, unclean, warnings, no_warnings, errors, no_errors, everything
  end
)

def check(parsed_row, checks)
  checks.each do |check|
    if check[:warning] && !check[:test].call(parsed_row)
      @warnings << check[:warning].call(parsed_row)
    elsif check[:error] && !check[:test].call(parsed_row)
      @errors << check[:error].call(parsed_row)
    end
  end
end

def state_codes
  @state_codes ||= (
    csv_file = CSVFile.new(@switches.states_file, :row_separator => "\r\r\n")
    csv_file.columns = ['code', 'name']
    csv_file.read.collect{|e| e['code']}
  )
end

def parse(checks)
  SimpleCSV.parse(@switches.data_file, :headers => true, :row_separator => "\r\r\n").collect do |row|
    @warnings, @errors = [], []
    check(row, checks)
    row.merge(:warnings => @warnings, :errors => @errors)
  end
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

def main(checks)
  parsed_data = parse(checks)
  filtered_data = filter(parsed_data)
  output(filtered_data)
end

main(checks)
