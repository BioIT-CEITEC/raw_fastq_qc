######################################
# wrapper for rule: filesender
######################################
import subprocess
from os.path import dirname
from os.path import basename
from snakemake.shell import shell
shell.executable("/bin/bash")
log_filename = str(snakemake.log)

f = open(log_filename, 'wt')
f.write("\n##\n## RULE: raw_fastq_qc \n##\n")
f.close()

version = str(subprocess.Popen("conda list ", shell=True, stdout=subprocess.PIPE).communicate()[0], 'utf-8')
f = open(log_filename, 'at')
f.write("## CONDA: "+version+"\n")
f.close()

command = "zip -r " + snakemake.output.zip + " " + str(snakemake.input.raw_fastq) + " " + str(snakemake.input.html) + " >> " +log_filename+" 2>&1"
f = open(log_filename, 'at')
f.write("## COMMAND: "+command+"\n")
f.close()
shell(command)

command = "python3 filesender.py -u " + snakemake.params.username + " -a " + snakemake.params.apikey + " -r " + snakemake.params.recipient + " " + snakemake.output.zip + " >> "+log_filename+" 2>&1"
f = open(log_filename, 'at')
f.write("## COMMAND: "+command+"\n")
f.close()
shell(command)