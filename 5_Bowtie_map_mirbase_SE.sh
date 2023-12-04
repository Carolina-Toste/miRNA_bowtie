#!/bin/bash
#SBATCH --job-name=bowtiemapmirbase
#SBATCH --account=scw1877
#SBATCH --partition=c_compute_neuro1
#SBATCH --time=00:30:00
#SBATCH --output=logs/o.%J
#SBATCH --error=logs/e.%J
#SBATCH --array=0-160

module load bowtie/1.3.1
module load samtools/1.9
module load python/3.5.9

JOBNAME="bowtiemapmirbase"
BASEDIR="/scratch/${USER}"

# Create this directory manually and add trimmed fastq files - does not accept .gz files , must decompress first
INPUTDIR="${BASEDIR}/mirbase/input"
RESOURCESDIR="${INPUTDIR}/resources"
RESOURCESPREFIX="maturemiRNA_index"
FASTQDIR="${INPUTDIR}/filtertrimmedreads"

FASTQFILENAMES=(`ls -1 "${FASTQDIR}"`)
FASTQFILENAME="${FASTQFILENAMES[${SLURM_ARRAY_TASK_ID}]}"
SAMPLEID=${FASTQFILENAME/%"filtered.trimmed.fastq.gz"}

# Generated output diretory automatically
OUTPUTDIR="${BASEDIR}/output/${JOBNAME}"
mkdir -p $OUTPUTDIR

bowtie -n 0 -l 30 \
  --norc --best --strata -m 1 --threads 1 \
 -x "${RESOURCESDIR}/${RESOURCESPREFIX}" \
  -q "${FASTQDIR}/${FASTQFILENAME}" \
  --un "${OUTPUTDIR}/${SAMPLEID}.unalignedbowtiemirbase.fastq" \
  --al "${OUTPUTDIR}/${SAMPLEID}.alignedbowtiemirbase.fastq"   \
  --sam "${OUTPUTDIR}/${SAMPLEID}.alignedbowtiemirbase.sam"



