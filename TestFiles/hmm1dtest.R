library(microbenchmark)
library(HMMextra0s)

run_microbenchmark <- FALSE

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
Rprof(filename="hmm1dtest_Rprof.out")
a <- hmm0norm(R, Z,pie,gamma,mu,sig,delta)
Rprof(NULL)
a
s2 <- Sys.time()
print(s2-s1)

#########################################################################################################

# Compare results

pie_kgo <- c(0.903629925, 0.986604791, 0.004265839, 0.773020976, 0.148880160, 0.853895275)

stopifnot(all.equal(a$pie, pie_kgo, tolerance=1.0e-6))
print("pie results match.")

mu_kgo <- matrix(c(0.1271466, 0.2208321, 0.7286528, 0.6246841, 0.8765671, 0.8972273), nrow=1, ncol=6)

stopifnot(all.equal(a$mu, mu_kgo, tolerance=1.0e-7))
print("mu results match.")

sig_kgo <- matrix(c(0.1332605, 0.09426723, 0.01280585, 0.08187161, 0.1251641, 0.1860932), nrow=1, ncol=6)

stopifnot(all.equal(a$sig, sig_kgo, tolerance=1.0e-7))
print("sig results match.")

gamma_kgo <- t(matrix(c(0.840035998, 0.03173284, 0.0069440206, 0.011745510, 0.01554537, 0.09399626,
                        0.033214682, 0.85210798, 0.0015253632, 0.042917767, 0.03027307, 0.03996113,
                        0.037986945, 0.01691150, 0.8784760502, 0.005115844, 0.04304227, 0.01846739,
                        0.004870841, 0.01079672, 0.0196850343, 0.867565996, 0.02068823, 0.07639317,
                        0.047391409, 0.01245635, 0.0007824741, 0.019751279, 0.87602682, 0.04359167,
                        0.033889955, 0.03136792, 0.0261662092, 0.030416429, 0.01340879, 0.86475069), nrow=6, ncol=6))

stopifnot(all.equal(a$gamma, gamma_kgo, tolerance=1.0e-6))
print("gamma results match.")

delta_kgo <- c(0, 0, 0, 0, 0, 1)

stopifnot(all.equal(a$delta, delta_kgo))
print("delta results match.")

LL_kgo <- -16129.08

stopifnot(all.equal(a$LL, LL_kgo, tolerance=1.0e-6))
print("LL results match.")

#########################################################################################################

# Microbenchmark
if (run_microbenchmark == TRUE) {
    microbenchmark(R=hmm0norm(R, Z,pie,gamma,mu,sig,delta), times = 5)
}
