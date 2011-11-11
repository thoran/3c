# Array#to_csv

# 2011.03.07
# 0.9.3

# Todo: 
# 1. Split all these up and move each method into Array...  Done as of 0.9.0.  
# 2. ~ Array#to_csv, massive refactor, including getting rid of a lot of aliases for now at least.  Done as of 0.9.0.  

# Changes since 0.8: 
# 1. Has it's own file now.  
# 0/1
# 2. Removed all the require lines for the array methods since these are simple operations.  So, I am now doing the quoting directly, since quote_each() which calls wrap_each() which in turn calls wrap() is lots of extra method calls.  
# 2/3
# 3. + require '_meta/default_to' && making use of it in the case test, since if I explicitly supply nil, then the quote is not set to double in the argument definition.  

require '_meta/default_to'

class Array
  
  def to_csv(quote = :double)
    case quote.default_to(:double).to_sym
    when :double
      self.collect{|e| '"' + e + '"'}.join(',')
    when :spacey_double
      self.collect{|e| '"' + e + '"'}.join(', ')
    when :single
      self.collect{|e| "'" + e + "'"}.join(',')
    when :spacey_single
      self.collect{|e| "'" + e + "'"}.join(', ')
    when :none, :unquoted
      self.join(',')
    when :spacey_none, :spacey_unquoted
      self.join(', ')
    end
  end
  
end
