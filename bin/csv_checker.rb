#!/usr/bin/env ruby
# csv_checker.rb

# 20111112
# 0.4.0

$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib')))

require 'Array/not_emptyQ'
require 'Object/inQ'
require 'Object/not_nilQ'
require 'SimpleCSV.rbd/SimpleCSV'
require 'String/integerQ'
require 'Switches'

def switches
  @switches ||= (
    Switches.new do |s|
      s.set :d, :data_file, :default => '../data/data.csv'
      s.set :s, :states_file, :default => '../data/states.csv'
      s.set :f, :filter_type, :default => 'everything' # clean, unclean, warnings, no_warnings, errors, no_errors, everything
      s.set :c, :checks_file, :default => '../config/checks.rb'
    end
  )
end

def state_codes
  @state_codes ||= (
    csv_file = CSVFile.new(switches.states_file, :row_separator => "\r\r\n")
    csv_file.columns = ['code', 'name']
    csv_file.read.collect{|e| e['code']}
  )
end

def checks
  @checks ||= instance_eval(File.read(switches.checks_file))
end

def check(parsed_row)
  checks.each do |check|
    if check[:warning] && !check[:test].call(parsed_row)
      @warnings << check[:warning].call(parsed_row)
    elsif check[:error] && !check[:test].call(parsed_row)
      @errors << check[:error].call(parsed_row)
    end
  end
end

def parse(data_file)
  SimpleCSV.parse(data_file, :headers => true, :row_separator => "\r\r\n").collect do |row|
    @warnings, @errors = [], []
    check(row)
    row.merge(:warnings => @warnings, :errors => @errors)
  end
end

def filter(parsed_data)
  if switches.filter_type == 'clean'
    parsed_data.select{|e| e[:warnings].empty? && e[:errors].empty?}
  elsif switches.filter_type == 'unclean'
    parsed_data.select{|e| e[:warnings].not_empty? || e[:errors].not_empty?}
  elsif switches.filter_type == 'warnings'
    parsed_data.select{|e| e[:warnings].not_empty?}
  elsif switches.filter_type == 'no_warnings'
    parsed_data.select{|e| e[:warnings].empty?}
  elsif switches.filter_type == 'errors'
    parsed_data.select{|e| e[:errors].not_empty?}
  elsif switches.filter_type == 'no_errors'
    parsed_data.select{|e| e[:errors].empty?}
  elsif switches.filter_type == 'everything'
    parsed_data
  else
    raise 'filter unrecognized'
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
