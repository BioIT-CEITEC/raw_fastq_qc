## ANNOTATION of VARIANTS in SAMPLES

rule merge_fastq_qc:
   input:  html = expand("qc_reports/{sample}/raw_fastqc/{read_pair_tag}_fastqc.html",sample = sample_tab.sample_name,read_pair_tag = read_pair_tags)
   output: html = "qc_reports/raw_fastq_multiqc.html"
   log:    "logs/merge_fastq_qc.log"
   conda:  "../wrappers/merge_fastq_qc/env.yaml"
   script: "../wrappers/merge_fastq_qc/script.py"

def raw_fastq_qc_input(wildcards):
    if wildcards.read_pair_tag == "SE":
        input_fastq_read_pair_tag = ""
    else:
        input_fastq_read_pair_tag = "_" + wildcards.read_pair_tag

    return('raw_fastq/{wildcards.sample}{input_fastq_read_pair_tag}.fastq.gz')


rule raw_fastq_qc:
    input:  raw_fastq_qc_input
    output: html = "qc_reports/{sample}/raw_fastqc/{read_pair_tag}_fastqc.html"
    log:    "logs/{sample}/raw_fastqc{read_pair_tag}.log"
    params: extra = "--noextract --format fastq --nogroup",
            # lib_name = config["library_name"]
    threads:  1
    conda:  "../wrappers/raw_fastq_qc/env.yaml"
