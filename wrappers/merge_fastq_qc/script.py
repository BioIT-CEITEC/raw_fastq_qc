######################################
# wrapper for rule: merge_fastq_qc
######################################
import subprocess
from os.path import dirname
from snakemake.shell import shell
shell.executable("/bin/bash")
log_filename = str(snakemake.log)

f = open(log_filename, 'wt')
f.write("\n##\n## RULE: merge_fastq_qc \n##\n")
f.close()

version = str(subprocess.Popen("multiqc --version 2>&1 ",shell=True,stdout=subprocess.PIPE).communicate()[0], 'utf-8')
f = open(log_filename, 'at')
f.write("## VERSION: "+version+"\n")
f.close()

command = "multiqc -f -n " + snakemake.output.html + " " + " ".join([dirname(fastqc_html) for fastqc_html in snakemake.input.html]) + \
              " --cl_config \"{{read_count_multiplier: 0.001, read_count_prefix: 'K', read_count_desc: 'thousands' }}\" >> "+log_filename+" 2>&1"
f = open(log_filename, 'at')
f.write("## COMMAND: "+command+"\n")
f.close()
shell(command)
