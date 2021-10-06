## ANNOTATION of VARIANTS in SAMPLES

rule merge_fastq_qc:
   input:  zip = S3.remote(expand("acgt/sequia/210923__raw_fastq_qc__MOII_e91_krve__960/qc_reports/{sample}/raw_fastqc/{read_pair_tag}_fastqc.zip",sample = sample_tab.sample_name,read_pair_tag = read_pair_tags))
   output: html = S3.remote("acgt/sequia/210923__raw_fastq_qc__MOII_e91_krve__960/qc_reports/raw_fastq_multiqc.html")
   log:    S3.remote("acgt/sequia/210923__raw_fastq_qc__MOII_e91_krve__960/logs/merge_fastq_qc.log")
   conda:  "../wrappers/merge_fastq_qc/env.yaml"
   script: "../wrappers/merge_fastq_qc/script.py"


def raw_fastq_qc_input(wildcards):
    if wildcards.read_pair_tag == "SE":
        input_fastq_read_pair_tag = ""
    else:
        input_fastq_read_pair_tag = "_" + wildcards.read_pair_tag

    return(S3.remote(f'acgt/sequia/210923__raw_fastq_qc__MOII_e91_krve__960/raw_fastq/{wildcards.sample}{input_fastq_read_pair_tag}.fastq.gz'))

rule raw_fastq_qc:
    input:  raw_fastq = raw_fastq_qc_input
    output: html = S3.remote("acgt/sequia/210923__raw_fastq_qc__MOII_e91_krve__960/qc_reports/{sample}/raw_fastqc/{read_pair_tag}_fastqc.html"),
            zip= S3.remote("acgt/sequia/210923__raw_fastq_qc__MOII_e91_krve__960/qc_reports/{sample}/raw_fastqc/{read_pair_tag}_fastqc.zip")
    log:    S3.remote("acgt/sequia/210923__raw_fastq_qc__MOII_e91_krve__960/logs/{sample}/raw_fastqc_{read_pair_tag}.log")
    params: extra = "--noextract --format fastq --nogroup",
            # lib_name = config["library_name"]
    threads:  1
    conda:  "../wrappers/raw_fastq_qc/env.yaml"
    script: "../wrappers/raw_fastq_qc/script.py"

# rule merge_fastq_qc:
#    input:  zip = fetch_data(expand("qc_reports/{sample}/raw_fastqc/fastqc{read_pair_tag}.zip",sample = sample_tab.sample_name,read_pair_tag = read_pair_tags))
#    output: html = fetch_data("qc_reports/raw_fastq_multiqc.html")
#    log:    fetch_data("logs/merge_fastq_qc.log")
#    conda:  "../wrappers/merge_fastq_qc/env.yaml"
#    script: "../wrappers/merge_fastq_qc/script.py"
#
#
# rule raw_fastq_qc:
#     input:  raw_fastq = fetch_data("raw_fastq/{sample}{read_pair_tag}.fastq.gz"),
#     output: html = fetch_data("qc_reports/{sample}/raw_fastqc/fastqc{read_pair_tag}.html"),
#             zip= fetch_data("qc_reports/{sample}/raw_fastqc/fastqc{read_pair_tag}.zip")
#     log:    fetch_data("logs/{sample}/raw_fastqc{read_pair_tag}.log")
#     params: extra = "--noextract --format fastq --nogroup",
#             # lib_name = config["library_name"]
#     threads:  1
#     conda:  "../wrappers/raw_fastq_qc/env.yaml"
#     script: "../wrappers/raw_fastq_qc/script.py"