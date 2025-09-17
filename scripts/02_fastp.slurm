#!/usr/bin/env bash
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=02:00:00
#SBATCH --job-name=fastp
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/mlawrence/assembly_annotation_course/logs/fastp_%j.o
#SBATCH --error=/data/users/mlawrence/assembly_annotation_course/logs/fastp_%j.e
#SBATCH --mail-user=merlynelawrence@students.unibe.ch
#SBATCH --mail-type=END,FAIL

set -euo pipefail
source /data/users/mlawrence/assembly_annotation_course/scripts/00_env.sh

module purge
module load fastp/0.23.4 || module load fastp || {
  echo "fastp module not found. Check module avail." >&2
  exit 1
}

export _JAVA_OPTIONS="-Djava.awt.headless=true"

# ---- Inputs ----
R1="${BASE}/RNAseq_Sha/ERR754081_1.fastq.gz"
R2="${BASE}/RNAseq_Sha/ERR754081_2.fastq.gz"
HIFI="${BASE}/${ACCESSION}/ERR11437325.fastq.gz"

[[ -s "$R1" && -s "$R2" ]] || { echo "RNA-seq inputs not found"; exit 2; }
[[ -s "$HIFI" ]] || { echo "HiFi input not found"; exit 2; }

mkdir -p "${OUT_FASTP}"

# ---- RNA-seq (paired-end) ----
echo "===> fastp on RNA-seq (paired-end trim/filter)"
fastp \
  -i "${R1}" -I "${R2}" \
  -o "${OUT_FASTP}/RNAseq_Sha.trimmed_R1.fastq.gz" \
  -O "${OUT_FASTP}/RNAseq_Sha.trimmed_R2.fastq.gz" \
  --detect_adapter_for_pe \
  --thread 4 \
  --html "${OUT_FASTP}/RNAseq_Sha.fastp.html" \
  --json "${OUT_FASTP}/RNAseq_Sha.fastp.json"

# ---- HiFi (single-end, stats only) ----
echo "===> fastp on HiFi (stats only; no filtering)"
fastp \
  -i "${HIFI}" \
  -o "${OUT_FASTP}/${ACCESSION}.HiFi.pass.fastq.gz" \
  --disable_length_filtering \
  --disable_quality_filtering \
  --dont_overwrite \
  --thread 4 \
  --html "${OUT_FASTP}/${ACCESSION}.HiFi.fastp.html" \
  --json "${OUT_FASTP}/${ACCESSION}.HiFi.fastp.json"

echo "===> Done. Reports in: ${OUT_FASTP}"
echo "Tip: Open ${OUT_FASTP}/${ACCESSION}.HiFi.fastp.json and look for \"total_bases\" to estimate coverage."
