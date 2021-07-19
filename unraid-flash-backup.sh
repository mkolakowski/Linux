#!/bin/bash

#--sn = Server Name
sn=$(hostname)
echo $sn

#--unraidver =  Version number of server
unraidver=$(grep "emhttpd: Unraid(tm) System Management Utility version " /var/log/syslog | cut -c87-)
echo $unraidver

#-- starttime = Date+Time Script Started, eg: 20190430-145150
starttime=$(date +%Y%m%d-%H%M%S)

#-- Path to folder that will hold backups
backuppath=/mnt/user/Backup-Unraid/$(date +%Y-%m)
echo $backuppath

$-- Name of backup Zip, Combines three above variables
backupzip=$backuppath/flash-backup--$sn--$unraidver--$starttime.zip
echo $backupzip

#-- Creating Local Directory for backup
mkdir $backuppath

#--Creating Zip
zip -r $backupzip /boot

#--Backing up Folder to rclone target
rclone copy -P /mnt/user/Backup-Unraid/ remote:/Unraid/$sn/Flash/$(date +%Y-%m)
