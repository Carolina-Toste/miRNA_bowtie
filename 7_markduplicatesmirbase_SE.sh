#!/bin/bash
#SBATCH --job-name=markduplicatesmirbase
#SBATCH --account=scw1877
#SBATCH --partition=c_compute_neuro1
#SBATCH --time=00:30:00
#SBATCH --output=logs/o.%J
#SBATCH --error=logs/e.%J
#SBATCH --array=0-161

mmodule load raven
module load picard/2.20.2
module load samtools/1.9
module load java/11.0



JOBNAME="markduplicatesmirbase"
BASEDIR="/scratch/${USER}"

# This directory was created automatically as the output of the SAMtoBAM script
INPUTDIR="${BASEDIR}/mirbase/input"
BAMDIR="${INPUTDIR}/SAMtoBAMmirbase"

BAMFILENAMES=(`ls -1 "${BAMDIR}"`)
BAMFILENAME="${BAMFILENAMES[${SLURM_ARRAY_TASK_ID}]}"
SAMPLEID=${BAMFILENAME/%".alignedbowtiemirbase.sorted.bam"}

# Generated output diretory automatically
OUTPUTDIR="${BASEDIR}/output/${JOBNAME}"
mkdir -p $OUTPUTDIR


java -Xmx2g -jar $PICARD MarkDuplicates \
I=${BAMDIR}/${BAMFILENAME}.onemap.Aligned.sortedByCoord.out.bam \
O=${OUTPUTDIR}/${SAMPLEID}.markdup.bam \
M=${OUTPUTDIR}/${SAMPLEID}.metrics.txt REMOVE_DUPLICATES=false VALIDATION_STRINGENCY=SILENT

java -Xmx2g -jar $PICARD MarkDuplicates \
I=${BAMDIR}/${BAMFILENAME}.onemap.Aligned.sortedByCoord.out.bam \
O=${OUTPUTDIR}/${SAMPLEID}.rmdup.bam  \
M=${OUTPUTDIR}/${SAMPLEID}.metrics.txt REMOVE_DUPLICATES=true VALIDATION_STRINGENCY=SILENT

samtools index ${OUTPUTDIR}/${SAMPLEID}.markdup.bam
samtools index ${OUTPUTDIR}/${SAMPLEID}.rmdup.bam
