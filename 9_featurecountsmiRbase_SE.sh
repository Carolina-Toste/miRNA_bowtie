#!/bin/bash
#SBATCH --job-name=featurecountsmirbase
#SBATCH --account=scw1877
#SBATCH --partition=c_compute_neuro1
#SBATCH --time=00:30:00
#SBATCH --output=logs/o.%J
#SBATCH --error=logs/e.%J
#SBATCH --array=0-161


module load samtools/1.9
module load subread/2.0.0-binary

JOBNAME="featurecountsmirbase"
BASEDIR="/scratch/${USER}"

# Create this directory manually and add markduplicate files
INPUTDIR="${BASEDIR}/mirbase/input"
RESOURCESDIR="${INPUTDIR}/resources"
RESOURCESPREFIX="maturemiRNA"
MARKDUPDIR="${INPUTDIR}/markduplicatesmirbase" 

MARKDUPFILENAMES=(`ls -1 "${MARKDUPDIR}"`)
MARKDUPFILENAME="${MARKDUPFILENAMES[${SLURM_ARRAY_TASK_ID}]}"
SAMPLEID=${MARKDUPFILENAME/%".markdup.bam"}

# Generated output diretory automatically
OUTPUTDIR="${BASEDIR}/output/${JOBNAME}"
mkdir -p $OUTPUTDIR




samtools sort -n "${MARKDUPDIR}/${MARKDUPFILENAME}" \ 

"${OUTPUTDIR}/${SAMPLEID}.markdup.sorted" \

cd ${OUTPUTDIR}/${SAMPLEID} && featureCounts -F GTF -t miRNA -g Name -O -s 1 -M -a "${RESOURCESDIR}/${RESOURCESPREFIX}.gtf" \

-o "${OUTPUTDIR}/${SAMPLEID}.markdup.featurecount" "${OUTPUTDIR}/${SAMPLEID}.markdup.sorted.bam"

samtools sort -n "${OUTPUTDIR}/${SAMPLEID}.rmdup.bam" \

"${OUTPUTDIR}/${SAMPLEID}.rmdup.sorted" \

cd ${OUTPUTDIR}/${SAMPLEID} && featureCounts -F GTF -t miRNA -g Name -O -s 1 -M -a "${RESOURCESDIR}/${RESOURCESPREFIX}.gtf" \

-o "${OUTPUTDIR}/${SAMPLEID}.rmdup.featurecount"  "${OUTPUTDIR}/${SAMPLEID}.rmdup.sorted.bam"
