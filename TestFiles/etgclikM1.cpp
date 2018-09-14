#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double etgclik1(NumericVector data, NumericVector z, NumericVector param) {
  int n = data.size();
  double c1 = param[0];
  double a1 = param[1];
  double k1 = param[2];
  double p1 = param[3];
  double c2 = param[4];
  double a2 = param[5];
  double k2 = param[6];
  double p2 = param[7];
  double c3 = param[8];
  double a3 = param[9];
  double k3 = param[10];
  double p3 = param[11];
  NumericVector mu(n);
  NumericVector kap(n);
  NumericVector theta(n);
  NumericVector gammak(n);
  NumericVector expaxmu(n);
  NumericVector expaxtht(n);
  NumericVector expaxk(n);
  NumericVector bjpowdmu(n);
  NumericVector bjpowdtht(n);
  NumericVector bjpowdk(n);
  NumericVector xx(n);
  for (int l=0;l<n;l++){
    expaxmu[l]=exp(a1*data[l]);
    expaxtht[l]=exp(a2*data[l]);
    expaxk[l]=exp(a3*data[l]);
    bjpowdmu[l]=pow(l,-p1);
    bjpowdtht[l]=pow(l,-p2);
    bjpowdk[l]=pow(l,-p3);
  }
  for (int i=1;i<n;i++){
    for(int j=1;j<=i;j++){
      mu[i]+=expaxmu[i-j]*k1*bjpowdmu[j]*z[i-j];
      theta[i]+=expaxtht[i-j]*k2*bjpowdtht[j]*z[i-j];
      kap[i]+=expaxk[i-j]*k3*bjpowdk[j]*z[i-j];
    }
    mu[i]=c1+mu[i];
    theta[i]=(c2+theta[i])/(1+c2+theta[i]);
    kap[i]=c3+kap[i];
    gammak[i]=lgamma(kap[i]);
    if(data[i]==0){
      xx[i]=0;
    }else{
      xx[i]=(kap[i]-1)*z[i]*log(data[i]);
    }
  }
  data.erase(0);
  z.erase(0);
  mu.erase(0);
  kap.erase(0);
  theta.erase(0);
  gammak.erase(0);
  xx.erase(0);
  NumericVector y=  -kap*z*data/mu+xx-z*gammak+kap*z*log(kap)-
        kap*z*log(mu)+z*log(theta)+(1-z)*log(1-theta);
  double s = std::accumulate(y.begin(),y.end(), 0.0);
  return -s;
}
