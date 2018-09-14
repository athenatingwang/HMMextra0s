library(HMMextra0s)
load("simdat100")
load("zdat100")

R = s[,,1]
Z = z100[,1]
nk = 5 ## defines the size of the model. nk=5 suggests a relatively small model.
       ## I checked this on PAN, and it took about 24 seconds to run.
	   ## When I increased nk to 6, then it took about 1.2 mins to run.
	   ## If you want to test it for larger models, you can increase this nk.
	   ## This test uses simulated data. For real-world data, it takes much longer to run.

set.seed(seed=123)
  gamma = matrix(runif(nk*nk,0,1),nk,nk)
  diag(gamma) = diag(gamma) + rpois(1,6) * apply(gamma, 1, sum)
  gamma = gamma * matrix(rep(1/apply(gamma, 1, sum)),nk,nk)
  
  mu = matrix(c(runif(nk,33.7552,35.0083),runif(nk,135.0197,136.7817)),nk,2)
  mu = cbind(sort(mu[,1]),sort(mu[,2]))
  
  sig = array(NA,dim=c(2,2,nk))
  for (j in 1:nk){
    temp <- matrix(runif(4,0.001,0.4), ncol=2)
    temp[1,2] <- temp[2,1] <- runif(1,-1,1)* sqrt(prod(diag(temp)))
    sig[, ,j] <- temp
  }
  
  pie <- matrix(sort(c(runif(1, 0, 0.01),runif(nk-1, 0, 1))), nrow = 1, byrow = TRUE )
  
  delta <- c(6,runif(nk-1, 0,1)) 
  delta <- delta/sum(delta)
  
s1 <- Sys.time()
a <-hmm0norm2d( R, Z,pie,gamma, mu, sig, delta )
a
s2 <- Sys.time()
print(s2-s1)




