
#System language
lang en_US
langsupport en_US

#System keyboard
keyboard us

#System mouse
mouse

#System timezone
timezone America/New_York

#Root password
rootpw --disabled

#Initial user (user with sudo capabilities) 
user lwobker --fullname "LJ Wobker" --password notsecure

#Reboot after installation
reboot

#Use text mode install
text

#Install OS instead of upgrade
install

#Installation media
#cdrom
#nfs --server=server.com --dir=/path/to/ubuntu/
#url --url http://server.com/path/to/ubuntu/
#url --url ftp://server.com/path/to/ubuntu/
#url --url http://us.archive.ubuntu.com/ubuntu/dists/bionic/main/installer-amd64/

#System bootloader configuration
bootloader --location=mbr

#Clear the Master Boot Record
zerombr yes

#Partition clearing information
clearpart --all --initlabel

#Basic disk partition
part / --fstype ext4 --size 1 --grow --asprimary
part swap --size 2048
part /boot --fstype ext4 --size 256 --asprimary

#Advanced partition
# see docs if you care!

#System authorization infomation
auth  --useshadow  --enablemd5

#Network information
network --bootproto=dhcp

#Firewall configuration
#firewall --disabled --trust=eth0 --ssh 

#Do not configure the X Window System
skipx

%packages
openssh-server
wget
curl
htop
kexec-tools

%pre
sleep 1
%end

#in postinstall fixup the grub files so the console port is in the right place: ttyS0 on my KVM setup
%post --nochroot
(
    sed -i "s;quiet;quiet console=ttyS0;" /target/etc/default/grub
    sed -i "s;quiet;quiet console=ttyS0;g" /target/boot/grub/grub.cfg
) 1> /target/root/post_install.log 2>&1

# do a web get so I can ID the local IP address in the logs...
wget http://192.168.15.150/MEBENEW

%end
