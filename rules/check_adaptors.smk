## Check adaptors in sample reads

rule merge_adaptors:
    input:  fastq=expand("qc_reports/{sample}/raw_fastq_minion/{sample}_{pair}.minion.compare",sample=sample_tab.sample_name,pair=read_pair_tags),
    output: tab="qc_reports/raw_fastq_minion_adaptors_mqc.tsv",
    log:    "logs/merge_adaptors.log",
    params: pattern=str("|" * int(config["min_adapter_matches"])),
            info="qc_reports/raw_fastq_minion_adaptors.txt",
            sequences="qc_reports/raw_fastq_minion_adaptors.fa",
    conda:  "../wrappers/merge_adaptors/env.yaml",
    shell:  """
        echo -e '##' >> {log} 2>&1
        echo -e '## RULE: merge_adaptors' >> {log} 2>&1
        echo -e '##' >> {log} 2>&1
        echo -e '## CONDA:' >> {log} 2>&1
        conda list >> {log} 2>&1
        rm -f {params.info} {params.sequences} {output.tab} >> {log} 2>&1
        touch {params.info} {params.sequences} {output.tab} >> {log} 2>&1
        PAT="{params.pattern}"
        echo -e "Looking for pattern: $PAT" >> {params.info} 2>&1
        for i in {input.fastq}
        do
        	echo -e "Processing: $i" | tee -a {params.info} >> {log} 2>&1
        	INFO=$(grep -B1 -A1 "$PAT" $i | sed "s/^ //g" || echo "No adapter!")
        	echo "$INFO" >> {params.info} 2>> {log}
        	echo "-----------" >> {params.info} 2>> {log}
        	SEQ=$(grep -A1 "$PAT" $i | sed 's/^ //g' | awk '{{print $1}}' | sed "/$PAT/d" || echo -n "")
        	if [ $(echo -n "$SEQ"|wc -l) -gt 0 ] || [ -n "$SEQ" ]; then
        	    echo -e ">$(basename $i .minion.compare)\\n$SEQ" >> {params.sequences} 2>> {log}
        	fi
        done
        if [ -s {params.sequences} ]; then
            echo -e 'Reshapping found adaptors into table for multiqc' >> {log} 2>&1
            echo -e '# id: "minion_adapters"' > {output.tab} 2>> {log}
            echo -e '# section_name: "Minion"' >> {output.tab} 2>> {log}
            echo -e '# format: "tsv"' >> {output.tab} 2>> {log}
            echo -e '# plot_type: "table"' >> {output.tab} 2>> {log}
            cat {params.sequences} | awk '{{if($0 ~ /^>/){{sample=substr($1, 2)}}; if($0 ~ /^[ACGTacgt]/){{print sample,$1}} }}' OFS='\\t' | Rscript -e 'tab=data.table::fread("cat /dev/stdin", sep="\\\\t", header=F);data.table::setnames(tab,"V1","sample");data.table::fwrite(data.table::dcast(tab, sample~V2, fill=0), "{output.tab}", append=T, sep="\\\\t", col.names=T, row.names=F, quote=F)' >> {log} 2>&1
        fi
    """


rule check_adaptors:
    input: fastq = "raw_fastq/{sample}_{read_pair_tag}.fastq.gz",
           fastqc = "qc_reports/{sample}/raw_fastqc/{read_pair_tag}_fastqc.html"
    output: comp="qc_reports/{sample}/raw_fastq_minion/{sample}_{read_pair_tag}.minion.compare",
    log: "logs/{sample}/check_adaptors_{read_pair_tag}.log",
    params: fasta="qc_reports/{sample}/raw_fastq_minion/{sample}_{read_pair_tag}.minion.fa",
        adaptors=GLOBAL_REF_PATH + "/general/adapters_merge.txt"
    conda: "../wrappers/check_adaptors/env.yaml"
    script: "../wrappers/check_adaptors/script.py"
