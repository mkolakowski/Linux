#!/bin/bash

# .SYNOPSIS 
#   Script created and maintained by Mkolakowski at https://github.com/mkolakowski/Linux
#   No Warranty when using script or other components, Use at your own risk.
#
# .VARIABLES
#   backuppath     = Path to folder that will hold backups
#   backupzip      = Name of backup Zip
#   sn             = Is the hostname of the Unraid Server
#   starttime      = Date+Time Script Started, eg: 20190430-145150
#   unraidversion  = Version number of server
#   remotepath     = Contains path of rclone remote storage path
#   logfolder      = Folder to contail Logs
#   logfilepath    = Full filepath for log file
#
# .EXAMPLES
#   Run script as is after validating data in above variables is correct
#
# .DEPENDANCIES
#   1. Rclone must be installed and configured to point to remote
#   2. Zip must be installed
#   3. Unzip must be installed

#--Variable Generation
  unraidHostname=$(hostname)
  unraidVersion=$(grep "emhttpd: Unraid(tm) System Management Utility version " /var/log/syslog | cut -c87-)
  startTime=$(date +%Y%m%d-%H%M%S)
  monthDate=$(date +%Y-%m)
  backuppath=/mnt/user/Backup-Unraid/$monthDate
  backupzip=$backuppath/flash-backup--$unraidHostname--$unraidVersion--$startTime.zip
  remotepath="remote:/Unraid/$unraidHostname/Flash/$monthDate"
  logfolder=/mnt/user/Logs/FlashBackup
  logfilepath=$logfolder/log-$startTime.txt

#--Creating Directorys needed
  mkdir $logfolder
  mkdir $backuppath

#--Creating and assigning permissions to log file
  touch $logfilepath
  chmod u+x $logfilepath

#--Block Variable testing, remove the # before each line to enable
  echo $sn &>>         $logfilepath
  echo $unraidversion  &>> $logfilepath
  echo $backuppath     &>> $logfilepath
  echo $backupzip      &>> $logfilepath
  echo --------------- &>> $logfilepath

#--Creating Zip -- Note: you can change the backup parth to /boot/config if wanted
  zip -r $backupzip /boot/config &>> $logfilepath

#--Backing up Folder to rclone target
  rclone copy -P --fast-list --tpslimit 4 --drive-chunk-size 256M --ignore-existing  $backuppath $remotepath &>> $logfilepath

#--Logging finish time
  endTime=$(date +%Y%m%d-%H%M%S)
  echo --------------- &>> $logfilepath
  echo $endTime        &>> $logfilepath
  echo --------------- &>> $logfilepath
