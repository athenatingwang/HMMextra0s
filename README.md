# HMMextra0s

R package for hidden Markov models with observations having extra zeros. The observed response variable is either univariate or bivariate Gaussian conditioning on presence of events, and extra zeros mean that the response variable takes on the value zero if nothing is happening. Hence the response is modelled as a mixture distribution of a Bernoulli variable and a continuous variable. That is, if the Bernoulli variable takes on the value 1, then the response variable is Gaussian, and if the Bernoulli variable takes on the value 0, then the response is zero too. This package includes functions for simulation, parameter estimation, goodness-of-fit, the Viterbi algorithm, and plotting the classified 2-D data.

## How to build 

```
R CMD build HMMextra0s
```

## How to test 

```
R CMD check HMMextra0s
```

## Troubleshooting

If your gfortran has a non standard installation path, you can use this version like so
```
mkdir ~/.R
cat << EOF >> ~/.R/Makevars
FLIBS=-L<path-to-gfortran-installation>/lib -lgfortran -lquadmath -lm
EOF
```


