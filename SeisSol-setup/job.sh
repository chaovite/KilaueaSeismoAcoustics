#!/bin/bash
# Job Name and Files (also --job-name)

#SBATCH -J kilauea
#Output and error (also --output, --error):
#SBATCH -o ./logs/%x.%j.out
###SBATCH -e ./%j.%x.err

#Initial working directory:
#SBATCH --chdir=.

#Notification and type
#SBATCH --mail-type=BEGIN,END
#SBATCH --mail-user=lukas.krenz@tum.de

# Wall clock limit:
##SBATCH --time=03:00:00
#SBATCH --time=30:00:00
#SBATCH --no-requeue

#Setup of execution environment
#SBATCH --export=ALL
#SBATCH --account=pn68fi
#constraints are optional
#--constraint="scratch&work"
#SBATCH --partition=micro

#Number of nodes and MPI tasks per node:
#SBATCH --nodes=10
#SBATCH --ntasks-per-node=1
module load slurm_setup

#Run the program:
export MP_SINGLE_THREAD=no
unset KMP_AFFINITY
export OMP_NUM_THREADS=94
export OMP_PLACES="cores(47)"

export XDMFWRITER_ALIGNMENT=8388608
export XDMFWRITER_BLOCK_SIZE=8388608
export SC_CHECKPOINT_ALIGNMENT=8388608

export SEISSOL_CHECKPOINT_ALIGNMENT=8388608
export SEISSOL_CHECKPOINT_DIRECT=1
export ASYNC_MODE=THREAD
export ASYNC_BUFFER_ALIGNMENT=8388608
source /etc/profile.d/modules.sh

echo $SLURM_NTASKS
ulimit -Ss 2097152
mpiexec -n $SLURM_NTASKS /dss/dsshome1/0E/ga24dib3/build/SeisSol-kilauea/SeisSol_Release_dskx_4_elastic parameters.par
