AstarDM = function(roads,car,packages) {
	unpickedIndex = which(packages[,5]==0 | packages[,5]==1)
	carPos = c(car$x,car$y)
	#sequence = findShorest(packages,carPos)
	if (car$load == 0){
		#car$mem[[1]] = sequence[[1]]
		packDist = matrix(NA,1,5)
      	for (i in unpickedIndex){
        	packPos = c(packages[i,1],packages[i,2])
        	packDist[i] = manhattan(carPos,packPos)
      	}
      	car$mem[[1]] = which.min(packDist)
	}
	else{
		car$mem[[1]] = car$load
	}

	
    goalPos = c(NA,NA)
    if (packages[car$mem[[1]],5] == 0){
      goalPos = c(packages[car$mem[[1]],1],packages[car$mem[[1]],2])
    }
    
    if (packages[car$mem[[1]],5] == 1){
      goalPos = c(packages[car$mem[[1]],3],packages[car$mem[[1]],4])
    }

    

    move = getNextMove(carPos,goalPos,roads)
    #print(move)

    if (all(carPos==move)){
        # print("wait!")
        car$nextMove=5
    }
      
    if (carPos[1]==move[1]){
        if (carPos[2] < move[2]){
          	car$nextMove=8 #up
        }
        else
          	car$nextMove=2 #down
    }
      
    if (carPos[2]==move[2]){
        if (carPos[1] < move[1]){
          	car$nextMove=6 #right
        }
    	else
        	car$nextMove=4 #left
    }
    return (car)
	
}

getNextMove = function(carPos,goalPos,roads){
	fromList = list()
	frontList = list()
	#cost = manhattan(carPos,goalPos)
	expendedNode = list(carPos,fromList,0,0,manhattan(carPos,goalPos))
	open = list(expendedNode)
  #open = open[[length(open)+1]] = expendedNode
	closed = list()
	#print("1")
	while(length(open)!=0){
		#find the node who has lowest F in open list
		temp = open[[1]][[3]]
		id = 1
		for (i in 1:length(open)){
			if (temp > open[[i]][[3]]){
				temp = open[[i]][[3]]
				id = i
			}
		}

    #delete the node from open list and add to colsed list
		current_node = open[[id]]
		open[[id]] = NULL
		closed[[length(closed)+1]] = current_node

    need_to_break = 0
		if (length(closed)>0){
			for (i in 1:length(closed)){
				if (all(closed[[i]][[1]] == goalPos)){
          need_to_break = 1
				}
			}
		}
    if (need_to_break == 1){
      break
    }

		
		neighbourList = getNeighbour(current_node[[1]])
		for(i in 1:4){
			current_neighbour = neighbourList[[i]]
			if (!(is.null(current_neighbour))){
				#print("3")
				d_g = neighbourCost(current_node[[1]],roads,current_neighbour)
		    dg = c(d_g[1],d_g[2]+current_node[[3]])
		    h = manhattan(current_neighbour,goalPos)
		    f = dg[2]+h

		    cur_neigh_in_closed = 0
				if(length(closed)>0){
					for (i in 1:length(closed)){
				        if (all(current_neighbour == closed[[i]][[1]])){
				        	cur_neigh_in_closed = 1
				        	break
				        }    		
		      }
				}
				if (cur_neigh_in_closed == 1){
					next
				}
				else{
					if (length(open)>0){
						cur_neigh_in_open = 0
						neigh_in_open_id = 0
					    for (i in 1:length(open)){
					       	if (all(current_neighbour == open[[i]][[1]])){
					       		cur_neigh_in_open = 1
					       		neigh_in_open_id = i
					       		#print("aa")
					       		break			        		
					        }
					    }
					    if (cur_neigh_in_open==1){
					    	if (f<=open[[neigh_in_open_id]][[3]]){
					    		  fromList = current_node[[2]]
				        		fromList[[length(fromList)+1]] = current_node[[1]]
				        		open[[neigh_in_open_id]] = list(current_neighbour,fromList,f,dg,h)
				        		#open[[neigh_in_open_id]][[2]] = fromList
				        		#open[[neigh_in_open_id]][[3]] = f

					    	}
					    }
					    else{
					    	fromList = current_node[[2]]
				        fromList[[length(fromList)+1]] = current_node[[1]]
                open[[length(open)+1]] = list(current_neighbour,fromList,f,dg,h)
					    }
					}
					else{
						fromList = current_node[[2]]
				      fromList[[length(fromList)+1]] = current_node[[1]]
					    open[[length(open)+1]] = list(current_neighbour,fromList,f,dg,h)
					}
		    }
			}
		}
	}
	#print(current_node[[2]])
	l = length(current_node[[2]])
	current_node[[2]][[l+1]] = goalPos
	if(length(current_node[[2]])>1){
	 move = current_node[[2]][[2]]
	}
	else{
		move = current_node[[2]][[1]]
	}
  #print(move)
	return (move)
}






	

