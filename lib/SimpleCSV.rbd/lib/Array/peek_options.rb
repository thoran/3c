# Array#peek_options

# 20100308
# 0.1.0

# History: Originally called #extract_options (no exclamation mark), but written again a few days ago for Switches as #peek_options.  #extract_options has been moved to #extract_options! as an alias for it.  

class Array
  
  def peek_options
    last.is_a?(::Hash) ? last : {}
  end
  
end
