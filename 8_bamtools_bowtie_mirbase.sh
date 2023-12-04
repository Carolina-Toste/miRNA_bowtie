#!/bin/bash
#SBATCH --job-name=bamstatsbowtiemirbase
#SBATCH --account=scw1877
#SBATCH --partition=c_compute_neuro1
#SBATCH --time=00:05:00
#SBATCH --output=logs/o.%J
#SBATCH --error=logs/e.%J
#SBATCH --array=0-149

# Adjust --array parameter value to reflect number of bam files
# in BAMSDIR or override it on sbatch submission with --array

module load raven
module load bamtools/2.3.0

JOBNAME="bamstatsbowtiemirbase"
BASEDIR="/scratch/${USER}"

# CThis directory was created automatically as the output of the markdup script it contains markdup.bam files
INPUTDIR="${BASEDIR}/mirbase/input"
BAMSDIR="${INPUTDIR}/markduplicatesmirbase" 

BAMFILENAMES=(`ls -1 "${BAMSDIR}"`)
BAMFILENAME="${BAMFILENAMES[${SLURM_ARRAY_TASK_ID}]}"

# Generate output diretory automatically
OUTPUTDIR="${BASEDIR}/output/${JOBNAME}"
mkdir -p "${OUTPUTDIR}"

bamtools stats \
  -in "${BAMSDIR}/${BAMFILENAME}" \
  > "${OUTPUTDIR}/${BAMFILENAME/%".markdup.bam"}.markdup.dupstats.txt"
