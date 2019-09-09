#! /bin/bash -l

###
# This is a simple wrapper around the deliver.py script, which should facilitate the delivery for the SNP platform
###

# Expects project id, email address and "sensitive" or "not-sensitive" as arguments. Optionally, specify a ";"-delimited list of members email addresses
PROJECT=$1
EMAIL=$2
SENSITIVE="--$3"
MEMBERS="$4"
PROJPATH=/proj/ngi2016001/incoming/GENOTYPING/$PROJECT

# display usage instructions when invoked without arguments
if [[ -z "$PROJECT" ]]
then
  echo ""
  echo "Deliver SNP genotyping data to SNIC users via GRUS"
  echo ""
  echo "    usage: ${0} <PROJECT ID> <PI EMAIL> {sensitive|not-sensitive} ['member_1@email.se;member_2@email.se']"
  echo ""
  exit 1
fi

# Add members
MEMBER_ARG=""
if [[ ! -z "$MEMBERS" ]]
then
  MEMBER_ARG="--member_email"
  for a in $(echo "$MEMBERS" |sed -re 's/;/ /g')
  do
    MEMBER_ARG="$MEMBER_ARG $a"
  done
fi

# File containing the SUPR credentails
SUPRCREDS=/proj/ngi2016001/incoming/GENOTYPING/supr_creds.txt
URL=$(cut -f 1 "$SUPRCREDS")
USR=$(cut -f 2 "$SUPRCREDS")
PASS=$(cut -f 3 "$SUPRCREDS")

# Command to launch the delivery script
CMD=$(echo /lupus/ngi/production/latest/sw/anaconda/envs/ugc_delivery_script/bin/python \
/lupus/ngi/production/latest/sw/ugc_delivery_src/deliver.py \
--supr_url $URL \
--supr_api_user $USR \
--supr_api_key $PASS \
--staging_area /proj/ngi2016001/incoming/GENOTYPING/staging \
--path $PROJPATH \
--project $PROJECT \
--email $EMAIL \
$SENSITIVE $MEMBER_ARG)

# Calculate MD5 sums of all delivered files
TSTAMP=$(date +%s)
MD5FILE=${PROJPATH}.${TSTAMP}.md5
find $PROJECT -type f -exec md5sum {} \; > $MD5FILE
mv $MD5FILE $PROJPATH/

# Log the delivery
LOGFILE=${0}.log
MSG="$TSTAMP  "$(date -d @$TSTAMP --utc +"%Y-%m-%dT%H:%M:%SZ")"  $(hostname)  ${USER}  ${PROJPATH}/$(basename $MD5FILE)  "$(echo $CMD |sed -re "s/$PASS/**************/")
echo "$MSG" >> $LOGFILE

# Execute the command
$CMD
