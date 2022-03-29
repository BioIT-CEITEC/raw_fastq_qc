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

    username = filesender_credentials["username"]
    apikey = filesender_credentials["apikey"]

    command = "tar -czvf " + snakemake.output.gz + " " + snakemake.input.raw_fastq + " " + snakemake.params.res_file + "* >> " + log_filename + " 2>&1"
    f = open(log_filename, 'at')
    f.write("## COMMAND: " + command + "\n")
    f.close()
    shell(command)

    command = "python3 wrappers/filesender/filesender.py -u " + username + " -a " + apikey + " -r " + snakemake.params.recipient + " " + snakemake.output.gz + " >> " + log_filename + " 2>&1"
    f = open(log_filename, 'at')
    f.write("## COMMAND: " + command + "\n")
    f.close()
    shell(command)
else:
    f = open(log_filename, 'at')
    f.write("## Wrong email address.\n")
    f.close()

    # titul: raw fastq files: <name>
    # message: Dear customer,\
    # we are sending you the prepared fastq files from your sequencing. You have 10 days to download data.\
    # Thank you for using our facility. Best regards, Core facility of Bioinformatics and Genomics team.
