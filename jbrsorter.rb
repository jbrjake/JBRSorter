#! /usr/bin/ruby

# (To test, I need to generate 1 trillion random int32_ts and write those to a test file).
# This is outputting floats, instead, but the principle's the same so I'll come back to this later
def generateTestFile( filename )
  File.new(filename, "w")
  file = File.open(filename, "w")
  100.times do # Okay for expediency's sake I'll use a set of 100
    file.puts rand().to_s
  end
  file.close
end

# Read in a large file
# Okay this pass at it would not work for large files (seek time would be ridiculous), but it lets me get to the fun part, sorting.
# Eventually I see it working by chunking up the file load by a certain number of lines, and pre-loading them into an array
# Then it would only have to read the file every "certain number of lines".
def loadNumberFromFile( filename, n )
  file = File.open(filename, "r")
  while file.lineno < n - 1
    file.gets
  end 
  theNum = file.gets
  file.close
  return theNum
end

# Sort the numbers

class TreeNode
  attr_accessor :payload, :leftNode, :rightNode

  def initialize( value, left, right )
    self.payload = value
    self.leftNode = leftNode
    self.rightNode = rightNode
  end
  
end

class TreeController
  attr_accessor :nodeArray
  
  def initialize
    self.nodeArray = Array.new
  end
  
def addValueToTree( value )
  if nodeArray.count > 0
    # Find the right location for this value
    placeNodeNearClosestNode( nodeArray.first, value )
  else
    # First value
    nodeArray.push( TreeNode.new(value, nil, nil) )
  end
end

def placeNodeNearClosestNode( base, value )
  if( base.payload <= value )
    if( base.leftNode )
      # Check if we're still less than the one to the left
      placeNodeNearClosestNode( base.leftNode, value )
    else
      # Add as left node with current as right
      node = TreeNode.new(value, nil, base) 
      nodeArray.push(node)
      base.leftNode = node
    end
  elsif( base.payload > value )
    if( base.rightNode)
      # Check if we're still more than the one to the right
      placeNodeNearClosestNode( base.rightNode, value)
    else
      # Add as right node with current as left
      node = TreeNode.new(value, base, nil)
      nodeArray.push(node)
      base.rightNode = node
    end
  end
end

end

# Write the lowest N numbers to a file

# generateTestFile( "testfile.txt" )

# puts loadNumberFromFile( "testfile.txt", 5 )

def sortFile( filename )
  # Load each line into memory and add it to the right place in tree 
end
   
# sortFile( filename )