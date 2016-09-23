AstarDM = function(roads,car,packages) {
  #print(packages)
	undelIndex = which(packages[,5]==0 | packages[,5]==1)
	carPos = c(car$x,car$y)
	if (car$load == 0){
    
    #---this part is trying to find shorest manhattan distance sequence of all points
    # shortestList = findShorest(packages)
    # newList = list()
    # for(i in 1:length(undelIndex)){
    #   for(j in 1:length(shortestList)){
    #     if (undelIndex[[i]]==shortestList[[j]]){
    #       newList[[length(newList)+1]] = undelIndex[[i]]
    #     }
    #   }
    # }
    # car$mem[[1]] = newList[[1]]


    #---using manhattan distance of one point
		packDist = matrix(NA,1,5)
    	for (i in undelIndex){
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
	expendedNode = list(carPos,fromList,0,0,manhattan(carPos,goalPos))
	open = list(expendedNode)
	closed = list()
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
					       		break			        		
					        }
					    }
					    if (cur_neigh_in_open==1){
					    	if (f<=open[[neigh_in_open_id]][[3]]){
					    		  fromList = current_node[[2]]
				        		fromList[[length(fromList)+1]] = current_node[[1]]
				        		open[[neigh_in_open_id]] = list(current_neighbour,fromList,f,dg,h)
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


#---using brute force to find the shortest sequence of all packages
findShorest = function(packages){
  packNum = nrow(packages)
  cost = 0
  temp = 0
  cur_id = 0
  permutationList = permutations(packNum)
  for(i in 1:nrow(permutationList)){
    for(j in 1:packNum){
      c = permutationList[i,j]
      if(j==1){        
        cost = cost + manhattan(c(1,1),c(packages[c,1],packages[c,2]))
      }
      else{
        pre = permutationList[i,j-1]
        cost = cost + manhattan(c(packages[pre,3],packages[pre,4]),c(packages[c,1],packages[c,2]))
        cost = cost + manhattan(c(packages[c,1],packages[c,2]),c(packages[c,3],packages[c,4]))
      }
    }
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
  }
  return(permutationList[cur_id,])
  
}



average_turns = function(){
  sum = 0
  for (i in 1:100){
      j = runDeliveryMan(carReady = AstarDM,dim=10,turns=2000,doPlot=FALSE,pause=0,del=5)
      sum = sum + j
      print(i)
  }
  average = sum/100

  return (average)
}


dynamicProgram = function() {
  packages = matrix(sample(1:10,replace=T,5*5),ncol=5)
  distances = array(0, dim=c(ncol(packages),ncol(packages)))
  paths = array(0, dim=c(ncol(packages)-1,ncol(packages)))
  print(packages)
  print(distances)
  print(paths)
  for (i in 1:ncol(packages)) {
    distances[1,i] = manhattan(c(packages[i,1],packages[i,2]),c(0,0))
  }
  for (i in 2:ncol(packages)) { # i means current row, j means current column
    for (j in 1:ncol(packages)) {
      if (j == i) {
        next
      }
      if (j == 1) {
        tempDis = manhattan(c(packages[2,3],packages[2,4]),c(packages[j,1],packages[j,2])) + distances[i-1,2]
        tempPath = 2
        for (k in 3:ncol(packages)) {
          print(which(paths[,j]==k))
          if (length(which(paths[,j]==k))!=0) {
            next
            print("重复")
          }
          temp = manhattan(c(packages[k,3],packages[k,4]),c(packages[j,1],packages[j,2])) + distances[i-1,k]
          if (temp < tempDis) {
            tempDis = temp
            tempPath = k
          }
        }
        distances[i,j] = tempDis
        paths[i-1,j] = tempPath
      } else {
        tempDis = manhattan(c(packages[1,3],packages[1,4]),c(packages[j,1],packages[j,2])) + distances[i-1,1]
        tempPath = 1
        for (k in 2:ncol(packages)) {
          if (length(which(paths[,j]==k))!=0) {
            next
            print("重复")
          }
          temp = manhattan(c(packages[k,3],packages[k,4]),c(packages[j,1],packages[j,2])) + distances[i-1,k]
          if (temp<tempDis) {
            tempDis = temp
            tempPath = k
          }
        }
        distances[i,j] = tempDis
        paths[i-1,j] = tempPath
      }
    }
  }
  print(distances)
  print(paths)
}


