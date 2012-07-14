#! /usr/bin/ruby

class Node
  attr_accessor :payload, :leftNode, :rightNode

  def initialize( value, left, right )
    self.payload = value
    self.leftNode = left
    self.rightNode = right
  end
  
  def to_s # For debugging
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

# Handles management of the nodes
# The nodes are stored in nodeArray
# lowestValue stores the node with the lowest payload value found in the search
# highestValue stores the node with the highest payload value found in the search
# numberOfValuesToOutput is the max number of sorted, ascending values to store
class NodeController
  attr_accessor :nodeArray, :lowestValue, :highestValue, :numberOfValuesToOutput
  
  def initialize( numberOfValuesToOutput )
    self.nodeArray = Array.new
    self.lowestValue = nil
    self.highestValue = nil
    self.numberOfValuesToOutput = numberOfValuesToOutput
  end
  
def valueTooHigh?( value )
  result = false
 	# Check if we even need to add this value
  	if( nodeArray.count >= self.numberOfValuesToOutput )
  	  # We already have the max number of entries we want to report
  	  if( value >= self.highestValue.payload )
  		# This value is too large, discard it
  		result = true
  	  end
    end
  return result
end

def addValueToNodes( value )
  # Find the right location for this value
    
  # First, check to make sure we even want to store this
  if( valueTooHigh?( value ) )
    # We've already stored enough values, this one would never be reported
    return
  end
    
  if nodeArray.count > 0
    # I'm arbitrarily starting from the first input number
    node = nodeArray.first
    while 1 do
      result = placeNodeNearClosestNode( node, value )
      if( result == 0 ) # new node successfully placed
        break
      elsif( result == -1 ) # value is <= leftNode, search down
        node = node.leftNode
      elsif( result == 1 ) # value is > rightNode, search up
        node = node.rightNode
      end
    end
  else
    # First value
    nodeArray.push( Node.new(value, nil, nil) )
    self.lowestValue = nodeArray.first # Well, it's the lowest for now...
    self.highestValue = nodeArray.first # Ditto for highest
  end
end

# Returns -1 if the base's lowestNode needs to be searched
# Returns 0 if the search is complete
# Returns 1 if the base's rightNode needs to be searched
def placeNodeNearClosestNode( base, value )
  result = 0
  if( value <= base.payload )
    if( base.leftNode )
      # Check if we're still less than the node to the left
      if( value > base.leftNode.payload)
        # Time to insert a node between leftNode and base:
        # Add a new node with leftNode as its left and base as its right
        # Set the old leftNode's rightNode to be the new node
        # Set the base's left node to be the new node
        node = Node.new(value, base.leftNode, base) 
        nodeArray.push(node)
        base.leftNode.rightNode = node
        base.leftNode = node
      else
         result = -1 # Continue searching to the left
      end
    else
      # The base is the current minimum
      # Add a new far left node with the base to its right
      node = Node.new(value, nil, base) 
      nodeArray.push(node)
      base.leftNode = node
      self.lowestValue = node # Update the lowest value counter with this new low
    end
  elsif( value > base.payload )
    if( base.rightNode)
      # Check if we're still more than the node to the right
      if( value <= base.rightNode.payload)
        # Time to insert a node between base and rightNode:
        # Add a new node with current as its left and rightNode as its right
        # Set the old rightNode's leftNode to be the new node
        # Set the base's right node to be the new node
        node = Node.new(value, base, base.rightNode)
        nodeArray.push(node)
        base.rightNode.leftNode = node
        base.rightNode = node
      else
        result = 1 # Continue searching to the right
      end
    else
      # The base is the current maximum
      # Add a new far right node with the base to its left
      node = Node.new(value, base, nil)
      nodeArray.push(node)
      base.rightNode = node
      self.highestValue = node # Update the highest value counter with this new max
    end
  end
  return result
end

end

# To really test, I'd need to generate 1 trillion random int32_ts and write those to a test file.
# This is outputting a small set of floats, instead, but the principle's the same
# I'll come back to this this later
def generateTestFile( filename )
  File.new(filename, "w")
  file = File.open(filename, "w")
  100.times do # For expediency's sake I'll use a set of 100
    file.puts rand().to_s
  end
  file.close
end

# Write the lowest N numbers to a file
def sortFile( filename, numberOfValuesToOutput )
  nodeController = NodeController.new( numberOfValuesToOutput )
  # Load each line into memory and add it to the right place in the nodes 
  file = File.open( filename, "r" )
  file.each_line do | line |
    nodeController.addValueToNodes( line.to_s.chomp.to_f)
  end
  
  # Write the output nodes to disk bottom-up, but only up to a specified number of values
  outFile = File.new( "output-#{filename}", "w" )
  node = nodeController.lowestValue
  numberOfValuesToOutput.times do
    # Travel the right nodes upwards from the node with the lowest value found
    outFile.puts node.payload.to_s
    node = node.rightNode
  end
  
end

# Execution
sortFile( "testfile.txt", 50 )