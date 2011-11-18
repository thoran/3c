# SimpleCSV

# 20111111, 17, 18
# 0.9.9 (in progress)

# Description: A CSV object for reading and writing CSV (and similar) text files with tabulated data to and from files and strings.  

# Todo: 
# 1. Have it be able to read mixed CSV files.  Done as of 0.9.0.  
# 2. Have it be able to read escaped and quoted delimeters.  
# 3. Separate out the different classes into separate files.  Done as of 0.8 I think, but taken further with 0.9.  
# 4. Create a gem and/or Rubylibify and/or 
# 5. Optionally do line counts.  
# 6. Optionally do column count checks.  
# 7. Optionally do data consistency checks for column length, type, and anything else that makes sense.  
# 8. Put the option to specify quoting into to_csv and possibly remove it from #init.  Done as of at least 0.8.  
# 9. Remove underscores when outputting the header line, but only if they were added---and only if they're wanting to be removed?...  As of 0.9.0, I just use strings anyway.  
# 10. Reorder the conditionals in #write_line and #write_header.  Done as of 0.9.0.  
# 11. Simplify some more!  Done as of 0.9.1.  

# Ideas: 
# 1. Standardize on either symbols or strings for column names, since presently one has to be consistent.  It would be nicer to be able to mix and match---if possible.  
# 2. Automatically detect as to whether there is a header line by taking the first line and comparing the types (alpha, numeric, alpha-numeric, etcetera) with each of the column values with those of the subsequent 2 or 3 or so lines and if there is a correspondence, then assume that there is a header line.  This would mean that the assumption that there is would change and that if the guess was wrong that it would need to be made explict.  
# 3. Have it #read a file automatically if any of 'r' or 'r+' or 'w+' is given as the mode.  
# 4. Finally try to make use of Index instead of Hash, since that library file is still hanging around.  Using this class may be simpler but not faster than using Hash and Array.  

# Bugs: 
# 1. This did cope with commas within a quoted CSV file, however while I think I broke this again with 0.9.0, I'm not sure that I ever had it working properly.  It works properly as of 0.9.3 at least.  
#check it# 2. SimpleCSV#write_row doesn't handle it if there are no attributes/columns defined.  It needs to work with CSV files with no column names.  

