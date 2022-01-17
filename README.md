# EmbeddedLinux_DE10-Nano

#install packages
sudo sh setup.sh

#install quartus prime 18.1 and SoCEDSSetup-18.1 with standard installation paths
https://github.com/NicolasSchuck/EmbeddedLinux_De1-SOC/wiki/Setting-up-Quartus


# first run
~/intelFPGA/18.1/embedded/./embedded_command_shell.sh
sh generate.sh -c true -i true

# push application to board
# sh loadApps.sh -i <ip_address> -u <user>
# password: socfpga

sh loadApps.sh -i <ip_address> -u socfpga

# to execute software login with terminal as root and copy to software to root
#login: root
#pw: root

home/socfpga/software/<project>/Debug/./<executable>
