#!/bin/bash
#SBATCH --mem-per-cpu 100M
#SBATCH -t 01:00:00
#SBATCH --array=0-215

module load R
srun ./args/args_$SLURM_ARRAY_TASK_ID 
