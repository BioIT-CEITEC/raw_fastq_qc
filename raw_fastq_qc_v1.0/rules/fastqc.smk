## ANNOTATION of VARIANTS in SAMPLES
rule merge_fastq_qc:
    input:  html = expand("raw_fastq_qc/{sample}_{read_pair_tag}_fastqc.html",sample = sample_tab.sample_name,read_pair_tag = read_pair_tags)
    output: html = "raw_fastqc.multiqc_report.html",
    log:    "logs/merge_fastq_qc.log"
    shell:  "touch {output.html}"

rule raw_fastq_qc:
    input:  reads = "raw_fastq/{sample}_{read_pair_tag}.fastq.gz"
    output: html = "raw_fastq_qc/{sample}_{read_pair_tag}_fastqc.html"
    log:    run = "logs/sample_logs/{sample}/raw_fastq_qc_{read_pair_tag}.log"
    params: extra = "--noextract --format fastq --nogroup"
    threads:  1
    shell:  "mkdir -p raw_fastq_qc;touch {output}"
