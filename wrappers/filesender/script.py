######################################
# wrapper for rule: filesender
######################################
import os
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

if snakemake.params.config != "":

    ff = open(str(snakemake.params.credentials))
    filesender_credentials = json.load(ff)
    ff.close()

    username = filesender_credentials["username"]
    apikey = filesender_credentials["apikey"]
    A = str(snakemake.input.html).replace("qc_reports/*/raw_fastqc/*_fastqc.html", "")

    f = open(log_filename, 'at')
    f.write("####" +filesender_credentials+" "+username+" "+username+"\n"+A)
    f.close()





    command = "tar -czvf " + snakemake.output.gz + " " + snakemake.input.raw_fastq + " " + str(snakemake.input.html) + " >> " +log_filename+" 2>&1"
    f = open(log_filename, 'at')
    f.write("## COMMAND: "+command+"\n")
    f.close()
    shell(command)

    command = "python3 wrappers/filesender/filesender.py -u " + username + " -a " + apikey + " -r " + snakemake.params.recipient + " " + snakemake.output.gz + " >> "+log_filename+" 2>&1"
    f = open(log_filename, 'at')
    f.write("## COMMAND: "+command+"\n")
    f.close()
    shell(command)

else:
    f = open(log_filename, 'at')
    f.write("## No recipient specified. ##\n")
    f.close()