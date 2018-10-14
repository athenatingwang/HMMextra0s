library(microbenchmark)
library(HMMextra0s)

run_microbenchmark <- FALSE

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
Rprof(filename="hmm2dtest_Rprof.out")
a <-hmm0norm2d( R, Z,pie,gamma, mu, sig, delta )
Rprof(NULL)
a
s2 <- Sys.time()
print(s2-s1)

#########################################################################################################

# Compare results

pie_kgo <- c(0.004381975, 0.408520389, 0.484292833, 0.581086482, 0.389446497)

stopifnot(all.equal(a$pie, pie_kgo))
print("pie results match.")

mu_kgo <- matrix(c(33.86433, 33.94367, 34.22065, 34.48138, 34.76104,
                   135.2259, 135.6229, 136.0629, 136.2930, 136.5185), nrow=5, ncol=2)

stopifnot(all.equal(a$mu, mu_kgo, tolerance=1.0e-6))
print("mu results match.")

sig_kgo <- array(c(0.0007301743, 0.001297102, 0.0012971019, 0.016455791,
                   0.009098876, 0.01365886, 0.013658856, 0.03280925, 0.004874000, 0.005349937,
                   0.005349937, 0.011254461, 0.005704259, 0.005443816, 0.005443816, 0.010910371,
                   0.008838668, 0.006759481, 0.006759481, 0.013583309), dim=c(2,2,5))

stopifnot(all.equal(a$sig, sig_kgo, tolerance=1.0e-7))
print("sig results match.")

gamma_kgo <- t(matrix(c(0.99207657, 0.003754677, 0.001029480, 0.001570930, 0.001568340,
                      0.08481320, 0.900891254, 0.004471953, 0.005377103, 0.004446489,
                      0.03060795, 0.002901206, 0.929863009, 0.025421926, 0.011205906,
                      0.06102520, 0.023116775, 0.037197014, 0.862057439, 0.016603578,
                      0.05639658, 0.006546280, 0.014178299, 0.016177171, 0.906701672), nrow=5, ncol=5))

stopifnot(all.equal(a$gamma, gamma_kgo))
print("gamma results match.")

delta_kgo <- c(1.000000, 5.736154e-52, 7.784961e-84, 7.731113e-67, 1.342018e-60)

stopifnot(all.equal(a$delta, delta_kgo))
print("delta results match.")

LL_kgo <- -4767.112

stopifnot(all.equal(a$LL, LL_kgo))
print("LL results match.")

#########################################################################################################

# Microbenchmark
if (run_microbenchmark == TRUE) {
    microbenchmark(R=hmm0norm2d( R, Z,pie,gamma, mu, sig, delta ), times = 5)
}
