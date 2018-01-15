# Library imports

library("optparse")
library(JADE)
library(fICA)

# Auxiliary functions
# TODO: fICA doesn't work??

help="

	Arguments:
    
	    data	---   The data to evaluate the Hill moment from.
	    k_n	---   The number of tail observations. (Not the percentage)
	    j	---   The j:th moment will be returned (j = 1 is equal to the Hill estimator)
"

hill_moment <- function(data, k_n, j){
    tmp	= sort(data, decreasing=TRUE)[1:k_n]
    y	= sort(data, decreasing=TRUE)[k_n+1] 
    return(mean((log(tmp)-log(y))^j))
}

help="

	Arguments:
    
	    data	---   The data to evaluate the Hill moment from.
	    k_n	---   The number of tail observations. (Not the percentage)
"

moment_estimator <- function(data, k_n){
    M_1 = hill_moment(data, k_n, 1);
    M_2 = hill_moment(data, k_n, 2);
    return(M_1 + 1 - 0.5*(1-(M_1^2/M_2))^(-1))
}

# Global constants

NUM_EPOCH = 1000 # Repeats per sample size
DFS = c(5,9,13)

# Parse arguments

option_list = list(
  make_option("--ica_method", type="character", default=NA,
		help="Which ICA method to use, the choices are fICA, FOBI and none"),
  make_option(c("--p"), type="numeric", default=NA,
		help="Fraction of the largest observations to use in calculating the estimator for gamma (use 0.01, 0.05 or 0.1)"),
  make_option("--distribution_type", type="character", default=NA,
		help="Which distribution type to use, the choices are HHH HHL and LLL."),
  make_option("--n", type="numeric", default=NA,
		help="Sample size, use 1000, 5000, 10 000 or 20 000."),
  make_option("--gamma_estimator", type="character", default=NA,
		  help="Which estimator to use for gamma, the choices are hill and moment"),
  make_option("--ofile", type="character", default=NA,
		  help="Output file")
); 
 
opt_parser = OptionParser(option_list=option_list);
OPT = parse_args(opt_parser);


# If there is a missing argument, halt the execution.


if(NA %in% OPT){
    stop("It looks like an argument is missing");
}


#################################################################
help="

			ARGUMENT PROCESSING
  
"
#################################################################

# DISTRIBUTION TYPE

if(OPT$distribution_type == "HHH"){
    observation_generator <- function(n){
	return( cbind(matrix(rt(n, 5),  nrow=n),
		      matrix(rt(n, 9),  nrow=n),
		      matrix(rt(n, 13), nrow=n)))}
} else if(OPT$distribution_type == "HHL"){
    observation_generator <- function(n){
	return( cbind(matrix(rt(n, 9),  nrow=n),
		      matrix(rt(n, 13), nrow=n),
		      matrix(runif(n),	nrow=n)))}
} else if(OPT$distribution_type == "LLL"){
    observation_generator <- function(n){
	return( cbind(matrix(runif(n),  nrow=n),
		      matrix(rbeta(n, 0.5, 0.5), nrow=n),
		      matrix(rexp(n),	nrow=n)))}
} else{ 
    observation_generator = NA
}


# ICA METHOD

if(OPT$ica_method == "FOBI"){
    ICA_method <- function(x){
	return(FOBI(x)$S)
    }
} else if(OPT$ica_method == "fICA"){
    ICA_method <- function(x){
	return(fICA(x)$S)
    } 
} else if(OPT$ica_method == "none"){
    ICA_method = NULL
}  else{
    ICA_method = NA
}

# GAMMA ESTIMATOR

if(OPT$gamma_estimator == "hill"){
    EV_estimator <- function(x){
	return(hill_moment(x, floor(OPT$n*OPT$p), 1))
    }
} else if(OPT$gamma_estimator == "moment"){
    EV_estimator <- function(x){
	return(moment_estimator(x, floor(OPT$n*OPT$p)))
    }
} else{ 
    EV_estimator = NA
}

#################################################################
help="

			END ARGUMENT PROCESSING
  
"
#################################################################


if(TRUE %in% c(is.na(observation_generator), is.na(ICA_method), is.na(EV_estimator))){
    stop("It looks like there is an invalid argument.");
}

out = vector()

for( i in 1:NUM_EPOCH ){

    A	=     matrix(rnorm(9), nrow=3, ncol=3)
    Z	=     t(apply(observation_generator(OPT$n), 1, function(x) A %*% x))

    if(OPT$ica_method != "none"){
	X_hat	=     ICA_method(Z)
    } else{
	X_hat = observation_generator(OPT$n)
    }

    g_hat	=     apply(X_hat, 2, function(x) max(EV_estimator(x[which(x > 0)]),
						      EV_estimator(abs(x[which(x <= 0)]))))
    out = rbind(out, g_hat)
}

write.table(out, OPT$ofile, sep=";", row.names = F)
