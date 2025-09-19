# Raw FASTQ QC Workflow

This repository contains a Snakemake workflow for comprehensive quality control (QC) and adaptor analysis of raw FASTQ sequencing data. The workflow is modular, configurable, and designed for both single-end and paired-end reads.

## Features
- **Quality Control (QC):** Runs FastQC on all raw FASTQ files and generates per-sample QC reports.
- **Adaptor Checking:** Detects and summarizes adaptor sequences in reads using custom scripts and reference files.
- **MultiQC Integration:** Merges individual QC and adaptor results into a single, user-friendly MultiQC HTML report.
- **Conda Environments:** Each major step runs in its own reproducible conda environment for easy setup and reproducibility.
- **Configurable:** All parameters, sample information, and resource paths are set via a JSON config file.

## Workflow Overview
1. **Input:**
   - Raw FASTQ files (single or paired-end)
   - Configuration file (`config.json`) specifying samples, resources, and options
2. **QC Analysis:**
   - Runs FastQC for each sample/read pair
   - Outputs HTML QC reports per sample
3. **Adaptor Analysis:**
   - Checks for adaptors in reads using reference sequences
   - Summarizes results in TSV and FASTA formats
   - Merges adaptor findings for MultiQC
4. **Report Generation:**
   - Combines all QC and adaptor results into a final MultiQC HTML report

## Directory Structure
- `Snakefile`: Main workflow definition and configuration loading
- `workflow.config.json`: Example configuration file
- `rules/`: Snakemake rule modules
  - `fastqc.smk`: FastQC and MultiQC rules
  - `check_adaptors.smk`: Adaptor checking and merging rules
- `wrappers/`: Scripts and conda environments for each step
  - `raw_fastq_qc/`, `check_adaptors/`, `merge_adaptors/`, `merge_fastq_qc/`

## Usage
1. **Configure your samples and paths in `config.json`.**
2. **Run the workflow:**
   ```bash
   snakemake --use-conda
   ```
3. **Output:**
   - Per-sample QC reports: `qc_reports/{sample}/raw_fastqc/{read_pair_tag}_fastqc.html`
   - Adaptor summary: `qc_reports/raw_fastq_minion_adaptors_mqc.tsv`
   - Final MultiQC report: `qc_reports/raw_fastq_multiqc.html`

## Requirements
- [Snakemake](https://snakemake.readthedocs.io/)
- [Conda](https://docs.conda.io/)
- Python 3.6+

## Customization
- Modify `config.json` to set sample names, paired/single-end mode, resource paths, and analysis options.
- Adapt wrapper scripts or conda environment files for custom tool versions or additional steps.

## Contact
For questions or contributions, please contact the BioIT-CEITEC team.
