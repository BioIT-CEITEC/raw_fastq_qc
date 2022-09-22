## ANNOTATION of VARIANTS in SAMPLES
#
rule filesender:
    input:  raw_fastq = "raw_fastq/",
            html = expand("qc_reports/{sample}/raw_fastqc/{read_pair_tag}_fastqc.html",sample = sample_tab.sample_name,read_pair_tag = read_pair_tags),
    output: gz = "qc_reports/raw_fastq_qc.tar.gz"
    log:    "logs/filesender.log"
    params: recipient = config["recipient"],
            subject = config["entity_name"],
            message = config["message"],
            credentials = GLOBAL_REF_PATH + "/reference_info/filesender/filesender_params.json",
            res_file = "qc_reports/"
    conda:  "../wrappers/filesender/env.yaml"
    script: "../wrappers/filesender/script.py"

def merge_fastq_qc_input(wcs):
    inputs = {'html': expand("qc_reports/{sample}/raw_fastqc/{read_pair_tag}_fastqc.html",sample = sample_tab.sample_name,read_pair_tag = read_pair_tags)}
    if config['check_adaptors']:
        inputs['minion'] = "qc_reports/raw_fastq_minion_adaptors_mqc.tsv"
    if config['biobloom']:
        inputs['biobloom'] = expand("qc_reports/{sample}/biobloom/{sample}.biobloom_summary.tsv",sample = sample_tab.sample_name)
    if os.path.isfile("sequencing_run_info/Stats.json"):
        inputs['run_stats'] = "sequencing_run_info/Stats.json"
    return inputs

rule merge_fastq_qc:
    input:  unpack(merge_fastq_qc_input)
    output: html = "qc_reports/raw_fastq_multiqc.html"
    log:    "logs/merge_fastq_qc.log"
    conda:  "../wrappers/merge_fastq_qc/env.yaml"
    script: "../wrappers/merge_fastq_qc/script.py"

def raw_fastq_qc_input(wildcards):
    if wildcards.read_pair_tag == "SE":
        input_fastq_read_pair_tag = ""
    else:
        input_fastq_read_pair_tag = "_" + wildcards.read_pair_tag
    return f'raw_fastq/{wildcards.sample}{input_fastq_read_pair_tag}.fastq.gz'

rule raw_fastq_qc:
    input:  raw_fastq = raw_fastq_qc_input
    output: html = "qc_reports/{sample}/raw_fastqc/{read_pair_tag}_fastqc.html"
    log:    "logs/{sample}/raw_fastqc_{read_pair_tag}.log"
    params: extra = "--noextract --format fastq --nogroup",
    threads:  1
    conda:  "../wrappers/raw_fastq_qc/env.yaml"
    script: "../wrappers/raw_fastq_qc/script.py"

def biobloom_input(wildcards):
    # if config["trim_adapters"] == True or config["trim_quality"] == True:
    #     preprocessed = "cleaned_fastq"
    # else:
    #     preprocessed = "raw_fastq"
    preprocessed = "raw_fastq"
    input = {}
    #input['flagstats'] = "qc_reports/{sample}/qc_samtools/{sample}.flagstat.tsv"
    if not config["is_paired"]:
        input['r1'] = os.path.join(preprocessed,"{sample}.fastq.gz")
    else:
        input['r1'] = os.path.join(preprocessed,"{sample}_R1.fastq.gz")
        input['r2'] = os.path.join(preprocessed,"{sample}_R2.fastq.gz")
    return  input

rule biobloom:
    input:  unpack(biobloom_input)
    output: table = "qc_reports/{sample}/biobloom/{sample}.biobloom_summary.tsv",
    log:    "logs/{sample}/biobloom.log",
    threads: 8
    resources: mem=30
    params: prefix = "qc_reports/{sample}/biobloom/{sample}.biobloom",
            #filters = "all",
            ref_list = config["biobloom_ref"],
            ref_dir = GLOBAL_REF_PATH,
            paired = paired,
            #max_mapped_reads_to_run = config["max_mapped_reads_to_run_biobloom"]
    conda: "../wrappers/biobloom/env.yaml"
    script: "../wrappers/biobloom/script.py"

