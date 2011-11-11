# Object#default_is

# 20100308
# 0.0.0

# Description: Enables a slightly more powerful assignment mechanism than does ||=, such that it will assign a default value to a variable if the parameterized source is nil, whereas ||= will only assign to the paramterized source if the variable is not already set.  

# History: Taken from Switches 0.9.9.  

# Dependencies: 
# 1. NilClass#default_is

class Object
  
  def default_is(o)
    self
  end
  alias_method :defaults_to, :default_is
  alias_method :default_to, :default_is
  alias_method :default, :default_is
  
end
