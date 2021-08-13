## ANNOTATION of VARIANTS in SAMPLES

rule merge_fastq_qc:
   input:  html = expand("qc_reports/{sample}/raw_fastqc/fastqc{read_pair_tag}.html",sample = sample_tab.sample_name,read_pair_tag = read_pair_tags)
   output: html = "qc_reports/raw_fastq_multiqc.html"
   log:    "logs/merge_fastq_qc.log"
   conda:  "../wrappers/merge_fastq_qc/env.yaml"
   script: "../wrappers/merge_fastq_qc/script.py"


rule raw_fastq_qc:
    input:  raw_fastq = "raw_fastq/{sample}{read_pair_tag}.fastq.gz",
    output: html = "qc_reports/{sample}/raw_fastqc/fastqc{read_pair_tag}.html"
    log:    "logs/{sample}/raw_fastqc{read_pair_tag}.log"
    params: extra = "--noextract --format fastq --nogroup",
            # lib_name = config["library_name"]
    threads:  1
    conda:  "../wrappers/raw_fastq_qc/env.yaml"
    script: "../wrappers/raw_fastq_qc/script.py"

