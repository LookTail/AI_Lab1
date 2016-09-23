# The Delivery Man Lab Assignment

### 1. Group Information

**Group 20:**

Lu Yu			
Mengdi Xue		
Qiaowei Ni		
Xiaoyu Zhou		

### 2. Theoretical overview of the A* algorithm

A* algorithm is a typical example in artificial intelligence and was wildly used in games. It’s also a typical heuristic algorithm. In order to introduce A* algorithm, we would like to describe what is heuristic algorithm first.

**Heuristic algorithm search** is to evaluate every searched position’s value and find the optimal one. Then continue doing this with each optimal position. Compared to breadth-first search and depth-first search, it omitted such a large number of senseless search path and improve the efficiency. In heuristic algorithm search, the evaluate to position is of great importance. Different evaluation lead to different results.

The evaluation function of heuristic algorithm is:

* f(n)=g(n)+h(n)

f(n) is the evaluation function of node n, g (n) is the actual cost of the state space from the initial node to node n and h (n) is an estimate of the best path’s cost from node n to the target node. h(n) reflects the main heuristic information of the research because it is known. To be specific, g(n) represents the priority trends of the breadth search. In order to improve the efficiency, g(n) can be omitted when h(n) >> g(n).

In fact, there are lots of heuristic search algorithms, such as local preferential search method, the best-first search, and so on. Of course, A* algorithm is also belong to heuristic search algorithm. Though these algorithms use heuristic function, they have different strategies to select the best search node. Like local preferred search method, the search is in the process of selecting the "best node" and discard father nodes and other nodes and keep searching it. It is obvious to see that since the abandoned of other nodes, the best nodes may also be discarded because the best node at this stage doesn’t means the best node overall. Best priority search is more intelligent. It doesn’t abandon the nodes (unless the node is dead). It compares the evaluation of the current node and previous node and choose the best node at each step. Its effective to keep the best node from lost. A* algorithm is one of the best priority algorithm with bound conditions.

The evaluation function of A* algorithm is:

* f’(n)=g’(n)+h’(n)

f’(n) is the evaluation function, g’(n) is the shortest path value between starting point and the end, h’(n) is the heuristic value of the shortest path between n and the end. For we cann’t know the value of f’(n), we use the previous valuation f(n) to be the approximate value, g(n) take place of g’(n) when g(n) >=g’(n) and h(n) take place of h’(n) when h(n) <= h’(n).

The value of h(n) is in fact a constraint condition when estimate a node. The more information or the constrains condition, the more nodes will be excluded and the algorithm will be better. But in developing a game, according to the real-time issues, it will be more time consuming with a large number of information about h(n). It should reduce the information of h(n) properly, that is to reduce the constraints. But the accuracy of the algorithm will be worse at the same time, here we should trade off.

### 3. Discussion of the A* search algorithm we implemented

In the A* search algorithm we implemented, there are some items should be introduced first:

* OPEN list: this is a list for storing the nodes which do not evaluate yet.
* CLOSED list: this is a list for storing the nodes which already evaluated.
* F (n): The heuristic used to evaluate distances in A*.
* G (n): The cost of the path from the starting point to any node n.
* H (n): The estimated cost from node n to the goal. We use Manhattan Distance as H(n). Because every time before the delivery man executing the next instruction, the conditions of road will change.  Manhattan Distance is the only way to work out a stable distance bewteen ROUTE NODE and goal. This is the reason why we choose it.

The description of our A* algorithm is as following:

Initially, the only node, which is included the OPEN list, is the starting node. And the CLOSED list is empty.

Then there is a main loop :

1. Pull out the best node, which means the node with the lowest value of F (n), in OPEN list. And this node is named as ROUTENODE.
2. Remove the ROUTENODE from OPEN list, and put it into the CLOSED list.
3. There are three types for each neighbor of ROUTENODE:
	1. If it cannot be available or already in CLOSED list, then ignore this node.
	2. If it is not included in OPEN list, then put it into the list. And regard the ROUTENODE as its PARENTNODE. Finally, evaluate this node, record its F (n), G (n), H (n). (The PARENTNODE is used for recording the neighbor of ROUTENODE).
	3. If it is already in OPEN list, this means we visited this node before, and we can access to this node from its PARENTNODE directly. In this situation, we have two ways to reach this node. Now we have to choose a better one, the lower value. To do this, assume that the ROUTENODE is this node’s PARENTNODE. Then calculate the value of G (n) of this node (if this node is already in OPEN list, it means that it have one PARENTNODE and a value of G (n).). Next, we should choose the lower value of G (n) as its value of G (n). Because lower value means better route. Last, if this node has a lower value of G (n), we regard the PARENTNODE of this node as ROUTENODE, and calculate the new values of H (n) and F (n). Otherwise, we do nothing.

4. When you put the goal into CLOSED list, it means you make it, and find a route to this goal successfully. When there is nothing in OPEN list, and you still do not put the goal into CLOSED list, it means there is no way to access to this goal.

### 4. Discussion of not A* strategies we made use of to improve our performance

#### A. Dynamic Programming

At first we wanted to implement a dynamic programming to improve the performance. The structure of the dynamic programming is like below: (take del=3 as an example)

![pic](https://cl.ly/001X1X3H3f0J/%E5%9B%BE%E7%89%87%201.png)

It seemed very reasonable. The numbers in the picture represent the package numbers. The arrows between every two layers represent the Manhattan distance between the delivery point of the former package and the place of the pointed package. So if we can find a shortest Manhattan path to deliver all packages, the total steps will be less than or at least equal to the Manhattan path of delivering from package one to five sequentially. But after we did some coding work, the result seemed not pleased.

In this graph, it only considered the situation in which the next package shouldn’t be the same as the current package. But it didn’t consider the situation in which, for example, the shortest path from layer 1 to layer 2 is package 1 to package 2, but the shortest path from layer 2 to layer 3 is package 2 to package 1, so that it picked up two duplicate packages. Actually, there must be ways to set some conditions in order to prevent this situation, but time is limited so that we don’t have enough time to implement it. If we have more time, I think we can figure it out.

#### B. Brute Force Programming

We also thought about Brute force programming to solve this path problem. There is a interface in R to generate full permutation. So we generate all circumstances of the routes and calculate the distances in every route and compare them together. At last we choose the shortest path and put them in order in an array, passing the array of the packages back to the main function.

Then we tried to implement that. But after we implemented it, the result steps seemed arise so we abandon that method. We left the code in the file. The function named “findShorest”.
