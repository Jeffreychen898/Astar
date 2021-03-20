Node Astar(IntPair start, IntPair stop) {
  
  ArrayList<Node> open_list = new ArrayList<Node>();
  HashMap<Integer, Node> closed_list = new HashMap<Integer, Node>();
  HashMap<Integer, Node> open_set = new HashMap<Integer, Node>();
  //create the start node
  float heuristic = dist(start.first, start.second, stop.first, stop.second);
	Node beginNode = new Node(start.first, start.second, 0, heuristic, null);
  open_list.add(beginNode);
  open_set.put(start.second * tilemap[0].length + start.first, beginNode);
  
  Node result = AstarRun(open_list, closed_list, open_set, stop);
  //reverse linked list
  Node previous = null;
  Node current = result;
  while(current != null) {
    Node next = current.parent;
    current.parent = previous;
    previous = current;
    current = next;
  }
  return previous;
}
Node AstarRun(ArrayList<Node> open_list, HashMap<Integer, Node> closed_list, HashMap<Integer, Node> open_set, IntPair goal) {
  if(open_list.size() == 0) {
    return null;
  }
	//find the smallest node in open list
  Node chosen_node = null;
  int chosen_index = -1;
  for(int i=0;i<open_list.size();i++) {
    if(chosen_node == null) {
      chosen_node = open_list.get(i);
      chosen_index = i;
      continue;
    }
    if(chosen_node.gcost > open_list.get(i).gcost) {
      chosen_node = open_list.get(i);
      chosen_index = i;
    }
  }
	//store in closed list
  open_list.remove(chosen_index);
  open_set.remove(chosen_index);
  closed_list.put(chosen_node.location.second * tilemap[0].length + chosen_node.location.first, chosen_node);

	//get neighbors
  IntPair[] neighbors = getNeighbors(chosen_node.location);
  
	//check if equal goal
	for(IntPair neighbor : neighbors) {
    if(neighbor != null) {
      if(neighbor.first == goal.first && neighbor.second == goal.second) {
        Node goalNode = new Node(goal.first, goal.second, chosen_node.gcost + getGcost(chosen_node.location, goal), 0, chosen_node);
        return goalNode;
      }
    }
  }

  //process neighbors
  for(IntPair neighbor : neighbors) {
    if(neighbor != null) {
      //create the node
      float new_node_gcost = chosen_node.gcost + getGcost(chosen_node.location, neighbor);
      float new_node_hcost = dist(neighbor.first, neighbor.second, goal.first, goal.second);
      Node new_node = new Node(neighbor.first, neighbor.second, new_node_gcost, new_node_hcost, chosen_node);
      //check for originality
      if(originalityTest(new_node, open_set) && originalityTest(new_node, closed_list)) {
        //add to open list
        open_set.put(neighbor.second * tilemap[0].length + neighbor.first, new_node);
        open_list.add(new_node);
      }
    }
  }

  Node result = AstarRun(open_list, closed_list, open_set, goal);
  return result;
}
boolean originalityTest(Node node, HashMap<Integer, Node> set) {
  int get_key = node.location.second * tilemap[0].length + node.location.first;
  if(set.containsKey(get_key)) {
    Node existingNode = set.get(get_key);
    if(existingNode.gcost > node.gcost) {
      existingNode.gcost = node.gcost;
      existingNode.parent = node.parent;
    }
    return false;
  }
  return true;
}
float getGcost(IntPair parentNode, IntPair thisNode) {
  float a_squared = thisNode.first - parentNode.first;
  float b_squared = thisNode.second - parentNode.second;
  a_squared = abs(a_squared);
  b_squared = abs(b_squared);
  return sqrt(sq(a_squared) + sq(b_squared));
}
IntPair[] getNeighbors(IntPair location) {
  IntPair neighbors[] = new IntPair[8];
  //create neighbors
  neighbors[0] = new IntPair(-1, -1);
  neighbors[1] = new IntPair( 0, -1);
  neighbors[2] = new IntPair( 1, -1);
  neighbors[3] = new IntPair(-1,  0);
  neighbors[4] = new IntPair( 1,  0);
  neighbors[5] = new IntPair(-1, 1);
  neighbors[6] = new IntPair( 0, 1);
  neighbors[7] = new IntPair( 1, 1);
  //set x and y
  for(int i=0;i<neighbors.length;i++) {
    neighbors[i].first += location.first;
    neighbors[i].second += location.second;
    if(neighbors[i].first >= tilemap[0].length || neighbors[i].first < 0 || neighbors[i].second >= tilemap.length || neighbors[i].second < 0) {
      neighbors[i] = null;
    }
  }
  //check if on wall block
  for(int i=0;i<neighbors.length;i++) {
    if(neighbors[i] != null) {
      if(tilemap[neighbors[i].second][neighbors[i].first] == 1) {
        neighbors[i] = null;
      }
    }
  }
  return neighbors;
}

class IntPair {
	int first;
	int second;
	IntPair(int f, int s) {
		first = f;
		second = s;
	}
}
class Node {
	IntPair location;
	float gcost;
	float hcost;
	Node parent;
	Node(int x, int y, float g, float h, Node p) {
		gcost = g;
		hcost = h;
		parent = p;
		location = new IntPair(x, y);
	}
}
