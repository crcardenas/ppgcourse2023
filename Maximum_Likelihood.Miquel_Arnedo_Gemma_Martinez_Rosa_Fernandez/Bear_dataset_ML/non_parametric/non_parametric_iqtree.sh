#!/bin/sh
#SBATCH -n 1
#SBATCH -c 8
#SBATCH --mem=6G
#SBATCH -o slurm.%j.%x.out
#SBATCH -e slurm.%j.%x.err
#SBATCH --time=0-10:0

#module load 
module load iq-tree

iqtree -s 50_genes.fa -m LG+C20+F+G -b 10 -nt 8 -redo
