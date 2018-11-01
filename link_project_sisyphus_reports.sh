#! /bin/bash -l

## 
# This script links Sisyphus reports from the runfolder to the correct ANALYSIS/PROJECT 
# folder. The project id is passed as an argument to this script. The script depends on the project_runfolder.sh script
##

PROJECT="$1"
NO_DRYRUN="$2"

SCRIPTDIR=$(readlink -f $0)
SCRIPTDIR=$(dirname $SCRIPTDIR)

# path to the analysis folders
APATH=/proj/ngi2016001/nobackup/NGI/ANALYSIS

# path to the runfolders
RFPATH=/proj/ngi2016001/incoming

# iterate over the names of the runfolders containing the project
for d in $($SCRIPTDIR/project_runfolders.sh "$PROJECT")
do
  # get the canonical path to the runfolder
  RF=$(readlink -f "$RFPATH/$d")
  PDIR="$RF/Projects/$PROJECT/$d"

  # skip if the folder containing Sisyphus reports does not exist 
  if [[ ! -e "$PDIR" ]]
  then
    continue
  fi
  
  # create the folder to hold the links to the sisyphus reports, if it does not exist
  TDIR="$APATH/$PROJECT/qc_sisyphus/reports/$d"
  CMD="mkdir -p \"$TDIR\""
  if [[ "$NO_DRYRUN" -ne "RUN" ]]
  then
    echo "DRYRUN: $CMD"
  else
    eval "$CMD"
  fi

  # link each of the report files into the sisyphus report folder
  for f in $(find "$PDIR" -mindepth 1 -maxdepth 1 -not -name "Sample_*")
  do
    CMD="ln -s -t \"$TDIR\" \"$f\""
    if [[ "$NO_DRYRUN" -ne "RUN" ]]
    then
      echo "DRYRUN: $CMD"
    else
      eval "$CMD"
    fi
  done

done
