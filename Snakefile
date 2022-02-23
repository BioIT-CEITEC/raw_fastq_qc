from snakemake.utils import min_version
#from snakemake.workflow import gitlab
from snakemake.sourcecache import gitlab



min_version("6.0")

module bioroots_utilities:
    snakefile:
            gitlab("bioroots/bioroots_utilities", path="bioroots_utilities.smk",branch="main")

use rule * from bioroots_utilities as other_*

##### Config processing #####

GLOBAL_REF_PATH = bioroots_utilities.global_ref_path()
sample_tab = bioroots_utilities.load_sample(config)
read_pair_tags = bioroots_utilities.set_read_pair_tags(config)[0]


if read_pair_tags == [""]:
    read_pair_tags[0] = read_pair_tags[0].replace("","SE")
else:
    read_pair_tags[0] = read_pair_tags[0].replace("_","")
    read_pair_tags[1] = read_pair_tags[1].replace("_","")


if not 'check_adaptors' in config:
    config['check_adaptors'] = False
if not 'min_adapter_matches' in config:
    config['min_adapter_matches'] = 12


wildcard_constraints:
    sample = "|".join(sample_tab.sample_name),
    read_pair_tag = "R1|R2|SE"

#### Target rules #####

rule all:
    input: "qc_reports/raw_fastq_multiqc.html"


#### Modules #####

include: "rules/fastqc.smk"
include: "rules/check_adaptors.smk"