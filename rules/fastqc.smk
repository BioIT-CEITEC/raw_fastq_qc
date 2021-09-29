## ANNOTATION of VARIANTS in SAMPLES

rule merge_fastq_qc:
   input:  html = S3.remote(expand("acgt/sequia/210923__raw_fastq_qc__MOII_e91_krve__960/qc_reports/{sample}/raw_fastqc/fastqc{read_pair_tag}.html",sample = sample_tab.sample_name,read_pair_tag = read_pair_tags))
   output: html = S3.remote("acgt/sequia/210923__raw_fastq_qc__MOII_e91_krve__960/qc_reports/raw_fastq_multiqc.html")
   log:    "acgt/sequia/210923__raw_fastq_qc__MOII_e91_krve__960/logs/merge_fastq_qc.log"
   conda:  "../wrappers/merge_fastq_qc/env.yaml"
   script: "../wrappers/merge_fastq_qc/script.py"


rule raw_fastq_qc:
    input:  raw_fastq = S3.remote("acgt/sequia/210923__raw_fastq_qc__MOII_e91_krve__960/raw_fastq/{sample}{read_pair_tag}.fastq.gz"),
    output: html = S3.remote("acgt/sequia/210923__raw_fastq_qc__MOII_e91_krve__960/qc_reports/{sample}/raw_fastqc/fastqc{read_pair_tag}.html")
    log:    S3.remote("acgt/sequia/210923__raw_fastq_qc__MOII_e91_krve__960/logs/{sample}/raw_fastqc{read_pair_tag}.log")
    params: extra = "--noextract --format fastq --nogroup",
            # lib_name = config["library_name"]
    threads:  1
    conda:  "../wrappers/raw_fastq_qc/env.yaml"
    script: "../wrappers/raw_fastq_qc/script.py"

