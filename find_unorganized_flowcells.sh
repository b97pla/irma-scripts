#! /bin/bash -l

### 
## This script will check if all available sequence data for a project has been properly organized
##

SEQDIR="/proj/ngi2016001/incoming"
DATADIR="/proj/ngi2016001/nobackup/NGI/DATA"
PROJECT="$1"
SAMPLE="$2"

## Iterate over all flowcells containing sequence data for the project
for ssheet in $(find -L "${SEQDIR}" -maxdepth 2 -type f -name "*.csv")
do
  flowcell="$(dirname ${ssheet})"
  flowcell="$(basename ${flowcell})"
  for ssheet_row in $(grep ${PROJECT} ${ssheet})
  do
    if [[ -z "$ssheet_row" ]]
    then
      continue
    fi
    sample="$(echo $ssheet_row |cut -f 3 -d ',')"
    libprep="$(echo $ssheet_row |sed -re 's/.*LIBRARY_NAME\:([^,\;]+).*/\1/')"
    organized_path="${DATADIR}/${PROJECT}/${sample}/${libprep%$'\r'}/${flowcell}"
    if [[ ! -e "${organized_path}" ]]
    then
      echo "Expected organized path ${organized_path} is missing ==> flowcell ${flowcell} may not have been properly organized for project ${PROJECT} and sample ${sample}"
    fi

  done
done
