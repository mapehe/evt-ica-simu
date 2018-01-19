# Triton simu code

This repo was used in executing the simulations for a paper related to extreme value theory and independent component analysis.
More generally, it illustrates one way to use a SLURM cluster (such as Aalto University's Triton). The repository contains the following
files.

The simulation required generating samples independently and
evaluating certain statistical quantities from them; the different
scenarios were executed in parallel. A setup that solves any 
"embarrassingly parallel" problem can be built in a similar way.

The approach here is simple: Commands of the form
```
Rscript [arguments]
```

* `simu_round.r` contains the simulation code. Additionally it
illustrates how to process command line arguments in R.

* `generate_args.py` generates the command line arguments 