# Changes since 0.8: 
# 1. /CSVFile/SimpleCSV/.  
# 2. Reset the Todo list and rolled in the Goals to that.  
# 3. Moved the loader stuff (Array, Hash, String) in here.  
# 4. More changes to interfaces to reflect the change in 0.8.0 to interface arguments.  
# 0/1 (Mostly the changes have been to supporting libraries.)
# 1/2
# 5. ~ SimpleCSV.read, contains SimpleCSV.read_rows.  
# 6. ~ SimpleCSV.write, contains SimpleCSV.write_rows.  
# 7. ~ SimpleCSV.header_row, simplified.  
# 8. ~ SimpleCSV.first_row, simplified.  
# 9. ~ SimpleCSV.attributes, simplified.  
# 10. ~ SimpleCSV.columns, simplified.  
# 11. - attr_accessor :rows, :quote, not being used.  
# 12. - alias_method :lines, :rows, not being used.  
# 13. - SimpleCSV#each_with_columns, rolled into SimpleCSV#each.  
# 14. ~ SimpleCSV#each, rolled in SimpleCSV#each_with_columns and only output Hashes now.  
# 15. - alias_method :lines, :rows, since a line is an unparsed row.  
# 16. ~ SimpleCSV#initialize, it now makes use of SimpleCSV.source.  
# 17. + SimpleCSV.parse, since it behaves slightly differently now from when it was an alias of SimpleCSV.read.  
# 18. ~ SimpleCSV.read, is now tidier!  
# 19. ~ SimpleCSV.write, is also a bit tidier!  
# 20. + SimpleCSV.to_a, so as to give this sort of output.  
# 21. + SimpleCSV.source_type.  
# 22. + CSVFile#initialize.  
# 23. + CSVString#initialize.  
# 24. - require '_meta/default_to'.  
# 25. - SimpleCSV#columns?, and using @columns.empty? instead in SimpleCSV#parse_row, since it is faster not to make that method call every row.  
# 26. - SimpleCSV#read_row, now just SimpleCSV#parse_row.  
# 27. - SimpleCSV#read_header, since it wasn't being used.  
# 28. - SimpleCSV#rows?, using @rows[0] instead in SimpleCSV#each, since it is faster not to make that method call every row.  
# 29. + SimpleCSV#parse, so as to mirror the changes in the class interface.  
# 30. ~ SimpleCSV#read, so as to accommodate the creation of SimpleCSV#parse as per the class interface.  
# 31. - require 'Index' and the file from ./lib also, since it wasn't being used still.  
# 2/3
# 32. ~ SimpleCSV#initialize, so as the default quoting is :none, not :double.  
# 33. + SimpleCSV#read_header, which I'd mistakenly taken out in the recent cull... for use with SimpleCSV#read.  
# 34. ~ SimpleCSV#read, calls read_header, so the first line isn't pulled in as data.  
# 35. ~ SimpleCSV#initialize, /use_array/as_array/.  
# 36. ~ SimpleCSV#initialize, compressed a couple of the if statements, since they weren't complicated enough to be over 7 lines each.  
# 37. ~ SimpleCSV#parse_row, logic was inverted for when @columns.blank? after a change in the logic for at 0.9.0!  
# 38. ~ SimpleCSV#attributes, /columns/@columns.blank?/, and switched the logic order(!), since this is a little more robust and probably slightly faster too.  
# 39. ~ SimpleCSV#to_a, so as it copes when there are not attributes (ie. no columns specified) and so it now uses each row's order value to sort by for the getting the correct column order.  
# 40. ~ SimpleCSV#initialize, fixed manual column setting, so as it makes use of SimpleCSV#column=.  
# 4/5
# 41. ~ SimpleCSV#initialize, + options[:row_sep] as an optional key to set @row_separator with a view to some FasterCSV compatibility.  
# 42. ~ SimpleCSV#columns, so as to gather empty header columns.  
# 43. ~ SimpleCSV#attributes, so as it can handle the empty header columns compiled in columns().  
# 44. This was bumped from 0.9.4 to 0.9.5 and an intermediate version which was 0.9.4 was left at that version number.  
# 5/6
# 45. + SimpleCSV.parse_line for FasterCSV compatibiity.  
# 46. ~ SimpleCSV#initialize, + @column_separator in part for FasterCSV compatibility.  
# 47. ~ SimpleCSV#columns, + @column_separator in part for FasterCSV compatibility.  
# 48. ~ SimpleCSV#parse_row, + @column_separator in part for FasterCSV compatibility.  
# 49. ~ SimpleCSV#initialize, ~ @source.  
# 50. ~ CSVFile#initialize moved @source to own method.  
# 51. + CSVFile#source.  
# 52. + CSVFile#mode.  
# 53. + CSVFile#permissions.  
# 54. + CSVFile#filename.  
# 55. ~ CSVString#initialize.  
# 56. + CSVString#source.  
# 6/7 (A better implementation of enabling @as_array)
# 57. ~ SimpleCSV#read, so as the @as_array decisions are handled further down---in CSVFile#parse_row...  
# 58. ~ SimpleCSV#parse_row, so as it returns an array instead of a hash if so desired.  
# 59. ~ SimpleCSV#to_a, so as it handles the @as_array option.  
# 7/8 (1. Proper handling of @row_separator and 2. a more full implementation of the class method interfaces.)
# 60. ~ SimpleCSVe#parse_row, so as it assigns the index variable in fewer places.  
# 61. Now using String#split_csv 0.7.0, which has an additional argument and associated code to handle the row_separator or the chomping that goes on in there...  
# 62. ~ SimpleCSV#columns, introduced @row_separator into the call to String#split_csv.  
# 63. ~ SimpleCSV#parse_row, introduced @row_separator into the calls to String#split_csv.  
# 64. ~ SimpleCSV#initialize so that @quote now defaults to nil, allowing String#split_csv to handle heterogenously quoted lines.  
# 65. ~ SimpleCSV.parse, so as the call to read() makes use of any block supplied.  
# 66. ~ SimpleCSV.header_row, so as arguments can be supplied to the constructor.  
# 67. ~ SimpleCSV.first_row, so as arguments can be supplied to the constructor.  
# 68. ~ SimpleCSV.attributes, so as arguments can be supplied to the constructor.  
# 69. ~ SimpleCSV.columns, so as arguments can be supplied to the constructor.  
# 8/9
# 70. ~ SimpleCSV.parse, back to the way it was at 0.9.7, since the call to read will never require the block argument as it never makes it there.  
# 71. Simplified the SimpleCSV eigenclass methods which were using open() by using new() instead, since this is more correct, more succinct, and more efficient.  
# 72. Added SimpleCSV eigenclass collection methods: collect, select, reject, detect.  I couldn't simply mixin Enumerable as I had with the instance methods, because I needed to be able to supply arguments other than a block.  
# 73. + in SimpleCSV, alias_method :read_csv_header, :read_header in SimpleCSV.  
# 74. + in SimpleCSV, alias_method :write_csv_header, :write_header.  
# 75. + in SimpleCSV, alias_method :write_csv_row, :write_row.  
# 76. + in SimpleCSV, alias_method :each_row, :each.  
# 77. - CSVFile, attr_reader :filename, :args.  
# 78. ~ CSVFile#mode, so as it makes use of the instance variable rather than the removed reader method args.  
# 79. ~ CSVFile#mode, so it may accept hyphenated options for the mode aliases: read-only, read-write, write-only.  
# 80. ~ CSVFile#permissions, so as it makes use of the instance variable rather than the removed reader method args.  
# 81. ~ CSVFile#filename, by memoizing it.  

