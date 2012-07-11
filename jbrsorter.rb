#! /usr/bin/ruby

# Read in a large file

# (To test, I need to generate 1 trillion random int32_ts and write those to a test file).
def generateTestFile( filename )
  File.new(filename, "w")
  .times do # Huh I guess I need to look up how to do scientific notation in Ruby...
    
  end
end


# Sort the numbers

# Write the lowest N numbers to a file
