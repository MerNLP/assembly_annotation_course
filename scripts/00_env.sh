#!/usr/bin/env bash
# Global variables (edit here once if anything changes)

export USER_NAME="mlawrence"
export ACCESSION="Kar-1"

export BASE="/data/users/${USER_NAME}/assembly_annotation_course"
export RAW="/data/courses/assembly-annotation-course/raw_data"
export EMAIL="merlynelawrence@students.unibe.ch"

# Output dirs
export OUT_FASTQC="${BASE}/read_QC/fastqc"
export OUT_FASTP="${BASE}/read_QC/fastp"
export OUT_KMER="${BASE}/read_QC/kmer_counting"

mkdir -p "${BASE}/logs" "${OUT_FASTQC}" "${OUT_FASTP}" "${OUT_KMER}"
