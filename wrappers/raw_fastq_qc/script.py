######################################
# wrapper for rule: raw_fastq_qc
######################################

import subprocess
from snakemake.shell import shell
shell.executable("/bin/bash")
log_filename = str(snakemake.log)

f = open(log_filename, 'wt')
f.write("\n##\n## RULE: raw_fastq_qc \n##\n")
f.close()

version = str(subprocess.Popen("fastqc --version 2>&1", shell=True, stdout=subprocess.PIPE).communicate()[0], 'utf-8')
f = open(log_filename, 'at')
f.write("## VERSION: "+version+"\n")
f.close()

command = "mkdir -p `dirname "+snakemake.output.html+"`"+" >> "+log_filename+" 2>&1"
f = open(log_filename, 'at')
f.write("## COMMAND: "+command+"\n")
f.close()
shell(command)

command = "fastqc -o "+snakemake.params.prefix+" "+snakemake.params.extra+" --threads "+str(snakemake.threads)+" "+snakemake.input.reads+" >> "+log_filename+" 2>&1 "
f = open(log_filename, 'at')
f.write("## COMMAND: "+command+"\n")
f.close()
shell(command)

command = ' sed -r -i "s:<h2>[ ]*Summary[ ]*<\/h2><ul>:&<li><b>Return to <a href=\'../'+snakemake.params.lib_name+'.final_report.html\'>start page<\/a><\/b><\/li>:" '+snakemake.output.html
f = open(log_filename, 'at')
f.write("## COMMAND: "+command+"\n")
f.close()
shell(command)
