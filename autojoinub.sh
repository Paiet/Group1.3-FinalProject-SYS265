#!/bin/bash
# Written by David Serate, not us
# Auto-joins centos to a domain 
if (( $EUID != 0 )); then 
	echo "Run with sudo privileges"
	exit
fi
# Parsing options for getopts 
while getopts "u:d:g: " option; do
	val=$OPTARG
	case $option in
		u)
			domainadmin=$val
		;;
		d)
			domain=$val
		;;
		g)
			groupname=$val
		;;
	esac
done
# Install required packages
apt-get install -y realmd samba samba-common oddjob oddjob-mkhomedir sssd sssd-tools libnss-sss libpam-sss adcli packagekit
if [ ! $groupname ]; then
	groupname='Domain Admins'
fi 
if [ $domain ] && [ $domainadmin ]; then
	realm join --user=$domainadmin@${domain^^} $domain
	touch /etc/sudoers.d/windowsadmins
	echo '"'"%$groupname@${domain^^}"'"' "ALL=(ALL) ALL" > /etc/sudoers.d/windowsadmins
else
	echo "Make sure you specify the domain with -d and user with -u "
fi
