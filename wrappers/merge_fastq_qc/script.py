######################################
# wrapper for rule: merge_fastq_qc
######################################
import os
import sys
import math
import subprocess
import re
from snakemake.shell import shell

TOOL = "multiqc"

shell.executable("/bin/bash")

f = open(snakemake.log.run, 'wt')
f.write("\n##\n## RULE: merge_fastq_qc \n##\n")
f.close()

version = str(subprocess.Popen(TOOL+" --version 2>&1 ",shell=True,stdout=subprocess.PIPE).communicate()[0], 'utf-8')
f = open(snakemake.log.run, 'at')
f.write("## VERSION: "+version+"\n")
f.close()

command = TOOL+" -f -n "\
            +snakemake.output.html+" --cl_config \"{{read_count_multiplier: 0.001, read_count_prefix: 'K', read_count_desc: 'thousands' }}\" >> "+snakemake.log.run+" 2>&1"
f = open(snakemake.log.run, 'at')
f.write("## COMMAND: "+command+"\n")
f.close()
shell(command)

#if snakemake.params.run_log_dir:
#    read_sum = 0
#    for fastqc_file in snakemake.input.html:
#        f = open(fastqc_file, 'r')
#        for line in f:
#            if "Total Sequences</td><td>" in line:
#                num = re.sub('.*Total Sequences</td><td>([0-9]*)</td>.*',r'\1',line)
#                num = int(num)
#        read_sum = read_sum + num

    #f = open(snakemake.params.run_log_dir + "/per_library_read_sum.tsv", 'a+')
    #f.write("\t"+str(read_sum)+"\n")
    #f.close()