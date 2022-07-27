## ANNOTATION of VARIANTS in SAMPLES
#
rule filesender:
    input:  raw_fastq = BR.remote("raw_fastq/"),
            html = BR.remote(expand("qc_reports/{sample}/raw_fastqc/{read_pair_tag}_fastqc.html",sample = sample_tab.sample_name,read_pair_tag = read_pair_tags)),
    output: gz = BR.remote("qc_reports/raw_fastq_qc.tar.gz")
    log:    BR.remote("logs/filesender.log")
    params: recipient = config["recipient"],
            subject = config["entity_name"],
            message = config["message"],
            credentials = BR.remote(os.path.join(config["globalResources"],"/resources_info/.secret/filesender_credentials.json")),
            res_file = BR.remote("qc_reports/")
    conda:  "../wrappers/filesender/env.yaml"
    script: "../wrappers/filesender/script.py"


def merge_fastq_qc_input(wcs):
    inputs = {'html': BR.remote(expand("qc_reports/{sample}/raw_fastqc/{read_pair_tag}_fastqc.zip",sample = sample_tab.sample_name,read_pair_tag = read_pair_tags))}
    if config['check_adaptors']:
        inputs['minion'] = BR.remote("qc_reports/raw_fastq_minion_adaptors_mqc.tsv")
    return inputs

rule merge_fastq_qc:
    input:  unpack(merge_fastq_qc_input)
    output: html = BR.remote("qc_reports/raw_fastq_multiqc.html")
    log:    BR.remote("logs/merge_fastq_qc.log")
    conda:  "../wrappers/merge_fastq_qc/env.yaml"
    script: "../wrappers/merge_fastq_qc/script.py"


def raw_fastq_qc_input(wildcards):
    if wildcards.read_pair_tag == "SE":
        input_fastq_read_pair_tag = ""
    else:
        input_fastq_read_pair_tag = "_" + wildcards.read_pair_tag
    return BR.remote(f'raw_fastq/{wildcards.sample}{input_fastq_read_pair_tag}.fastq.gz')

rule raw_fastq_qc:
    input:  raw_fastq = raw_fastq_qc_input
    output: html = BR.remote("qc_reports/{sample}/raw_fastqc/{read_pair_tag}_fastqc.html"),
            zip = BR.remote("qc_reports/{sample}/raw_fastqc/{read_pair_tag}_fastqc.zip")
    log:    BR.remote("logs/{sample}/raw_fastqc_{read_pair_tag}.log")
    params: extra = "--noextract --format fastq --nogroup",
    threads:  1
    conda:  "../wrappers/raw_fastq_qc/env.yaml"
    script: "../wrappers/raw_fastq_qc/script.py"
