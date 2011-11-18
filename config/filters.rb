{
  :clean => Proc.new{|e| e[:warnings].empty? && e[:errors].empty?},
  :unclean => Proc.new{|e| !e[:warnings].empty? || !e[:errors].empty?},
  :warnings => Proc.new{|e| !e[:warnings].empty?},
  :no_warnings => Proc.new{|e| e[:warnings].empty?},
  :errors => Proc.new{|e| !e[:errors].empty?},
  :no_errors => Proc.new{|e| e[:errors].empty?},
  :everything => Proc.new{|e| true}
}
