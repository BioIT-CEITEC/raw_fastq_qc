import pandas as pd
from snakemake.utils import min_version

min_version("5.18.0")

configfile: "config.json"

GLOBAL_REF_PATH = "/mnt/references"

##### Config processing #####

sample_tab = pd.DataFrame.from_dict(config["samples"],orient="index")

if not config["is_paired"]:
    read_pair_tags = ["SE"]
else:
    read_pair_tags = ["R1","R2"]

if not 'check_adaptors' in config:
    config['check_adaptors'] = False
if not 'min_adapter_matches' in config:
    config['min_adapter_matches'] = 12

wildcard_constraints:
    sample = "|".join(sample_tab.sample_name),
    read_pair_tag = "R1|R2|SE"


def all_input(wildcard):
    if config["filesender"]:
        return "qc_reports/raw_fastq_qc.zip"
    else:
        return "qc_reports/raw_fastq_multiqc.html"

rule all:
        input: unpack(all_input)

# ##### Target rules #####
#
# rule all:
#     input: "qc_reports/raw_fastq_qc.zip"

##### Modules #####

include: "rules/fastqc.smk"
include: "rules/check_adaptors.smk"
