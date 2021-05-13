#import pandas as pd
from snakemake.utils import min_version

min_version("5.18.0")

##### Config processing #####

configfile: "workflow.config.json"

#sample_tab = pd.DataFrame.from_dict(config["samples"],orient="index")
#print(sample_tab)

if config["lib_reverse_read_length"] == 0:
    read_pair_tags = ["R1"]
else:
    read_pair_tags = ["R1","R2"]

##### Target rules #####

rule all:
    input: "raw_fastqc.multiqc_report.html"


##### Modules #####

include: "rules/fastqc.smk"




