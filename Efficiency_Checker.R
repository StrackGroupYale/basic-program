#initialize shock_distribution and util_distribution
frm_shocks<-data.frame(shock=0) #will change to take in the input
  frm_shocks[1,1]<-0.2 
  frm_shocks[2,1]<-0.3
  frm_shocks[3,1]<-0.4

frm_util<-data.frame(util_mean=0) #ditto
  frm_util[1,1]<-1
  frm_util[2,1]<-2

#generate type spaces
num_types <- nrow(frm_shocks)**nrow(frm_util)
num_objects <- nrow(frm_util)

#initialize util_vec
util_vec<-frm_util #note: lines 57-59 in problem_generator are redundant?
shock_vec<-frm_shocks #note: same with line 61. It seems they're just copying over the value from frm_shocks?

#generate type_space

#install.packages("gtools")
library(permutations)

type_vector <- data.frame(util_1=0,util_2=0,util_3=0)
v<-c(0.2,0.3,0.4)
type_vector<-data.frame(permutations(n=3,r=2,v=v,repeats.allowed=TRUE))

#alternative
reshape_arr<-data.frame()
for (i in 1:num_objects){
  for (j in 1:nrow(shock_vec)){
    reshape_arr[i,j] <- shock_vec[j,1]
  }
}
expanded<-expand.grid(reshape_arr)


#generate quantiles
quantile_probs <- data.frame(0)
for (i in 1:100){ 
  quantile_probs[i,1]<-dlogis(qlogis(i*0.01))
}
sum<-sum(quantile_probs)
quantile_probs<-quantile_probs/sum #normalize

type_probs <- data.frame(0) #initialize type probability
for (i in 1:num_types){ #note: line 101 can be simplified to this
  prob<-1 #initialize probability
  for (j in 1:num_objects){#line 103 can be simplified to this
    prob <- prob*quantile_probs[floor(type_vector[i,j]*100),1] #need to fix type_vector
  }
  type_probs[i,1]<-prob
}
sum2<-sum(type_probs)
type_probs<-type_probs/sum2

#sweep
type_vec2<-data.frame()
util_vec<-t(util_vec)
for (i in 1:nrow(type_vector)){
  type_vec2[i,]<-type_vector[i,]+util_vec
}
