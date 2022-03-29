## ANNOTATION of VARIANTS in SAMPLES
#



rule filesender:
    input:  raw_fastq = "raw_fastq/",
            html = expand("qc_reports/{sample}/raw_fastqc/{read_pair_tag}_fastqc.html",sample = sample_tab.sample_name,read_pair_tag = read_pair_tags),
    output: gz = "qc_reports/raw_fastq_qc.tar.gz"
    log:    "logs/filesender.log"
    params: recipient = config["filesender"],
            subject = config["entity_name"],
            message = config["message"],
            credentials = GLOBAL_REF_PATH + "/reference_info/filesender_params.json",
            res_file = "qc_reports/"
    conda:  "../wrappers/filesender/env.yaml"
    #script: "../wrappers/filesender/script.py"
    shell:  """
            echo -e '##' >> {log} 2>&1
            echo -e '## RULE: filesender' >> {log} 2>&1
            echo -e '##' >> {log} 2>&1
            echo -e '## CONDA:' >> {log} 2>&1
            conda list >> {log} 2>&1
            tar -czvf {output.gz} {input.raw_fastq} {params.res_file} >> {log} 2>&1
            python3 filesender.py -r {params.recipient} -s Raw fastq files:{params.subject} -m {params.message} {output.gz} >> {log} 2>&1
            """

def merge_fastq_qc_input(wcs):
    inputs = {'html': expand("qc_reports/{sample}/raw_fastqc/{read_pair_tag}_fastqc.html",sample = sample_tab.sample_name,read_pair_tag = read_pair_tags)}
    if config['check_adaptors']:
        inputs['minion'] = "qc_reports/raw_fastq_minion_adaptors_mqc.tsv"
    return inputs

rule merge_fastq_qc:
    input:  unpack(merge_fastq_qc_input)
    # input:  html = expand("qc_reports/{sample}/raw_fastqc/{read_pair_tag}_fastqc.html",sample = sample_tab.sample_name,read_pair_tag = read_pair_tags)
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
            # lib_name = config["library_name"]
    threads:  1
    conda:  "../wrappers/raw_fastq_qc/env.yaml"
    script: "../wrappers/raw_fastq_qc/script.py"
