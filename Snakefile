import pandas as pd
from snakemake.utils import min_version

min_version("5.18.0")

configfile: "config.json"

GLOBAL_REF_PATH = config["globalResources"]
GLOBAL_TMPD_PATH = config["globalTmpdPath"]

os.makedirs(GLOBAL_TMPD_PATH, exist_ok=True)

##### Config processing #####

sample_tab = pd.DataFrame.from_dict(config["samples"],orient="index")

if not config["is_paired"]:
    read_pair_tags = ["R1"]
    paired = "SE"
else:
    read_pair_tags = ["R1","R2"]
    paired = "PE"

if not 'check_adaptors' in config:
    config['check_adaptors'] = False
if not 'min_adapter_matches' in config:
    config['min_adapter_matches'] = 12
if not 'species_detector' in config:
    config['species_detector'] = False
if not "max_reads_for_sp_detector" in config:
    config["max_reads_for_sp_detector"] = 1000
if not "evalue_for_sp_detector" in config:
    config["evalue_for_sp_detector"] = 1e-15

wildcard_constraints:
    sample = "|".join(sample_tab.sample_name),
    read_pair_tag = "R1|R2|SE"

# ##### Target rules #####

def all_input(wildcard):
    if config["filesender"]:
        return ["raw_fastq_qc.tar.gz","qc_reports/raw_fastq_multiqc.html"]
    else:
        return "qc_reports/raw_fastq_multiqc.html"

rule all:
        input: all_input

##### Modules #####

include: "rules/fastqc.smk"
include: "rules/check_adaptors.smk"
