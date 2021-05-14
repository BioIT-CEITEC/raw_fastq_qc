import pandas as pd
from snakemake.utils import min_version

min_version("5.18.0")

##### Config processing #####

sample_tab = pd.DataFrame.from_dict(config["samples"],orient="index")
print(sample_tab)

if config["lib_reverse_read_length"] == 0:
    read_pair_tags = ["R1"]
else:
    read_pair_tags = ["R1","R2"]


##### Target rules #####

#rule all:
#    input: "test/raw_fastqc.multiqc_report.html"
rule all:
    input: expand("test/raw_fastq_qc/{sample}_{read_pair_tag}_fastqc.html",sample = sample_tab.sample_name,read_pair_tag = read_pair_tags)

##### Modules #####

include: "rules/fastqc.smk"


