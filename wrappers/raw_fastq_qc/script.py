######################################
# wrapper for rule: raw_fastq_qc
######################################
import os
import sys
import math
import subprocess
from snakemake.shell import shell

f = open(snakemake.log.run, 'a+')
f.write("\n##\n## RULE: raw_fastq_qc \n##\n")
f.close()

TOOL = "fastqc"

shell.executable("/bin/bash")

version = str(subprocess.Popen(TOOL+" --version 2>&1", shell=True, stdout=subprocess.PIPE).communicate()[0], 'utf-8')
f = open(snakemake.log.run, 'at')
f.write("## VERSION: "+version+"\n")
f.close()

command = "mkdir -p `dirname "+snakemake.output.html+"`"+" >> "+snakemake.log.run+" 2>&1"
f = open(snakemake.log.run, 'at')
f.write("## COMMAND: "+command+"\n")
f.close()
shell(command)

command = TOOL+" -o "+snakemake.params.prefix+" "+snakemake.params.extra+" --threads "+str(snakemake.threads)+" "+snakemake.input.reads+" >> "+snakemake.log.run+" 2>&1 "
f = open(snakemake.log.run, 'at')
f.write("## COMMAND: "+command+"\n")
f.close()
shell(command)

command = ' sed -r -i "s:<h2>[ ]*Summary[ ]*<\/h2><ul>:&<li><b>Return to <a href=\'../'+snakemake.params.lib_name+'.final_report.html\'>start page<\/a><\/b><\/li>:" '+snakemake.output.html
f = open(snakemake.log.run, 'at')
f.write("## COMMAND: "+command+"\n")
f.close()
shell(command)

#command = "rm -f "+snakemake.params.html+" >> "+snakemake.log.run+" 2>&1"
#f = open(snakemake.log.run, 'at')
#f.write("## COMMAND: "+command+"\n")
#f.close()
#shell(command)

#command = "cat `ls -tr "+ os.path.dirname(snakemake.log.run) +"/*.log` > "+snakemake.log.run.replace("test/raw_fastq_qc_"+snakemake.wildcards.read_pair_tag+".log",".bcl2fastq.log")
#f = open(snakemake.log.run, 'at')
#f.write("## COMMAND: "+command+"\n")
#f.close()
#shell(command)

# OLD STUFF:
# run:
#     shell(" {FASTQC} -o {params.prefix} {params.extra} --threads {threads} {input.reads} > {log.run} 2>&1 ")
#     shell(' sed -r "s:<h2>[ ]*Summary[ ]*<\/h2><ul>:&<li><b>Return to <a href=\'../{wildcards.run_name}.final_report.html\'>start page<\/a><\/b><\/li>:" {params.html} > {output.html} ')
#     # shell(" mv -T {params.html} {output.html} ")
