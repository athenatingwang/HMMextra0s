library(Rcpp)
data<-read.csv("AmatriceDayEnIn.csv",head=T)
#data<-read.csv("AmatriceHrEnIn.csv",head=T)
head(data)
x<-data$energy
z <- rep(1,length(x))
z[x==0] <- 0

sourceCpp("etgclikM1.cpp")

set.seed(seed=1)
param<-runif(12,c(0,0,0,0,0,0,0,0,0,0,0,0),c(5,5,5,3,5,5,5,3,5,5,5,3))
  
s1 <- Sys.time()
temp <-optim(param,etgclik1,data=x,z=z)
temp
s2 <- Sys.time()
print(s2-s1)

## The code above only takes about 17 secs to complete.
## The length of the data is 4449.



## The code below only takes about 1.4 mins to complete.
## The length of the data is 10000.
## If we change the length of the data to 20000 by setting x<-data$energy[1:20000]
## then it takes much longer.

library(Rcpp)
data<-read.csv("AmatriceHrEnIn.csv",head=T)
head(data)
x<-data$energy[1:10000]
z <- rep(1,length(x))
z[x==0] <- 0

sourceCpp("etgclikM1.cpp")

set.seed(seed=1)
param<-runif(12,c(0,0,0,0,0,0,0,0,0,0,0,0),c(5,5,5,3,5,5,5,3,5,5,5,3))
  
s1 <- Sys.time()
temp <-optim(param,etgclik1,data=x,z=z)
temp
s2 <- Sys.time()
print(s2-s1)

