# Hash#to_csv

# 2010.05.21
# 0.9.1

# Changes: 
# 1. - Hash#write.  
# 2. ~ Hash#to_csv, a significant reduction in complexity.  
# 0/1
# 3. /desired_columns/selected_columns/.  

# Todo: 
# 1. Split all these up and move each method into Array...  Done as of 0.9.0.  
# 2. Tidy the splat stuff with that technique from recently!?...  Done/made redundant as of 0.9.0.  

require 'Array/extract_optionsX'
require 'Array/to_csv'

class Hash
  
  def to_csv(*args)
    options = args.extract_options!
    quote = options[:quote]
    selected_columns = options[:selected_columns]
    collector = []
    if selected_columns
      selected_columns.each{|column| collector << self[column]}
    else
      self.each{|k,v| collector << self[v]}
    end
    collector.to_csv(quote)
  end
  
end
