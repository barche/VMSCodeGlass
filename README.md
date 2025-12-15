## Usage

After cloning this repository, cd to the local copy and run:

```
julia --project initialize.jl
~/.julia/bin/mpiexecjl -np 8 julia --project tg.jl
```

The second line is the actual program to profile. The first one sets things up and needs to be run only once.

Note that this assumes the Julia mpiexecjl is installed as per the [MPI.jl instructions](https://juliaparallel.org/MPI.jl/stable/usage/#Installation)

On a computing cluster you may also launch the initialization from the batch file `run_init.sh` and then the simulation on the same partition `run_sim.sh` modifying them according to your cluster settings.

For compatibility reasons, is best to use the version of PETSc <=3.19.6, and normally this is enforced automatically.