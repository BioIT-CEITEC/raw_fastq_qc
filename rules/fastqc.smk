## ANNOTATION of VARIANTS in SAMPLES

#rule merge_fastq_qc:
#    input:  html = expand("test/raw_fastq_qc/{sample}_{read_pair_tag}_fastqc.html",sample = sample_tab.sample_name,read_pair_tag = read_pair_tags)
#    output: html = "test/raw_fastqc.multiqc_report.html",
#    log:    run = "test/logs/merge_fastq_qc.log"
#    conda:  "../wrappers/merge_fastq_qc/env.yaml"
#    script: "../wrappers/merge_fastq_qc/script.py"


rule raw_fastq_qc:
    input:  reads = "input_files/raw_fastq/{sample}_{read_pair_tag}.fastq.gz"
    output: html = "test/raw_fastq_qc/{sample}_{read_pair_tag}_fastqc.html"
    log:    run = "test/logs/sample_logs/{sample}/raw_fastq_qc_{read_pair_tag}.log"
    params: extra = "--noextract --format fastq --nogroup",
            prefix = "test/raw_fastq_qc",
            html = "test/raw_fastq_qc/{sample}_{read_pair_tag}_fastqc.html",
            lib_name = config["lib_name"]
    threads:  1
    conda:  "../wrappers/raw_fastq_qc/env.yaml"
    script: "../wrappers/raw_fastq_qc/script.py"


