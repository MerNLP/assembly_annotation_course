cat > scripts/01_fastqc.slurm << 'EOF'
#!/usr/bin/env bash
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --time=01:00:00
#SBATCH --job-name=fastqc
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/mlawrence/assembly_annotation_course/logs/fastqc_%j.o
#SBATCH --error=/data/users/mlawrence/assembly_annotation_course/logs/fastqc_%j.e

set -euo pipefail

BASE="/data/users/mlawrence/assembly_annotation_course"
OUT="$BASE/read_QC/fastqc"
mkdir -p "$OUT"

module purge
module load FastQC/0.11.9-Java-11

# Run FastQC on all fastq(.gz) files in Kar-1 (HiFi) and RNAseq_Sha (Illumina)
find "$BASE/Kar-1" "$BASE/RNAseq_Sha" -type f \( -name "*.fastq" -o -name "*.fastq.gz" \) \
  -print0 | xargs -0 -n 8 -P 1 fastqc -o "$OUT"
EOF
