#!/bin/bash
#SBATCH --job-name=filtertrimmedreads
#SBATCH --account=scw1877
#SBATCH --partition=c_compute_neuro1
#SBATCH --time=00:30:00
#SBATCH --output=logs/o.%J
#SBATCH --error=logs/e.%J
#SBATCH --array=0-160

module load cutadapt/3.2

JOBNAME="filtertrimmedreads"
BASEDIR="/scratch/${USER}"

# This directory has already been created and has trimmed fastq files
INPUTDIR="${BASEDIR}/mirbase/input"
FASTQDIR="${INPUTDIR}/trimmed_reads"
FASTQFILENAMES=(`ls -1 "${FASTQDIR}"`)
FASTQFILENAME="${FASTQFILENAMES[${SLURM_ARRAY_TASK_ID}]}"
SAMPLEID=${FASTQFILENAME/%".trimmed.fastq.gz"}

# Generated output diretory automatically
OUTPUTDIR="${BASEDIR}/output/${JOBNAME}"
mkdir -p $OUTPUTDIR


cutadapt --minimum-length 16 --maximum-length 31 \
-o "${OUTPUTDIR}/${SAMPLEID}.filtered.trimmed.fastq.gz" \
"${FASTQDIR}/${FASTQFILENAME}"



