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

  def init( value, left, right )
    self.payload = value
    self.leftNode = leftNode
    self.rightNode = rightNode
  end
  
end

class TreeController
  attr_accessor :nodeArray
  
  def init
    nodeArray = []
  end
  
def addValueToTree( value )
  if nodeArray.size > 0
    # Find the right location for this value
    placeNodeNearClosestNode( nodeArray.first, value )
  else
    # First value
    nodeArray.push( TreeNode.new(value, nil, nil) )
  end
end

def placeNodeNearClosestNode( base, value )
  if( base.payload <= value )
    if( base.left )
      # Check if we're still less than the one to the left
      findNearestNode( base.left, value )
    else
      # Add as left node with current as right
      node = TreeNode.new(value, nil, base) 
      nodeArray.push(node)
      base.left = node
    end
  elsif( base.payload > value )
    if( base.right)
      # Check if we're still more than the one to the right
      findNearestNode( base.right, value)
    else
      # Add as right node with current as left
      node = TreeNode.new(value, base, nil)
      nodeArray.push(node)
      base.right = node
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