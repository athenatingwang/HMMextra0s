# HMMextra0s

R package for hidden Markov models with observations having extra zeros. The observed response variable is either univariate or bivariate Gaussian conditioning on presence of events, and extra zeros mean that the response variable takes on the value zero if nothing is happening. Hence the response is modelled as a mixture distribution of a Bernoulli variable and a continuous variable. That is, if the Bernoulli variable takes on the value 1, then the response variable is Gaussian, and if the Bernoulli variable takes on the value 0, then the response is zero too. This package includes functions for simulation, parameter estimation, goodness-of-fit, the Viterbi algorithm, and plotting the classified 2-D data.

## How to build 

```
R CMD build HMMextra0s
```

## How to install

```
R CMD INSTALL HMMextra0s
```

## How to test 

```
cd TestFiles
Rscript hmm2dtest.R
Rscript hmm1dtest.R
```
If the output looks like
```
...
[1] "pie results match."
[1] "mu results match."
[1] "sig results match."
[1] "gamma results match."
[1] "delta results match."
[1] "LL results match."

```
then the tests passed.

## Code profiling 

Scripts hmm2dtest.R and hmm1dtest.R contain Rprof instructions which will produce files hmm2dtest_Rprof.out and hmm1dtest_Rprof.out, respectively. Profiling information can be obtained by typing
```
R CMD Rprof hmm2dtest_Rprof.out
R CMD RProf hmm1dtest_Rprof.out
```

## Troubleshooting

If your gfortran has a non standard installation path, you can R to use this version with
```
mkdir ~/.R
cat << EOF >> ~/.R/Makevars
FLIBS=-L<path-to-gfortran-installation>/lib -lgfortran -lquadmath -lm
EOF
```


