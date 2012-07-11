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
    node = nodeArray.first
    while 1 do
      result = placeNodeNearClosestNode( node, value )
      if( result == 0 )
        break
      elsif( result == -1 )
        node = node.leftNode
      elsif( result == 1 )
        node = node.rightNode
      end
    end
  else
    # First value
    nodeArray.push( TreeNode.new(value, nil, nil) )
    self.lowestValue = nodeArray.first
  end
end

# Returns -1 if the base's lowestNode needs to be searched
# Returns 0 if the search is complete
# Returns 1 if the base's rightNode needs to be searched
def placeNodeNearClosestNode( base, value )
  result = 0
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
         result = -1
      end
    else
      # Add as left node with current as right
      node = TreeNode.new(value, nil, base) 
      nodeArray.push(node)
      base.leftNode = node
      self.lowestValue = node
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
        result = 1
      end
    else
      # Add as right node with current as left
      node = TreeNode.new(value, base, nil)
      nodeArray.push(node)
      base.rightNode = node
    end
  end
  return result
end

end

# Write the lowest N numbers to a file

def sortFile( filename, numberOfValuesToOutput )
  treeController = TreeController.new
  # Load each line into memory and add it to the right place in tree 
  file = File.open( filename, "r" )
  file.each_line do | line |
    # For now I'll just treat my small test file as a small file and read it all into memory
    # (Actually, I'm not sure if that's the case. If Ruby just uses a file pointer then 
    #  maybe it's just reading in line by line, in which case this is already efficient. )
    # Ultimately, I would move to a different approach:
    # Read in large but manageable chunks of the input at a time.
    treeController.addValueToTree( line.to_s.chomp.to_f)
  end
  
  outFile = File.new( "output-#{filename}", "w" )
  node = treeController.lowestValue
  numberOfValuesToOutput.times do
    outFile.puts node.payload.to_s
    node = node.rightNode
  end
  
end

sortFile( "testfile.txt", 50 )