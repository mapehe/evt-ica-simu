# Triton simu code

This repo was used in executing the simulations for a paper related to extreme value theory and independent component analysis.
More generally, it illustrates one way to use a SLURM cluster (such as Aalto University's Triton).
The simulation required generating samples independently and
evaluating certain statistical quantities from them; the different
scenarios were executed in parallel. A setup that solves any 
"embarrassingly parallel" problem can be built in a similar way.

The approach here is simple: Commands of the form
```
Rscript [arguments]
```
Were executed, where `[arguments]` specifies the scenario to simulate. The following files were used for this:

* `simu_round.r` contains the simulation code. Additionally it
illustrates how to process command line arguments in R.

* `generate_args.py` generates the command line arguments that are passed to `simu_round.r`

* `submit.sbatch` submits the job to SLURM and starts the execution

## Running the simulation

Run
```
python generate_args.py
```
This will generate the command line arguments for the simulation. After the script has been executed, they
have appeared in the folder `args`. To execute the simulation run
```
sbatch submit.sbatch
```
The results will appear in folder `out`.
