#! /bin/bash -l

####
##
## This script will accept a project name as first argument, a VCF file as second argument and an optional status as third argument (defaults to AVAILABLE).
## The genotyping status field in Charon will be set to the status for the samples listed in the VCF file.
##
####


module load bioinfo-tools bcftools

PROJECT=$1
VCFFILE=$2
STATUS=$3

if [[ -z "${PROJECT}" || -z "${VCFFILE}" ]]
then
  echo "A project and a VCF file must be specified"
  exit 1
fi

if [[ -z "${STATUS}" ]]
then
  STATUS="AVAILABLE"
fi

for SAMPLE in $(bcftools query -l "${VCFFILE}")
do
  echo curl \
  -H "X-Charon-API-token:${CHARON_API_TOKEN}" \
  -H "Content-Type: application/json" \
  -X PUT \
  -d "{\"genotype_status\":\"${STATUS}\"}" \
  ${CHARON_BASE_URL}/sample/${PROJECT}/${SAMPLE}
done

