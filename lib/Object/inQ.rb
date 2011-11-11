# Object.inQ
# Object.in?

# 20110630
# 0.4.1

# Description: This is essentially the reverse of Enumerable.include?.  It can be pointed at any object and takes a collection as an argument.  

# History: Originally swiped from https://www.blogger.com/comment.g?blogID=11788780&postID=6218924972208019945 and then modified to include either an array or a list of arguments, but then I completely forgot that I'd already had this method in my toolkit and then a little over a month later rewrote 0.1.0 character perfect!  The rewritten one is now version 0.3.0 and 0.4.0, this one, is the synthesis; at least to the extent of adding and then extending the test suite.  

# Changes: 
# 1. Reformatting the case expression.  

class Object
  
  def in?(*a)
    case a[0]
    when Array
      a[0].include?(self)
    else
      a.include?(self)
    end
  end
  
end
