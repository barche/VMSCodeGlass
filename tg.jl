using PartitionedArrays
using SegregatedVMSSolver
using SegregatedVMSSolver.ParametersDef
using SegregatedVMSSolver.SolverOptions
using MPI

MPI.Init()
rank = MPI.Comm_rank(MPI.COMM_WORLD)

function tg(N, tsteps)

  rank == 0 && println("starting run for N = $N")

  t0 = 0.0
  dt = 0.01
  tF = dt*tsteps
  vortex_diameter = 1.0
  Re = 1600
  D = 3 #problem in 3D dimensions

  backend = with_mpi #with_debug -> you can run in the repl, see PartitionedArrays for more details

  rank_partition = (2,2,2) # the product of this tuple must be equal to the number of MPI processes

  sol_options= petsc_options(; vel_ksp="gmres", vel_pc="bjacobi", pres_ksp = "cg", pres_pc = "asm")
  sol_options *= " -options_monitor -log_view"


  sprob = StabilizedProblem(VMS(2)) #2nd order elemetns
  timep = TimeParameters(t0=t0, dt=dt, tF=tF)

  physicalp = PhysicalParameters(Re=Re, c=vortex_diameter)
  solverp = SolverParameters(matrix_freq_update=1, Number_Skip_Expansion=10e6, M=40,petsc_options=sol_options)
  exportp = ExportParameters(printinitial=true, printmodel=true, 
  vtu_export = ["uh","ph"], extra_export=["KineticEnergy", "Enstrophy"])

  meshp = MeshParameters(rank_partition, D; N=N, L=pi * vortex_diameter)


  simparams = SimulationParameters(timep, physicalp, solverp, exportp)

  bc_tgv = Periodic(meshp, physicalp)



  mcase = TaylorGreen(bc_tgv, meshp, simparams, sprob)


  # # Create folder and file
  # mkdir("Log")
  # open("Log/PrintSim.txt", "w") do file
  # end



  SegregatedVMSSolver.solve(mcase, backend)

  rank == 0 && println("finished run for N = $N")
end

tg(8,2) #8-> number of elements on each side, 2->number of time-steps
