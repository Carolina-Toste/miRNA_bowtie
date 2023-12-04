#!/bin/bash
#SBATCH --job-name=filterfastqc
#SBATCH --account=scw1877
#SBATCH --partition=c_compute_neuro1
#SBATCH --time=00:30:00
#SBATCH --output=logs/o.%J
#SBATCH --error=logs/e.%J
#SBATCH --array=0-160

module load java/11.0
module load fastqc/0.11.8

JOBNAME="filterfastqc"
BASEDIR="/scratch/${USER}"

# This directory has already been created as the output of filtertrimmedreads script
INPUTDIR="${BASEDIR}/mirbase/input"
FASTQDIR="${INPUTDIR}/filtertrimmedreads"
FASTQFILENAMES=(`ls -1 "${FASTQDIR}"`)
FASTQFILENAME="${FASTQFILENAMES[${SLURM_ARRAY_TASK_ID}]}"
SAMPLEID=${FASTQFILENAME/%".filtered.trimmed.fastq.gz"}  

# Generated output diretory automatically
OUTPUTDIR="${BASEDIR}/output/${JOBNAME}"
mkdir -p $OUTPUTDIR

fastqc -o "${OUTPUTDIR}/"  "${FASTQDIR}/${FASTQFILENAME}/"




