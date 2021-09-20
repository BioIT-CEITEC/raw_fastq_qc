import pandas as pd
from snakemake.utils import min_version

min_version("5.18.0")

def fetch_data(file_path):
    if config["computing_type"] == "kubernetes":
        if isinstance(file_path, list) and len(file_path) == 1:
            return S3.remote(S3_BUCKET + "/" + file_path[0])
        else:
            return S3.remote(S3_BUCKET + "/" + file_path)
    else:
        if isinstance(file_path, list) and len(file_path) == 1:
            return file_path[0]
        else:
            return file_path

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
   input: fetch_data("qc_reports/raw_fastq_multiqc.html")

##### Modules #####

include: "rules/fastqc.smk"


