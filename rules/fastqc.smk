## ANNOTATION of VARIANTS in SAMPLES

rule merge_fastq_qc:
   input:  zip = fetch_data(expand("qc_reports/{sample}/raw_fastqc/{read_pair_tag}_fastqc.zip",sample = sample_tab.sample_name,read_pair_tag = read_pair_tags))
   output: html = fetch_data("qc_reports/raw_fastq_multiqc.html")
   log:    "logs/merge_fastq_qc.log"
   conda:  "../wrappers/merge_fastq_qc/env.yaml"
   script: "../wrappers/merge_fastq_qc/script.py"

def raw_fastq_qc_input(wildcards):
    if wildcards.read_pair_tag == "SE":
        input_fastq_read_pair_tag = ""
    else:
        input_fastq_read_pair_tag = "_" + wildcards.read_pair_tag

    return(fetch_data(f'raw_fastq/{wildcards.sample}{input_fastq_read_pair_tag}.fastq.gz'))

rule raw_fastq_qc:
    input:  raw_fastq = raw_fastq_qc_input
    output: html = fetch_data("qc_reports/{sample}/raw_fastqc/{read_pair_tag}_fastqc.html"),
            zip = fetch_data("qc_reports/{sample}/raw_fastqc/{read_pair_tag}_fastqc.zip")
    log:    fetch_data("logs/{sample}/raw_fastqc_{read_pair_tag}.log")
    params: extra = "--noextract --format fastq --nogroup",
    threads:  1
    conda:  "../wrappers/raw_fastq_qc/env.yaml"
    script: "../wrappers/raw_fastq_qc/script.py"
