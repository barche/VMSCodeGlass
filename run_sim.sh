#!/bin/bash
#SBATCH --job-name=tgv3d
#SBATCH --partition=arm
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --time=5:00:00
#SBATCH --mem=100G

module load OpenMPI
module load julia/1.11.7
module load PETSc/3.19.6

srun julia --project=. -O3 --check-bounds=no -L tg.jl