require 'stringio'

$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), 'lib')))

require '_meta/blankQ'
require 'Array/extract_optionsX'
require 'Array/peek_options'
require 'Array/to_csv'
require 'Hash/to_csv'
require 'String/split_csv'

class SimpleCSV
  
  class << self
    
    def source_type(source)
      if File.exist?(source)
        CSVFile
      else
        CSVString
      end
    end
    
    def open(source, *args, &block)
      @csv_file = new(source, *args)
      if block
        begin
          yield @csv_file
          @csv_file
        ensure
          @csv_file.close
        end
      else
        @csv_file
      end
    end
    
    def each(source, *args, &block)
      new(source, *args).each(&block)
    end
    alias_method :foreach, :each
    
    def collect(source, *args, &block)
      new_collection = []
      each(source, *args){|row| new_collection << block.call(row)}
      new_collection
    end
    alias_method :map, :collect
    
    def select(source, *args, &block)
      new_collection = []
      each(source, *args){|row| new_collection << row if block.call(row)}
      new_collection
    end
    
    def reject(source, *args, &block)
      new_collection = []
      each(source, *args){|row| new_collection << row unless block.call(row)}
      new_collection
    end
    
    def detect(source, *args, &block)
      each(source, *args){|row| return row if block.call(row)}
    end
    
    def read(source, *args, &block)
      if block
        parse(source, *args, &block)
      else
        new(source, *args).read_csv
      end
    end
    alias_method :read_csv, :read
    
    def parse(source, *args, &block)
      if block
        each(source, *args, &block)
      else
        read(source, *args)
      end
    end
    alias_method :parse_csv, :parse
    
    def write(source, *args)
      new(source, *args).write_csv
    end
    alias_method :write_csv, :write
    
    def header_row(source, *args)
      new(source, *args).header_row
    end
    
    def first_row(source, *args)
      new(source, *args).first_row
    end
    
    def attributes(source, *args)
      new(source, *args).attributes
    end
    
    def columns(source, *args)
      new(source, *args).columns
    end
    
    def parse_line(raw_row, *args) # For FasterCSV compatibility.  
      options = args.extract_options!
      row_separator = options[:row_separator] || options[:row_sep] || "\n"
      column_separator = options[:column_separator] || options[:col_sep] || ','
      sc = SimpleCSV.new(raw_row, :quote => nil, :as_array => true, :row_separator => row_separator, :column_separator => column_separator)
      sc.parse_row(raw_row)
    end
    
  end # class << self
  
  include Enumerable
  
  attr_accessor :header_row, :mode, :quote, :row_separator, :selected_columns, :as_array, :rows
  
  def initialize(source, *args)
    @source = (
      if source.is_a?(String)
        SimpleCSV.source_type(source).new(source, *args).source
      else
        source
      end
    )
    options = args.extract_options!
    @header_row = options[:header_row] || options[:headers] || options[:header] || false
    @mode = options[:mode] || 'r'
    @quote = options[:quote] || nil
    @row_separator = options[:row_separator] || options[:row_sep] || "\n"
    @column_separator = options[:column_separator] || options[:col_sep] || ','
    @selected_columns = options[:selected_columns]
    @as_array = options[:as_array] || false
    if options[:columns]
      self.columns = options[:columns]
    else
      self.columns
    end
    @rows = []
  end
  
  def close
    @source.close
  end
  
  def read(*selected_columns, &block)
    if block
      parse(*selected_columns, &block)
    else
      read_header
      @source.each(@row_separator){|raw_row| @rows << parse_row(raw_row, *selected_columns)}
      (@source.rewind; @source.truncate(0)) if @mode == 'r+'
      @rows
    end
  end
  alias_method :read_csv, :read
  
  def read_header
    columns
    if header_row?
      (@source.rewind; @source.gets(@row_separator))
    else
      @source.rewind
    end
  end
  alias_method :read_csv_header, :read_header
  
  def parse(*selected_columns, &block)
    if block
      each(*selected_columns, &block)
    else
      read(*selected_columns)
    end
  end
  alias_method :parse_csv, :parse
  
  def columns
    @columns ||= (
      if header_row? && ['r', 'r+', 'a+'].include?(@mode) && first_row?
        columns, i = {}, -1
        first_row.split_csv(@quote, @column_separator, @row_separator).each do |column_name|
          if column_name.empty?
            columns[column_name].blank? ? columns[column_name] = [i += 1] : columns[column_name] << (i += 1)
          else
            columns[column_name] = (i += 1)
          end
        end
        columns
      else
        nil
      end
    )
  end
  
  def columns=(*column_order)
    @columns = {}
    column_order.flatten!
    if column_order[0].is_a?(Hash)
      column_order[0].each{|column_name, column_position| @columns[column_name.to_s] = column_position}
    else
      i = -1
      column_order.each{|column| @columns[column.to_s] = (i += 1)}
    end
  end
  
  def parse_row(raw_row, *selected_columns)
    parsed_row = {}
    i = -1
    if selected_columns.empty?
      if @columns.blank?
        raw_row.split_csv(@quote, @column_separator, @row_separator).each{|column_value| parsed_row[i += 1] = column_value}
      else
        raw_row.split_csv(@quote, @column_separator, @row_separator).each{|column_value| parsed_row[attributes[i += 1]] = column_value}
      end
    else
      selected_columns.flatten!
      case selected_columns[0]
      when Integer
        raw_row.split_csv(@quote, @column_separator, @row_separator).each{|column_value| parsed_row[i] = column_value unless !selected_columns.include?(i += 1)}
      else
        raw_row.split_csv(@quote, @column_separator, @row_separator).each{|column_value| parsed_row[attributes[i]] = column_value unless !selected_columns.include?(attributes[i += 1])}
      end
    end
    if @as_array
      if @columns.blank?
        (0..(parsed_row.size - 1)).inject([]){|a,i| a << parsed_row[i]}
      else
        attributes.collect{|attribute| parsed_row[attribute]}
      end
    else
      parsed_row
    end
  end
  
  def write(*selected_columns)
    write_header(*selected_columns) if header_row?
    each{|row| write_row(row, *selected_columns)}
  end
  alias_method :write_csv, :write
  
  def write_header(*selected_columns)
    selected_columns.flatten!
    if selected_columns.empty?
      write_row(attributes.to_csv)
    else
      write_row(columns.to_csv)
    end
  end
  alias_method :write_csv_header, :write_header
  
  def write_row(row, *selected_columns)
    collector = []
    selected_columns.flatten!
    unless attributes.blank?
      if selected_columns.blank?
        attributes.each{|attribute| collector << row[attribute] unless row[attribute].nil?}
      else
        selected_columns.each{|column| collector << row[column] unless row[column].nil?}
      end
      @source.puts(collector.to_csv(@quote))
    end
  end
  alias_method :write_csv_row, :write_row
  
  def each(*selected_columns)
    selected_columns.flatten!
    if @rows[0]
      if selected_columns.empty?
        rows.each{|row| yield row}
      else
        rows.each do |row|
          yield selected_columns.inject({}){|hash, column_name| hash[column_name] = row[column_name]; hash}
        end
      end
    else
      if selected_columns.empty?
        read_csv.each{|row| yield row}
      else
        read_csv(selected_columns).each do |row|
          yield selected_columns.inject({}){|hash, column_name| hash[column_name] = row[column_name]; hash}
        end
      end
    end
  end
  alias_method :each_row, :each
  
  def attributes
    @attributes ||= (
      if columns.blank?
        nil
      else
        a = []
        columns.each do |k,v|
          case v
          when Array
            v.each{|e| a << ['', e]}
          else
            a << [k, v]
          end
        end
        a.sort{|a,b| a[1] <=> b[1]}.collect{|a| a[0]}
      end
    )
  end
  
  def header_row?
    @header_row
  end
  
  def first_row
    @source.rewind
    return_value = @source.gets(@row_separator)
    @source.rewind
    return_value
  end
  alias_method :first_row?, :first_row
  
  def to_a
    read_csv unless @rows[0]
    if @as_array
      @rows
    elsif @columns.blank?
      result = []
      @rows.each do |row|
        a = []
        (0..(row.size - 1)).inject([]){|a,i| a << row[i]}
        result << a
      end
      result
    else
      @rows.collect do |row|
        attributes.collect{|attribute| row[attribute]}
      end
    end
  end
  
