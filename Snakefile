from snakemake.utils import min_version

min_version("7.2.1")

configfile: "config.json"

config["computing_type"] = "kubernetes"

module BR:
    snakefile: gitlab("bioroots/bioroots_utilities", path="bioroots_utilities.smk",branch="main")
    config: config

use rule * from BR as other_*

##### Config processing #####

GLOBAL_REF_PATH = config["globalResources"]
sample_tab = BR.load_sample()
read_pair_tags = BR.set_read_pair_tags()

if read_pair_tags == [""]:
    read_pair_tags[0] = read_pair_tags[0].replace("","SE")
else:
    read_pair_tags[0] = read_pair_tags[0].replace("_","")
    read_pair_tags[1] = read_pair_tags[1].replace("_","")


if not 'check_adaptors' in config:
    config['check_adaptors'] = False
if not 'min_adapter_matches' in config:
    config['min_adapter_matches'] = 12


wildcard_constraints:
    sample = "|".join(sample_tab.sample_name),
    read_pair_tag = "R1|R2|SE"

# ##### Target rules #####

def all_input(wildcard):
    if config["filesender"]:
        return BR.remote(["qc_reports/raw_fastq_qc.tar.gz","qc_reports/raw_fastq_multiqc.html"])
    else:
        return BR.remote("qc_reports/raw_fastq_multiqc.html")

rule all:
        input: all_input

##### Modules #####

include: "rules/fastqc.smk"
include: "rules/check_adaptors.smk"