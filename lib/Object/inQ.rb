# Object/self.inQ
# Object.in?

# 20111114
# 0.5.0

# Description: This is essentially the reverse of Enumerable.include?.  It can be pointed at any object and takes a collection as an argument.  

# Changes: 
# 1. Using Enumerable#flatten instead of testing the first argument in the argument list, since ths makes the code much shorter.  

class Object
  
  def in?(*a)
    a.flatten.include?(self)
  end
  
end
