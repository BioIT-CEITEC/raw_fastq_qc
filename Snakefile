import pandas as pd
from snakemake.utils import min_version

min_version("5.18.0")

##### Config processing #####

sample_tab = pd.DataFrame.from_dict(config["samples"],orient="index")

if config["lib_reverse_read_length"] == 0:
    read_pair_tags = [""]
else:
    read_pair_tags = ["R1_","_R2"]

wildcard_constraints:
    sample = "|".join(sample_tab.sample_name),
    read_pair_tag = "(_R.)?"

##### Target rules #####

rule all:
   input: "qc_reports/raw_fastq_multiqc.html"

##### Modules #####

include: "rules/fastqc.smk",



