## ANNOTATION of VARIANTS in SAMPLES
#



rule filesender:
    input:  raw_fastq = expand("raw_fastq/{sample}_{read_pair_tag}.fastq.gz",sample = sample_tab.sample_name,read_pair_tag = read_pair_tags),
            html = "qc_reports/raw_fastq_multiqc.html",
    output: zip = "qc_reports/raw_fastq_qc.zip"
    #log:    "logs/filesender.log"
    params: recipient = "juraskovakaterina@seznam.cz",
            # username = "ad4520e02b8d4ef9267f830ebb618bd67d1a504e@einfra.cesnet.cz",
            # apikey = "36b8932ac7599cd3b3151fcf910e0181589c48e58b574275e7811d22e7cc03e6"
            username = "04e31f55649620f91f9225e2ebdc6941b2e1286e@einfra.cesnet.cz",
            apikey = "f912de100f733dac7572a4e392b8f0112ae1b332aca40146732f827baaf532fd"
    conda:  "../wrappers/filesender/env.yaml"
    script: "../wrappers/filesender/script.py"
    #shell: "python3 filesender.py -u {params.username} -a {params.apikey} -r {params.recipient} {output.zip}"


def merge_fastq_qc_input(wcs):
    inputs = {'html': expand("qc_reports/{sample}/raw_fastqc/{read_pair_tag}_fastqc.html",sample = sample_tab.sample_name,read_pair_tag = read_pair_tags)}
    if config['check_adaptors']:
        inputs['minion'] = "qc_reports/raw_fastq_minion_adaptors_mqc.tsv"
    return inputs

rule merge_fastq_qc:
    input:  unpack(merge_fastq_qc_input)
    # input:  html = expand("qc_reports/{sample}/raw_fastqc/{read_pair_tag}_fastqc.html",sample = sample_tab.sample_name,read_pair_tag = read_pair_tags)
    output: html = "qc_reports/raw_fastq_multiqc.html"
    log:    "logs/merge_fastq_qc.log"
    conda:  "../wrappers/merge_fastq_qc/env.yaml"
    script: "../wrappers/merge_fastq_qc/script.py"

def raw_fastq_qc_input(wildcards):
    if wildcards.read_pair_tag == "SE":
        input_fastq_read_pair_tag = ""
    else:
        input_fastq_read_pair_tag = "_" + wildcards.read_pair_tag
    return f'raw_fastq/{wildcards.sample}{input_fastq_read_pair_tag}.fastq.gz'


rule raw_fastq_qc:
    input:  raw_fastq = raw_fastq_qc_input
    output: html = "qc_reports/{sample}/raw_fastqc/{read_pair_tag}_fastqc.html"
    log:    "logs/{sample}/raw_fastqc_{read_pair_tag}.log"
    params: extra = "--noextract --format fastq --nogroup",
            # lib_name = config["library_name"]
    threads:  1
    conda:  "../wrappers/raw_fastq_qc/env.yaml"
    script: "../wrappers/raw_fastq_qc/script.py"


