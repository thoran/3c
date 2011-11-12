[
  {
    :warning => Proc.new{|parsed_row| "Names cannot be less than four characters...  #{parsed_row['Name']} is only #{parsed_row['Name'].size} characters."}, 
    :test => Proc.new{|parsed_row| parsed_row['Name'] && parsed_row['Name'].size >= 4}
  },
  {
    :warning => Proc.new{|parsed_row| "The code denoting state must be in the file states.csv (ie. in the range 1..8)...  #{parsed_row['State']} is outside this range."}, 
    :test => Proc.new{|parsed_row| parsed_row['State'].in?(state_codes)}
  },
  {
    :warning => Proc.new{|parsed_row| "The salary must be an integer and not a float...  #{parsed_row['Salary']} is not an integer."}, 
    :test => Proc.new{|parsed_row| parsed_row['Salary'] && parsed_row['Salary'].integer?}
  },
  {
    :error => Proc.new{|parsed_row| "The postcode must exist...  The postcode is missing."},
    :test => Proc.new{|parsed_row| parsed_row['Postcode'].not_nil?}
  }
]
