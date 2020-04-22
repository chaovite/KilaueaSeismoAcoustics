#!/bin/bash
# Job Name and Files (also --job-name)

#SBATCH -J kilauea
#Output and error (also --output, --error):
#SBATCH -o ./logs/%j.%x.out
#SBATCH -e ./logs/%j.%x.err

#Initial working directory (also --chdir):
#SBATCH --workdir=.

#Notification and type
#SBATCH --mail-type=BEGIN,END
#SBATCH --mail-user=lukas.krenz@in.tum.de

# Wall clock limit:
#SBATCH --time=0:30:00
##SBATCH --time=14:00:00
#SBATCH --no-requeue

#Setup of execution environment
#SBATCH --export=ALL
#SBATCH --account=pr45fi
#--constraint="scratch&work"
#SBATCH --partition=test

#SBATCH --nodes=16
#SBATCH --ntasks-per-node=1

#SBATCH --ear=off

module load slurm_setup

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
ulimit -Ss unlimited
ulimit -c unlimited
mpiexec -n ${SLURM_NTASKS} ./SeisSol parameters.par