manhattan = function(pos1,pos2)
  return (1*(abs(pos1[1]-pos2[1]) + abs(pos1[2]-pos2[2]))) 

#get existing neighbours' coordinates
getNeighbour = function(node){ 
  if (node[1] > 1)
    ln = c(node[1]-1,node[2])
  else
    ln = NULL
  if (node[1] < 10)
    rn = c(node[1]+1,node[2])
  else
    rn = NULL
  if (node[2] > 1)
    dn = c(node[1],node[2]-1)
  else
    dn = NULL
  if (node[2] < 10)
    un = c(node[1],node[2]+1)
  else
    un = NULL
  return (list(ln,rn,dn,un))
}

#get actual cost to get to a neighbour
neighbourCost = function(pos1,roads,pos2){ 
  # pre: manhattan (pos1,pos2) <= 1
  if (pos1[1] == pos2[1] && pos1[2] == pos2[2]){
    cost  = 0
    d = 0
    print("THIS SHOULD NOT HAPPEN: NEIGHBOUR CAN NOT BE YOURSELF!")
  }
  else if(pos1[2] == pos2[2]){
    if (pos1[1] > pos2[1]){
      cost = roads$hroads[pos1[2],pos1[1]-1] #left
      d = 4
    }
    else{
      cost = roads$hroads[pos1[2],pos1[1]] #right
      d = 6
    }
  }
  else{ #(pos1[1] == pos2[1])
    if (pos1[2] > pos2[2]){
      cost = roads$vroads[pos1[2]-1,pos1[1]] #down
      d = 2
    }
    else{
      cost = roads$vroads[pos1[2],pos1[1]] #up
      d = 8
    }
  }
  #print(cost)
  return (c(d,cost))
}

findShorest = function(packages,carPos){
  packNum = length(packages[,1])
  cost = 0
  temp = 0
  cur_id = 0
  permutationList = permutations(packNum)
  print(permutationList)
  for(i in 1:nrow(permutationList)){
    #print(cost)
    for(j in 1:packNum){
      c = permutationList[i,j]
      #print(paste("c: ",c))
      if(j==1){        
        cost = cost + manhattan(carPos,c(packages[c,1],packages[c,2]))
        #print(paste("cost,j=1: ",cost))
      }
      else{
        pre = permutationList[i,j-1]
        cost = cost + manhattan(c(packages[pre,3],packages[pre,4]),c(packages[c,1],packages[c,2]))
        cost = cost + manhattan(c(packages[c,1],packages[c,2]),c(packages[c,3],packages[c,4]))
        #print(manhattan(c(packages[pre,3],packages[pre,4]),c(packages[c,1],packages[c,2])))
        #print(paste("cost: ",cost))
      }
    }
    #print(temp)
    #print(cost)
    if(temp==0){
      temp = cost
      cur_id = i
    }
    else{
      if(temp>cost){
        temp = cost
        cur_id = i
      }
    }
    cost = 0
    #print("----")   
  }
  return(permutationList[cur_id,])
}



average_turns = function(){
  sum = 0
  for (i in 1:1000){
      j = runDeliveryMan(carReady = AstarDM,dim=10,turns=2000,doPlot=FALSE,pause=0,del=5)
      sum = sum + j
      print(i)
  }
  average = sum/1000

  return (average)
}






