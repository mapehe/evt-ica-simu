import itertools
import re

DISTRIBUTION_TYPE = ("HHH", "HHL", "HHH")
EV_ESTIMATOR = ("hill", "moment")
SAMPLE_SIZE = (1000, 5000, 10000, 20000)
FRACTION = (0.1, 0.05, 0.01)
ICA_METHOD = ("none", "fICA", "FOBI")

GLOBAL_STEP = 0

for i in itertools.product(DISTRIBUTION_TYPE,
			    EV_ESTIMATOR, SAMPLE_SIZE,
			    FRACTION, ICA_METHOD):
    with open("./args/args_%s" %GLOBAL_STEP) as f:
	tmp = i+i
	f.write("Rscript simu_round.r --distribution_type %s --gamma_estimator %s --n %s --p %s --ica_method %s --ofile out_%s_%s_%s_%s_%s" %tmp)
    GLOBAL_STEP += 1
