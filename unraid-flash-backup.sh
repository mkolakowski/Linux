#!/bin/bash

#Script created and maintained by Mkolakowski at https://github.com/mkolakowski/Linux
#No Warranty when using script or other components, Use at your own risk.

#--sn = Server Name
sn=$(hostname)
echo $sn

#--unraidversion =  Version number of server
unraidversion=$(grep "emhttpd: Unraid(tm) System Management Utility version " /var/log/syslog | cut -c87-)
echo $unraidversion

#-- starttime = Date+Time Script Started, eg: 20190430-145150
starttime=$(date +%Y%m%d-%H%M%S)

#-- Path to folder that will hold backups
backuppath=/mnt/user/Backup-Unraid/$(date +%Y-%m)
echo $backuppath

$-- Name of backup Zip, Combines three above variables
backupzip=$backuppath/flash-backup--$sn--$unraidversion--$starttime.zip
echo $backupzip

#-- Creating Local Directory for backup
mkdir $backuppath

#--Creating Zip
zip -r $backupzip /boot

#--Backing up Folder to rclone target
rclone copy -P /mnt/user/Backup-Unraid/ remote:/Unraid/$sn/Flash/$(date +%Y-%m)
