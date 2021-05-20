## ANNOTATION of VARIANTS in SAMPLES

rule merge_fastq_qc:
   input:  html = expand("raw_fastq_qc/{sample}{read_pair_tag}_fastqc.html",sample = sample_tab.sample_name,read_pair_tag = read_pair_tags)
   output: html = "raw_fastqc.multiqc_report.html",
   log:    "logs/merge_fastq_qc.log"
   conda:  "../wrappers/merge_fastq_qc/env.yaml"
   script: "../wrappers/merge_fastq_qc/script.py"


rule raw_fastq_qc:
    input:  reads = "raw_fastq/{sample}{read_pair_tag}.fastq.gz"
    output: html = "raw_fastq_qc/{sample}{read_pair_tag}_fastqc.html"
    log:    "sample_logs/{sample}/raw_fastq_qc{read_pair_tag}.log"
    params: extra = "--noextract --format fastq --nogroup",
            prefix = "raw_fastq_qc",
            lib_name = config["library_name"]
    threads:  1
    conda:  "../wrappers/raw_fastq_qc/env.yaml"
    script: "../wrappers/raw_fastq_qc/script.py"

