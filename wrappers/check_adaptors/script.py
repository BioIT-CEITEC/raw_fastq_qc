######################################
# wrapper for rule: check_adaptors
######################################
import os
import sys
import math
import subprocess
import glob
from snakemake.shell import shell

shell.executable("/bin/bash")
log_filename = str(snakemake.log)

f = open(log_filename, 'a+')
f.write("\n##\n## RULE: check_adaptors \n##\n")
f.close()

version = str(subprocess.Popen("conda list", shell=True, stdout=subprocess.PIPE).communicate()[0], 'utf-8')
f = open(log_filename, 'at')
f.write("## CONDA: "+version+"\n")
f.close()

# ${MINION} search-adapter -i ${i} -show 3 -write-fasta ${SCRATCH}/minion/${i%.*}.minion.fasta
command = "minion search-adapter -i "+snakemake.input.fastq+" -show 3 -write-fasta "+snakemake.params.fasta+" >> " + log_filename + " 2>&1"
f = open(log_filename, 'at')
f.write("## COMMAND: "+command+"\n")
f.close()
shell(command)

# ${SWAN} -r ${SCRATCH}/${ADAPTERS} -q ${SCRATCH}/minion/${i%.*}.minion.fasta > ${SCRATCH}/minion/${i%.*}.minion.compare
command = "swan -r "+snakemake.params.adaptors+" -q "+snakemake.params.fasta+" > "+snakemake.output.comp+" 2>> " + log_filename
f = open(log_filename, 'at')
f.write("## COMMAND: "+command+"\n")
f.close()
shell(command)

