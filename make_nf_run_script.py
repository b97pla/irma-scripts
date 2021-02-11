import os
import argparse

parser = argparse.ArgumentParser(description='Generate run script for nextflow pipelines')
parser.add_argument('--project', required=True, help='Project name')
parser.add_argument('--genome', required=True, help='Reference genome, e.g. GRCm38')
parser.add_argument('--pipeline', required=True, help='Reference genome, e.g. methylseq')

args = parser.parse_args()
project = args.project
genome = args.genome
pipeline = args.pipeline

analysis_path = "/proj/ngi2016001/nobackup/NGI/ANALYSIS/"
scripts_path = os.path.join(analysis_path, project, "scripts")
template_path = "/lupus/ngi/production/latest/sw/upps_standalone_scripts/run_script_templates"

# Create scripts folder (if not already created)
os.system("mkdir -p {}".format(scripts_path))

# Handle gencode for GRCh38
if (pipeline == 'rnaseq' and genome == 'GRCh38'):
  template_name = 'rnaseq_GRCh38_gencode'
else:
  template_name = pipeline

# Copy template to scripts folder
os.system("cp {}/{}_template {}/run_analysis.sh".format(template_path,template_name, scripts_path))

# Add project and genome to template
os.system("sed -i -e s/PROJECT/{}/g -e s/GENOME/{}/g {}/run_analysis.sh".format(project, genome, scripts_path))

print("{}/run_analysis.sh has been generated. Good luck with the analysis!".format(scripts_path))

