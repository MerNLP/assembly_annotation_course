#!/usr/bin/env bash
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --time=01:00:00
#SBATCH --job-name=fastqc
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/mlawrence/assembly_annotation_course/logs/fastqc_%j.o
#SBATCH --error=/data/users/mlawrence/assembly_annotation_course/logs/fastqc_%j.e
#SBATCH --mail-user=merlynelawrence@students.unibe.ch
#SBATCH --mail-type=end

set -euo pipefail
source /data/users/mlawrence/assembly_annotation_course/scripts/00_env.sh

module purge
module load FastQC/0.11.9-Java-11

echo "===> Running FastQC"
had_files="no"
for fq in "${BASE}/${ACCESSION}"/*.fastq.gz "${BASE}/RNAseq_Sha"/*.fastq.gz; do
  if [[ -e "$fq" ]]; then
    had_files="yes"
    echo "FastQC on: $fq"
    fastqc -o "${OUT_FASTQC}" "$fq"
  fi
done

if [[ "$had_files" == "no" ]]; then
  echo "No FASTQ(.gz) files found under ${BASE}/${ACCESSION} or ${BASE}/RNAseq_Sha" >&2
  exit 2
fi

echo "===> Done. Reports in: ${OUT_FASTQC}"
