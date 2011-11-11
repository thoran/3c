# OpenStruct#to_h

# 20100218
# 0.0.1

# Description: It introspects on an OpenStruct instance and constructs a hash from the members of the object.  

# Changes: 
# 1. I left 0.0.0 there even though just as I'd written I realised that @table was already a hash, because this is so funny.  

class OpenStruct
  
  def to_h
    @table
  end
  
end

if __FILE__ == $0
  require 'ostruct'
  os = OpenStruct.new
  os.foo = 'foo'
  os.bar = 'bar'
  puts (os.to_h == {:foo => 'foo', :bar => 'bar'} ? '.' : 'x')
end
