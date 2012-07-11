#! /usr/bin/ruby

# Read in a large file

# (To test, I need to generate 1 trillion random int32_ts and write those to a test file).
def generateTestFile( filename )
  File.new(filename, "w")
  file = File.open(filename, "w")
  100.times do # Okay for expediency's sake I'll use a set of 100
    file.puts rand().to_s
  end
  file.close
end


# Sort the numbers

# Write the lowest N numbers to a file

generateTestFile( "testfile.txt" )