######################################
# wrapper for rule: merge_fastq_qc
######################################
import subprocess
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
              +snakemake.output.html+" ./"\
              " --cl_config \"{{read_count_multiplier: 0.001, read_count_prefix: 'K', read_count_desc: 'thousands' }}\" >> "+snakemake.log.run+" 2>&1"
f = open(snakemake.log.run, 'at')
f.write("## COMMAND: "+command+"\n")
f.close()
shell(command)
