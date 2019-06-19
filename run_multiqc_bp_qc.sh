#!/bin/bash -l

#
# A simple wrapper for the multiqc command in INS-22349
# Usage: bash /proj/ngi2016001/private/scripts/run_multiqc_bp_qc.sh /proj/ngi2016001/nobackup/NGI/ANALYSIS/<project>
#

PROJECT_PATH=$1

sbatch -A ngi2016001 -n 8 -t 05:00:00 --wrap "multiqc --template default --config /proj/ngi2016001/private/conf/multiqc_config.yaml --title $(basename $PROJECT_PATH) --filename $(basename $PROJECT_PATH)_$(date +%y%m%d) --outdir multiqc_ngi --data-format json --zip-data-dir --no-push $PROJECT_PATH"

