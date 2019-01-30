#!/bin/bash
#########################
# Backups to DESTINATION_FOLDER / Zips and performs basic rotation
##########################
SOURCE_FOLDER="/source/" # source folder
DESTINATION_FOLDER="/backup/" # mounted folder
BASENAME="basename $SOURCE_FOLDER"
ROTATE_COUNT=10
# datestamp has a formatted date
datestamp=`date +"%d-%m-%Y"`
#### Display command usage ########
usage()
{
  cat << EOF
  USAGE:
  backuprot [OPTIONS] /source_folder/ /destination_folder/
  Back up and entire folder, creates tgz and ,
  performs x count rotation of backups Must provide source and destination folders
  OPTIONS:
  -p Specify Rotation count - default is $ROTATE_COUNT
  EXAMPLES:
  backuprot -p 5 [/source_folder/] [/destination_folder/]
EOF
}
#### Getopts #####
while getopts "p:" opt; do
case "$opt" in
  p) ROTATE_COUNT=${OPTARG};;
  \?) echo "$OPTARG is an unknown option"
  usage
  exit 1
  ;;
  esac
done

 shift $((OPTIND-1))
 if [ -z "$1" ] || [ -z "$2" ]; then
 usage
 else
 # Backup and gzip the directory
 SOURCE_FOLDER=$1
 BASENAME=`basename "$SOURCE_FOLDER"`
 TGZFILE="$BASENAME-$datestamp.tgz"
 LATEST_FILE="$BASENAME-Latest.tgz"
 DESTINATION_FOLDER=$2
 echo "\nStarting Backup and Rotate "
 echo "\n-----------------------------"
 echo "\nSource Folder : $SOURCE_FOLDER"
 echo "\nTarget Folder : $DESTINATION_FOLDER"
 echo "\nBackup file : $TGZFILE "
 echo "\n-----------------------------"
 if [ ! -d "$SOURCE_FOLDER" ] || [ ! -d "$DESTINATION_FOLDER" ] ; then
 echo "SOURCE ($SOURCE_FOLDER) or DESTINATION ($DESTINATION_FOLDER) folder doesn't exist/ or is misspelled, check & re-try."
 exit 0;
 fi
 echo "\nCreating $SOURCE_FOLDER/$TGZFILE ... "
 tar zcvf $SOURCE_FOLDER/$TGZFILE $SOURCE_FOLDER
 echo "\nCopying $SOURCE_FOLDER/$TGZFILE to $LATEST_FILE ... "
 cp $SOURCE_FOLDER/$TGZFILE $SOURCE_FOLDER/$LATEST_FILE
 echo "\nMoving $TGZFILE -- to --> $DESTINATION_FOLDER "
 mv $SOURCE_FOLDER/$TGZFILE $DESTINATION_FOLDER
 echo "\nMoving $LATEST_FILE -- to --> $DESTINATION_FOLDER "
 mv $SOURCE_FOLDER/$LATEST_FILE $DESTINATION_FOLDER
 # count the number of file(s) in the appropriate folder Rotate the logs, delete oldest files
 FILE_COUNT=`find $DESTINATION_FOLDER -maxdepth 1 -type f | wc -l`
 echo "\n Rotation count $ROTATE_COUNT for $DESTINATION_FOLDER "
 echo "\n $FILE_COUNT files found in $DESTINATION_FOLDER folder"
 echo "\n ls -d -1t $DESTINATION_FOLDER/*.* | tail-n +$(($ROTATE_COUNT+1))"
 echo "\n -----------------------------------"
 if [ $FILE_COUNT -gt $ROTATE_COUNT ]; then
 echo "Removing backups older than $ROTATE_COUNT in $DESTINATION_FOLDER"
 echo "Removing these old backup files..."
 ls -d -1t $PWD/$DESTINATION_FOLDER/*.* | tail -n +$(($ROTATE_COUNT+1))| xargs rm
 else
 echo "Only $FILE_COUNT file, NOT removing older backups in $DESTINATION_FOLDER "
 fi
 fi
 echo "----------------"
 echo "Backup_rot Complete. :"
 echo "to extract file >> tar -xzvf $TGZFILE "

