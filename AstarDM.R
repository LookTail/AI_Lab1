AstarDM = function(roads,car,packages) {
	unpickedIndex = which(packages[,5]==0 | packages[,5]==1)
	carPos = c(car$x,car$y)
	if (car$load == 0){
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

	dir = c(NA,NA)
    goalPos = c(NA,NA)
    if (packages[car$mem[[1]],5] == 0){
      goalPos = c(packages[car$mem[[1]],1],packages[car$mem[[1]],2])
    }
    
    if (packages[car$mem[[1]],5] == 1){
      goalPos = c(packages[car$mem[[1]],3],packages[car$mem[[1]],4])
    }

    if ((carPos[1]-goalPos[1])==0){
    	if ((carPos[2]-goalPos[2])>0){
    		dir = c(2,NULL)
    	}
    	if ((carPos[2]-goalPos[2])<0){
    		dir = c(8,NULL)
    	}
    	if ((carPos[2]-goalPos[2])==0){
    		dir = c(NULL,NULL)
    	}
    }
    if ((carPos[1]-goalPos[1])<0){
    	if ((carPos[2]-goalPos[2])>0){
    		dir = c(2,6)
    	}
    	if ((carPos[2]-goalPos[2])<0){
    		dir = c(8,6)
    	}
    	if ((carPos[2]-goalPos[2])==0){
    		dir = c(6,NULL)
    	}
    }
    if ((carPos[1]-goalPos[1])>0){
    	if ((carPos[2]-goalPos[2])>0){
    		dir = c(2,4)
    	}
    	if ((carPos[2]-goalPos[2])<0){
    		dir = c(8,4)
    	}
    	if ((carPos[2]-goalPos[2])==0){
    		dir = c(4,NULL)
    	}
    }

    move = getNextMove(carPos,goalPos,roads,dir)
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

getNextMove = function(carPos,goalPos,roads,dir){
	fromList = list()
	frontList = list()
	cost = manhattan(carPos,goalPos)
	expendedNode = list(carPos,fromList,0,0,manhattan(carPos,goalPos))
	open = list(expendedNode)
	closed = list()
	#print("1")
	while(length(open)!=0){
		
		temp = open[[1]][[3]]
		id = 1
		for (i in length(open)){
			if (temp > open[[i]][[3]]){
				temp = open[[i]][[3]]
				id = i
			}
		}
		current_node = open[[id]]
		open[[id]] = NULL
		#print("2")
		closed = c(closed,current_node)
		if (length(closed)>0){
			for (i in length(closed)){
				if (all(closed[[i]][[1]] == goalPos)){
					break
				}
			}
		}

		
		neighbourList = getNeighbour(current_node[[1]],dir)
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
					for (i in length(closed)){
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
					    for (i in length(open)){
					       	if (all(current_neighbour == open[[i]][[1]])){
					       		cur_neigh_in_open = 1
					       		neigh_in_open_id = i
					       		#print("aa")
					       		break			        		
					        }
					    }
					    if (cur_neigh_in_open==1){
					    	if (f<open[[neigh_in_open_id]][[3]]){
					    		fromList = current_node[[2]]
				        		fromList[[length(fromList)+1]] = current_node[[1]]
				        		#open[[neigh_in_open_id]] = list(current_neighbour,fromList,f,dg,h)
				        		open[[neigh_in_open_id]][[2]] = fromList
				        		open[[neigh_in_open_id]][[3]] = f

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

	return (move)
}






	

manhattan = function(pos1,pos2)
  return (1*(abs(pos1[1]-pos2[1]) + abs(pos1[2]-pos2[2]))) 

#get existing neighbours' coordinates
getNeighbour = function(node,dir){ 
  if (node[1] > 1 && any(dir==4))
    ln = c(node[1]-1,node[2])
  else
    ln = NULL
  if (node[1] < 10 && any(dir==6))
    rn = c(node[1]+1,node[2])
  else
    rn = NULL
  if (node[2] > 1 && any(dir==2))
    dn = c(node[1],node[2]-1)
  else
    dn = NULL
  if (node[2] < 10 && any(dir==8))
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


# uncomment to autorun as autoDM
superRun = function(x = 0, y = FALSE){
  if (y == FALSE)
    z=0
  else
    z=0.1
  waitcount = 0
  if(x != 0){
    set.seed(x)
  }
  return (runDeliveryMan(carReady = AstarDM,dim=10,turns=2000,doPlot=y,pause=z,del=5))
}


