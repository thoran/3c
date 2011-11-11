# String#integer?

# 20070622
# 0.0.0

class String
  
  def integer?
    self =~ /^\d+$/ ? true : false
  end
  
end

if $0 == __FILE__
  'string'.integer?
  '9.0'.integer?
  '9'.integer?
  '99'.integer?
end
