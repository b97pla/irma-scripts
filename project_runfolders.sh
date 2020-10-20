#! /bin/bash

##
# This script searches for all csv-files at most two folders down under the path specified by the PTH variable below and
# greps for the presence of the string passed to this script. If found, the name of the containing folder is echoed.
# This is primarily useful for containing all runfolders with samplesheets containing a specific project or sample identifier
##

PROJECT="$1"

#PTH="/proj/a2015179/nobackup/NGI/analysis_ready/DATA/$PROJECT"
#find "$PTH" -type d -name 1*XX -exec basename {} \; |sort -u

PTH="/proj/ngi2016001/incoming"
find -L "$PTH" -maxdepth 2 -name "*.csv" -type f |while read f
do
  if [[ ! -z "`grep $PROJECT $f`" ]]
  then
    d=`dirname $f`
    echo `basename $d`
  fi
done |sort -u
