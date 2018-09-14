library(HMMextra0s)
load("testhmm1ddata.image")
R <- as.matrix(y$x,ncol=1) ## There are 50,000 data points in the data file.
Z <- y$z

nk = 6 ## defines the size of the model. nk=6 suggests a relatively small model.
	   ## For nk=6, it took about 3 mins to run.
	   ## You can increase nk to 10 or decrease nk to increase or reduce the runtime.
		  	
set.seed(seed=8)			
mu <- sig <- matrix(NA,nrow=1,ncol=nk)

temp <- matrix(runif(nk*nk,0,1),ncol=nk)
diag(temp) = diag(temp) + rpois(1,6) * apply(temp, 1, sum)
temp <- temp * matrix(rep(1/apply(temp, 1, sum), ncol(temp)), ncol=ncol(temp), byrow=F)
gamma <- temp

temp <- cbind(runif(nk,0, 1))
temp <- temp[order(temp[,1]),]
mu[1,] <- temp
 
sig[1, ] <- runif(nk,0,0.2)
 
pie <- runif(nk, 0, 1)
pie[1] <- runif(1,0,0.005)

delta <- runif(nk, 0,1)
delta[1] <- rpois(1,10)
delta <- delta/sum(delta)


s1 <- Sys.time()
a <- hmm0norm(R, Z,pie,gamma,mu,sig,delta)
a
s2 <- Sys.time()
print(s2-s1)

