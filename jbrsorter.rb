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
    self.leftNode = left
    self.rightNode = right
  end
  
  def to_s
    left = ""
    right = ""
    if leftNode
      left = leftNode.payload.to_s
    end
    if rightNode
      right = rightNode.payload.to_s
    end
    return "Left: " + left + " Value: " + self.payload.to_s + " Right: " + right
  end
end

class TreeController
  attr_accessor :nodeArray, :lowestValue
  
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
    lowestValue = nodeArray.first
  end
end

def placeNodeNearClosestNode( base, value )
  if( value <= base.payload )
    if( base.leftNode )
      # Check if we're still less than the one to the left
      if( value > base.leftNode.payload)
        #insert
        # Add as left node with current as right
        # Set the old leftNode's right as the current
        # Set the current's left node as the old leftNode
        node = TreeNode.new(value, base.leftNode, base) 
        nodeArray.push(node)
        base.leftNode.rightNode = node
        base.leftNode = node
      else
        placeNodeNearClosestNode( base.leftNode, value )
      end
    else
      # Add as left node with current as right
      node = TreeNode.new(value, nil, base) 
      nodeArray.push(node)
      base.leftNode = node
      lowestValue = node
    end
  elsif( value > base.payload )
    if( base.rightNode)
      # Check if we're still more than the one to the right
      if( value <= base.rightNode.payload)
        #insert
        # Add as right node with current as left
        # Set the old rightNode's left as the current
        # Set the current's left node as the old leftNode
        node = TreeNode.new(value, base, base.rightNode)
        nodeArray.push(node)
        base.rightNode.leftNode = node
        base.rightNode = node
      else
        placeNodeNearClosestNode( base.rightNode, value )
      end
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
  treeController = TreeController.new
  # Load each line into memory and add it to the right place in tree 
  file = File.open( filename, "r" )
  file.each_line do | line |
    # For now I'll just treat my small test file as a small file and read it all into memory
    treeController.addValueToTree( line.to_s.chomp.to_f)
  end
end
   
sortFile( "testfile.txt" )