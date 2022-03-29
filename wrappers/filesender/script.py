######################################
# wrapper for rule: filesender
######################################
import subprocess
import json
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

if "@" in snakemake.params.recipient:

    ff = open(str(snakemake.params.credentials))
    filesender_credentials = json.load(ff)
    ff.close()

    command = "tar -czvf " + snakemake.output.gz + " " + snakemake.input.raw_fastq + " " + snakemake.params.res_file + "* >> " + log_filename + " 2>&1"
    f = open(log_filename, 'at')
    f.write("## COMMAND: " + command + "\n")
    f.close()
    shell(command)

    command = "python3 wrappers/filesender/filesender.py -r " + snakemake.params.recipient + " -s Raw fastq files: " + snakemake.params.subject + " -m " + snakemake.params.message + " " + snakemake.output.gz + " >> " + log_filename + " 2>&1" #printing command without credentials
    f = open(log_filename, 'at')
    f.write("## COMMAND: " + command + "\n")
    f.close()
    shell("python3 wrappers/filesender/filesender.py -u " + filesender_credentials["username"] + " -a " + filesender_credentials["apikey"] + " -r " + snakemake.params.recipient +\
          " -s Raw fastq files: " + snakemake.params.subject + " -m " + snakemake.params.message + " " + snakemake.output.gz + " >> " + log_filename + " 2>&1")

else:
    f = open(log_filename, 'at')
    f.write("## Wrong email address.\n")
    f.close()

