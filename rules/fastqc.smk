## ANNOTATION of VARIANTS in SAMPLES
rule merge_fastq_qc:
    input:  html = expand("raw_fastq_qc/{sample}_{read_pair_tag}_fastqc.html",sample = sample_tab.sample_name,read_pair_tag = read_pair_tags)
    output: html = "raw_fastqc.multiqc_report.html",
    log:    "logs/merge_fastq_qc.log"
    params:
        run_log_dir = cfg['bcl2fastq_log_dir'].tolist()[0] if "bcl2fastq_log_dir" in cfg else None,
    conda: "../wrappers/merge_fastq_qc/env.yaml"
    script: "../wrappers/merge_fastq_qc/script.py"


rule raw_fastq_qc:
    input:  reads = "raw_fastq/{sample}_{read_pair_tag}.fastq.gz"
    output: html = "raw_fastq_qc/{sample}_{read_pair_tag}_fastqc.html"
    log:    run = "logs/sample_logs/{sample}/raw_fastq_qc_{read_pair_tag}.log"
    params: extra = "--noextract --format fastq --nogroup"
    threads:  1
    conda:  "../wrappers/raw_fastq_qc/env.yaml"
    script: "../wrappers/raw_fastq_qc/script.py"


