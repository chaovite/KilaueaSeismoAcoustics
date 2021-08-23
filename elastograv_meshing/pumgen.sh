#!/bin/bash
#SBATCH --account=pn68fi
#SBATCH --partition=micro
#SBATCH --nodes=2
#SBATCH --time=03:00:00


#SBATCH --ntasks-per-node=1

#SBATCH -J pumgen

#SBATCH -o ./logs/%j_%x.out

#SBATCH -D .

#SBATCH --mail-type=BEGIN,END
 
#source /etc/profile.d/modules.sh

printf -v date '%(%Y-%m-%d_%H-%M-%S)T\n' -1
WORKDIR="$SCRATCH/kilauea/meshing/${date}"

mkdir -p $WORKDIR
cp *.xml $WORKDIR
cp *.smd $WORKDIR
cd $WORKDIR

echo "Workdir: $WORKDIR"

mpiexec -n $SLURM_NTASKS ~/build/PUMGen/pumgen -s simmodsuite -l ~/simmodeler_license.lic --xml elastograv_v0.xml elastograv_v0.smd
#mpiexec -n $SLURM_NTASKS ~/build/PUMGen/pumgen -s simmodsuite -l ~/simmodeler_license.lic --xml elastograv_v0_tiny.xml elastograv_v0.smd
