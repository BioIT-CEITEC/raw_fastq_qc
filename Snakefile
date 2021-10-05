import pandas as pd
import json
import boto3
from snakemake.utils import min_version
from snakemake.remote.S3 import RemoteProvider as S3RemoteProvider

configfile: "configfile.json"

min_version("5.18.0")

AWS_ID="acgt"
AWS_KEY="P84RsiL5TmHu0Ijd"
S3_BUCKET = "acgt"
path = "/sequia/210923__raw_fastq_qc__MOII_e91_krve__960/"

S3 = S3RemoteProvider(host="https://storage-elixir1.cerit-sc.cz",access_key_id=AWS_ID, secret_access_key=AWS_KEY)
# client = boto3.client('s3', aws_access_key_id=AWS_ID, aws_secret_access_key=AWS_KEY, region_name="US", endpoint_url="https://storage-elixir1.cerit-sc.cz")



def fetch_data(file_path):
    if config["computing_type"] == "kubernetes":
        if isinstance(file_path, list) and len(file_path) == 1:
            print(S3_BUCKET + path)
            print(file_path[0])
            return S3.remote(S3_BUCKET + path + file_path[0])
            # return S3.remote(S3_BUCKET + path + "".join(file_path[0]))
        else:
            print(S3_BUCKET + path)
            print(file_path[0])
            return S3.remote(S3_BUCKET + path + file_path)
            # return S3.remote(S3_BUCKET + path + "".join(file_path))
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
    read_pair_tags = ["_R1","_R2"]

wildcard_constraints:
    sample = "|".join(sample_tab.sample_name),
    read_pair_tag = "(_R.)?"

##### Target rules #####

rule all:
   input: S3.remote("acgt/sequia/210923__raw_fastq_qc__MOII_e91_krve__960/qc_reports/raw_fastq_multiqc.html")
   #input: fetch_data("qc_reports/raw_fastq_multiqc.html")

##### Modules #####

include: "rules/fastqc.smk",



