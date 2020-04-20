library(readr)

t_data_2_9 <- read_excel("~/Dropbox/Yale_Senior_Spring/Strack/t_data@2,9.xlsx", col_names=FALSE)
a_data_2_9 <- read_excel("~/Dropbox/Yale_Senior_Spring/Strack/a_data@2,9.xlsx", col_names=FALSE)
write.csv(t_data_2_9,"~/Dropbox/Yale_Senior_Spring/Strack/t_data@2,9.csv")
write.csv(a_data_2_9,"~/Dropbox/Yale_Senior_Spring/Strack/a_data@2,9.csv")
#read in the utility file
util<-read_csv("~/Dropbox/Yale_Senior_Spring/Strack/t_data@2,9.csv")
util<-util[,2:3]
names(util)<-c("Util1","Util2")

#read in the assignment file
assignment<-read_csv("~/Dropbox/Yale_Senior_Spring/Strack/a_data@2,9.csv")
assignment<-assignment[,2:3]
names(assignment)<-c("a1","a2")

#eliminate the "trivially close to 0"
for (i in 1:nrow(assignment)){
  for (j in 1:ncol(assignment)){
    if(assignment[i,j]<1e-5){
      assignment[i,j]<-0
    }
  }
}

#convert to probability of attending
assignment$total<-assignment$a1+assignment$a2
assignment$a1<-assignment$a1/assignment$total
assignment$a2<-assignment$a2/assignment$total
drops<-c("total")
assignment<-assignment[,!(names(assignment) %in% drops)]

#combine the files
combo<-cbind(assignment,util)

#see if swapping probabilities would be useful
counter<-0

#initialize storing array
probswap<-data.frame(player=0,swaps=0)
for (i in 1:nrow(util)){
  probswap[i,1]<-i
  probswap[i,2]<-0
  #this is the utility the person being examined gets from the current allocation
  outcomeutil<-util[i,1]*assignment[i,1]+util[i,2]*assignment[i,2]
  for(iter in 1:nrow(util)){
    #this tests the alternative utility from a different allocation
    alt<-util[i,1]*assignment[iter,1]+util[i,2]*assignment[iter,2]
    if(alt>outcomeutil){ #if the alternative is better than their current one, check for a swap potential
      #this is the utility a potential swap partner gets from their current allocation
      partnerutil<-util[iter,1]*assignment[iter,1]+util[iter,2]*assignment[iter,2]
      #this is the utility a potential swap partner gets from the swapped allocation
      reversedutil<-util[iter,1]*assignment[i,1]+util[iter,2]*assignment[i,2]
      if(reversedutil>partnerutil){ #if that is also higher, say 'we have a swap!'
        counter<-counter+1
        probswap$swaps[i]<-probswap$swaps[i]+1
      }
    }
  }
}
#check to see if there are scenarios in which one would benefit from another allocation ex post facto

#inefficiencydensity
ineffdens<-data.frame(player=0,ineffdens=0)
inefficiencies<-0
for(i in 1:nrow(util)){
  ineffdens[i,1]<-i
  ineffdens[i,2]<-0
  if (util[i,2]>util[i,1]){   #if assigned into school 1 when prefer school 2
    for (iter in 1:nrow(util)){ # check all the others
      if(util[iter,1]>util[iter,2]){ #see if any prefer school 1 to school 2
        #evaluate frequency of inefficiency
        prob<-assignment[i,1]*assignment[iter,2]
        inefficiences<-inefficiencies+prob
        ineffdens[i,2]<-ineffdens[i,2]+prob
      }
    }
  }
  if (util[i,1]>util[i,2]){   #if assigned into school 2 when prefer school 1
    for (iter in 1:nrow(util)){ # check all the others
      if(util[iter,2]>util[iter,1]){ #see if any prefer school 2 to school 1
        #evaluate frequency of inefficiency
        prob<-assignment[i,2]*assignment[iter,1]
        inefficiencies<-inefficiencies+prob
        ineffdens[i,2]<-ineffdens[i,2]+prob
      }
    }
  }
}
inefficiencies
