library(readr)
library(formattable)
library(data.table)
library(dplyr)
library(formattable)
library(tidyr)
library(htmltools)
library(webshot)
webshot::install_phantomjs()


args = commandArgs(trailingOnly=TRUE)

#read in the utility file
library(readr)
args = commandArgs(trailingOnly=TRUE)

assignment <- suppressWarnings(data.frame(read_csv(args[1])))
util <- suppressWarnings(data.frame(read_csv(args[2])))

util<-(util[2:nrow(util),2:ncol(util)])

#read in the assignment file
assignment<-(assignment[2:nrow(assignment),2:ncol(assignment)])



for (k in 1:args[3]){
  assignment[,k]<-as.numeric(assignment[,k])
  util[,k]<-as.numeric(util[,k])
}

#eliminate the "trivially close to 0"
for (i in 1:nrow(assignment)){
  for (j in 1:ncol(assignment)){
    if(assignment[i,j]<1e-5){
      assignment[i,j]<-0
    }
  }
}

#convert to probability of attending
assignment$total<-0
for (k in 1:nrow(assignment)){
  assignment$total[k]<-sum(assignment[k,1:(ncol(assignment)-1)])
}

for (i in 1:nrow(assignment)){
  for (j in 1:(ncol(assignment)-1)){
    assignment[i,j]<-assignment[i,j]/assignment$total[i]
  }
}

drops<-c("total")
assignment<-assignment[,!(names(assignment) %in% drops)]







#see if swapping probabilities would be useful
counter<-0

#initialize storing array
probswap<-data.frame(player=0,swaps=0)
swapvisualize<-data.frame(matrix(0,nrow=nrow(util),ncol=nrow(util)+1))

for (i in 1:nrow(util)){ 
  swapvisualize[i,1]<-paste("Person",i)
  probswap[i,1]<-i
  probswap[i,2]<-0
  #this is the utility the person being examined gets from the current allocation
  outcomeutil<-0
  for (k in 1:ncol(util)){
    outcomeutil<-outcomeutil+util[i,k]*assignment[i,k]
  }
  for(iter in 1:nrow(util)){ 
    #this tests the alternative utility from a different allocation
    alt<-0
    for (k in 1:ncol(util)){
      alt<-alt+util[i,k]*assignment[iter,k]
    }
    
    if(alt>outcomeutil){ #if the alternative is better than their current one, check for a swap potential
      #this is the utility a potential swap partner gets from their current allocation
      partnerutil<-0
      for (k in 1:ncol(util)){
        partnerutil<-partnerutil+util[iter,k]*assignment[iter,k]
      }
      #this is the utility a potential swap partner gets from the swapped allocation
      reversedutil<-0
      for (k in 1:ncol(util)){
        reversedutil<-reversedutil+util[iter,k]*assignment[i,k]+util[iter,k]*assignment[i,k]
      }
      if(reversedutil>partnerutil){ #if that is also higher, say 'we have a swap!'
        counter<-counter+1
        probswap$swaps[i]<-probswap$swaps[i]+1
        swapvisualize[i,iter+1]<-1
        swapvisualize[iter,i+1]<-1
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
  for (preferred in 1:ncol(assignment)){ 
    for (assigned in 1:ncol(assignment)){ 
      if (preferred != assigned){
        if (util[i,assigned]<util[i,preferred]){ #if you get assigned something you don't like
          for (iter in 1:nrow(util)){ #find a potential partner 
            if(util[iter,preferred]<util[iter,assigned]){ 
              prob<-assignment[i,assigned]*assignment[iter,preferred]
              inefficiencies<-inefficiencies+prob
              ineffdens[i,2]<-ineffdens[i,2]+prob
            }
          }
        }
      }
    }
  }
}
print(paste("The inefficiency value is",inefficiencies))

print(ineffdens)

print(paste("The total number of available probability swaps is", counter))

print(swapvisualize)
customGreen0 = "#DeF7E9"
customGreen = "#71CA97"
customRed = "#ff7f7f"

for (i in 1:nrow(swapvisualize)){
  names(swapvisualize)[i+1]<-i+1
}          

names(swapvisualize)[1]<-"Trade_Partner"


##MAKING PRETTY PNG GRAPHS TO VISUALIZE
#from https://github.com/renkun-ken/formattable/issues/26
export_formattable <- function(f, file, width = "100%", height = NULL, 
                               background = "white", delay = 0.2)
{
  w <- as.htmlwidget(f, width = width, height = height)
  path <- html_print(w, background = background, viewer = NULL)
  url <- paste0("file:///", gsub("\\\\", "/", normalizePath(path)))
  webshot(url,
          file = file,
          selector = ".formattable_widget",
          delay = delay)
}

swapper<-formattable(swapvisualize, align=c("l"),
            list(Trade_Partner=formatter("span",style = ~ style(font.weight="bold")),
            area(col=2:ncol(swapvisualize)) ~ color_tile("gray","red")))
export_formattable(swapper,"~/basic-program/solver_basic/assignment_data/swapper.png")


inefftable<-formattable(ineffdens, align=c("l"), list(player=formatter("span",style = ~ style(font.weight="bold")),
                                          area(row=2:2)) ~ color_tile("red","white"))
export_formattable(inefftable,"~/basic-program/solver_basic/assignment_data/inefftable.png")



probtable<-formattable(probswap, align=c("l"), list(player=formatter("span",style = ~ style(font.weight="bold")),
                                          area(row=2:2)) ~ color_tile("red","white"))
export_formattable(probtable,"~/basic-program/solver_basic/assignment_data/probtable.png")