end # class SimpleCSV

class CSVFile < SimpleCSV
  
  class << self
    
    def open(source, *args, &block)
      @csv_file = CSVFile.new(source, *args)
      super(source, *args, &block)
    end
    
  end # class << self
  
  def initialize(filename, *args)
    @filename = filename
    @args = args
    super(source, *args)
  end
  
  def source
    @source ||= File.new(filename, mode, permissions)
  end
  
  def mode
    @mode ||= (
      case @args.peek_options[:mode].to_s
      when 'r', 'r+', 'w', 'w+', 'a', 'a+'; @args.peek_options[:mode].to_s
      when 'read_only', 'read-only', 'readonly'; 'r'
      when 'rw', 'read_write', 'read-write', 'readwrite'; 'r+'
      when 'write_only', 'write-only', 'writeonly'; 'w'
      when 'append'; 'a'
      else 'r'
      end
    )
  end
  
  def permissions
    @permissions ||= @args.peek_options[:permissions]
  end
  
  def filename
    @filename ||= File.expand_path(@filename)
  end
  
end # class CSVFile

class CSVString < SimpleCSV
  
  class << self
    
    def open(source, *args, &block)
      @csv_file = CSVString.new(source, *args)
      super(source, *args, &block)
    end
    
  end # class << self
  
  def initialize(string, *args)
    @string = string
    super(source, *args)
  end
  
  def source
    @source ||= StringIO.new(@string)
  end
  
end # class CSVString
