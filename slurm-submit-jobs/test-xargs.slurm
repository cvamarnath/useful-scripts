#!/usr/bin/env bash

#SBATCH --partition=pg2_128_pool
#SBATCH --nodes=2
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=4G
#SBATCH --job-name=test.slurm
#SBATCH --output=test.slurm-%j.out
#SBATCH --error=test.slurm-%j.err
#SBATCH --mail-user=chunjie-sam-liu@foxmail.com
#SBATCH --mail-type=end

# The key here to running multiple jobs is using the "cpus-per-task" directive and then setting the amount of memory per CPU (i.e. per task) with #SBATCH --mem-per-cpu 4G rather than asking for an overall amount of memory per node. Failure to do this may result in strange and sub-optimal behaviour!

# This two should not be set
# The slurm knows the $SLURM_TASKS_PER_NODE to arrange the task to run on the specific node.
#--ntasks=40
#--ntasks-per-node=20
#--time=00:01:00

module load anaconda3/3.5.2
module load intel/18.0.2
module load mpi/intel/18.0.2

echo $SLURM_TASKS_PER_NODE

# calculate how many tasks can we run simultaneously (i.e. how many cores are available)
NR_TASKS=$(echo $SLURM_TASKS_PER_NODE | sed 's/\([0-9]\+\)(x\([0-9]\+\))/\1*\2/' | bc)

echo $NR_TASKS

# This will produce errors, some srun can not add to the steps.

seq -w 1 300 | xargs -I {} --max-procs=$NR_TASKS bash -c "srun --exclusive --nodes 1 --ntasks 1 python demo.py {}"

# demo.py should provide exit code 0.
# exit code 1 will throw errors.
# log into specific node
# srun --pty  --nodelist=d0806 --partition=v3_64_single bash

# srun --pty  --nodelist=m-2-01 bash

# Show the limits associated with account.
# sacctmgr show assoc