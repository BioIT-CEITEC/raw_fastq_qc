import pandas as pd
from snakemake.utils import min_version
from snakemake.remote.S3 import RemoteProvider as S3RemoteProvider

min_version("5.18.0")

configfile: "configfile.json" ### kubernetes
#configfile: "config.json" ### local


AWS_ID="acgt"
AWS_KEY="P84RsiL5TmHu0Ijd"
S3_BUCKET = "acgt/"
path = "sequia/210923__raw_fastq_qc__MOII_e91_krve__960/"

S3 = S3RemoteProvider(host="https://storage-elixir1.cerit-sc.cz",access_key_id=AWS_ID, secret_access_key=AWS_KEY)

def fetch_data(file_path):
    if config["computing_type"] == "kubernetes":
        if isinstance(file_path, list) and len(file_path) == 1:
            return S3.remote(S3_BUCKET + path + file_path[0])
        else:
            if isinstance(file_path, str):
                return S3.remote(S3_BUCKET + path + file_path)
            else:
                return S3.remote(S3_BUCKET + path + x for x in file_path)
    else:
        if isinstance(file_path, list) and len(file_path) == 1:
            return file_path[0]
        else:
            return file_path


##### Config processing #####

sample_tab = pd.DataFrame.from_dict(config["samples"],orient="index")

if config["lib_reverse_read_length"] == 0:
    read_pair_tags = ["SE"]
else:
    read_pair_tags = ["R1","R2"]

wildcard_constraints:
    sample = "|".join(sample_tab.sample_name),
    read_pair_tag = "R1|R2|SE"

##### Target rules #####

rule all:
   input: fetch_data("qc_reports/raw_fastq_multiqc.html")

##### Modules #####

include: "rules/fastqc.smk",



