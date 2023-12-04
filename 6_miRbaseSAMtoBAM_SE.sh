#!/bin/bash
#SBATCH --job-name=SAMtoBAMmirbase
#SBATCH --account=scw1877
#SBATCH --partition=c_compute_neuro1
#SBATCH --time=00:30:00
#SBATCH --output=logs/o.%J
#SBATCH --error=logs/e.%J
#SBATCH --array=0-161



module load samtools/1.9


JOBNAME="SAMtoBAMmirbase"
BASEDIR="/scratch/${USER}"

# This directory has already been created as the output of the bowtiemap command
INPUTDIR="${BASEDIR}/mirbase/input"
SAMDIR="${INPUTDIR}/bowtiemapmirbase"
SAMFILENAMES=(`ls -1 "${SAMDIR}"`)
SAMFILENAME="${SAMFILENAMES[${SLURM_ARRAY_TASK_ID}]}"
SAMPLEID=${SAMFILENAME/%".alignedbowtiemirbase.sam"}

# Generated output diretory automatically
OUTPUTDIR="${BASEDIR}/output/${JOBNAME}"
mkdir -p $OUTPUTDIR

samtools view -S -b  "${SAMDIR}/${SAMFILENAME}" | \
samtools sort -o "${OUTPUTDIR}/${SAMPLEID}.alignedbowtiemirbase.sorted.bam" 
  
