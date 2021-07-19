#!/bin/bash
echo "This is the automated restart cluster script, you will need to run this on the other nodes."

echo "Start: Checking that multicast is set properly"
eval 'echo 0 >/sys/class/net/vmbr0/bridge/multicast_snooping'
echo "Done"


echo "Start: Running the cluster restart script"
eval 'service pve-cluster restart'
echo "Done"


echo "Start: Running the pvedaemon restart script"
eval 'service pvedaemon restart'
echo "Done"


echo "Start: Running the pve-manager restart script this typically takes longer to run "
eval 'service pve-manager restart'
echo "Done"


echo "this looks like it ran properly, run this on the other nodes, you should regain quorum"