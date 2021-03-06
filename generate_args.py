import itertools
import re
import numpy as np

DISTRIBUTION_TYPE = ("HHH", "HHL", "LLL")
EV_ESTIMATOR = ("hill", "moment")
SAMPLE_SIZE = 1000*np.array(range(1,21))
FRACTION = (0.1, 0.05, 0.01)
ICA_METHOD = ("none", "fICA", "FOBI")

GLOBAL_STEP = 0

for i in itertools.product(DISTRIBUTION_TYPE,
			    EV_ESTIMATOR, SAMPLE_SIZE,
			    FRACTION, ICA_METHOD):
    with open("./args/args_%s" %GLOBAL_STEP, "w") as f:
		tmp = i+i
		f.write("simu_round.r --distribution_type %s --gamma_estimator %s --n %s --p %s --ica_method %s --ofile ./out/out_%s_%s_%s_%s_%s" %tmp)
    GLOBAL_STEP += 1
