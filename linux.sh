#!/bin/bash
###################COLOURS ON THE ECHO PROMPTS################
purple=`tput setaf 5`
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
###########################UPDATING###########################
echo "${red}Your system is being updated before proceeding.."
apt update
apt upgrade -y
apt dist-upgrade -y
echo "${green}Finished updating, continuing.."
#############################################################
#complete rewrite of script in TUI, (whiptail is already installed on most systems)
echo "$redopening whiptail tui.. if you get an error you might need to install whiptail"

##--checking if ran as root--##
#############################################################################################################################################
if [ "$USER" != "root" ]; then
      whiptail --title "warning" --msgbox "Permission Denied, script needs to run as root. Re-run this command but with sudo at the start" 8 78
      exit
else
      whiptail --title "unattended-upgrades" --msgbox "Welcome to unattended-upgrades, press [enter] to continue" 8 78
fi
#############################################################################################################################################

##--menu-- --choosing options--##
#####################################################################################################################################################################################################################################
#tried the checklist approach and haven't found any working solution on bash, i need to assign a variable to each list item but i can only assign one to output of the whole command which isn't what i want.
#using several yes or no prompts for now
whiptail --title "message" --msgbox "You will now be prompted on which functions to enable. Only ones that are optional will require confirmation, press [enter] to recieve a full list on what this script will do." 8 78

echo "${red}

An overview of functions the script currently supports.
Press [enter] to choose which functions you'd like to enable (in the next window), the script will then automate them.

Any tasks that need interaction will run at the end
${green}
----------------------------------------------
Network Security
----------------------------------------------
1 = fail2ban - Application Intrusion Detection And Prevention
2 = PSAD - iptables Intrusion Detection And Prevention (prevents ddos and port scan attacks)
3 = change ssh port - optional
4 = ssh key authentication - optional
5 = configure dns over tls
----------------------------------------------
Misc Security
----------------------------------------------
6 = restrict cron editing to root
7 = daily updates
8 = list open ports
9 = lynis, system audit tool
----------------------------------------------
Software - all optional
----------------------------------------------
10 = install screenfetch
11 = install docker
12 = install portainer
13 = setup a wireguard vpn server
----------------------------------------------"
###########################################################################################################################################################################################################################################################
if (whiptail --title "install lynis?" --yesno "Would you like to install lynis? A tool which audits your system when run?" 8 78); then
  lynis_userchoice="yes"
else
  lynis_userchoice="no"
fi
###########################################################################################################################################################################################################################################################
if (whiptail --title "change ssh port?" --yesno "Would you like to change the ssh port? May reduce spam in logs against automated or inexperienced attacks, defence in depth - NOTE that functions which require interaction will run at the end" 8 78); then
  ssh_port_userchoice="yes"
else
  ssh_port_userchoice="no"
fi
###########################################################################################################################################################################################################################################################
if (whiptail --title "setup wireguard?" --yesno "would you like to setup a wireguard vpn server? It is highly advised to vpn into your server as opposed to port forwarding to the internet." 8 78); then
  wireguard_choice="yes"
else
  wireguard_choice="no"
###########################################################################################################################################################################################################################################################
if (whiptail --title "install screenfetch?" --yesno "Do you want to install screenfetch and add to bashrc? - A lightweight but identical alternative to neofetch" 8 78); then
  screenfetch_userchoice="yes"
else
  screenfetch_userchoice="no"
fi
###########################################################################################################################################################################################################################################################
if (whiptail --title "install docker?" --yesno "Would you like to install docker?" 8 78); then
  docker_userchoice="yes"
else
  docker_userchoice="no"
fi
###########################################################################################################################################################################################################################################################
##--running functions--##
echo "${purple}setting daily system updates..."
job="@daily apt update; apt dist-upgrade -y"
touch job
echo $job >> job
crontab job
rm job
echo "${green}System updates will now occur daily"
###########################################################################################################################################################################################################################################################
if [ $screenfetch_userchoice == "yes" ]; then
  echo "${purple}installing screenfetch"
  #faster/less bloated alternative to neofetch
  apt install screenfetch -y
  echo "${green}Installed screenfetch"
  echo "screenfetch" >> ~/.bashrc
  echo "${green}added to terminal startup"
fi
###########################################################################################################################################################################################################################################################
if [ $docker_userchoice == "yes" ]; then
  echo "${purple}installing docker..."
  #installing docker
  curl -sSL https://get.docker.com | sh
  echo "${green}Installed docker"
fi
###########################################################################################################################################################################################################################################################
if [ $portainer_userchoice == "yes" ]; then
  echo "${purple}installing portainer..."
  #installing portainer, a gui for docker.

  #creating its docker volume
  docker volume create portainer_data

  #running + installing it
  docker run -d -p 8000:8000 -p 9443:9443 --name portainer \
      --restart=always \
      -v /var/run/docker.sock:/var/run/docker.sock \
      -v portainer_data:/data \
      portainer/portainer-ce:latest

  echo "${green} Installed portainer, You may access it via https://YOURIP:9443"
fi
###########################################################################################################################################################################################################################################################
echo "${purple}installing fail2ban..."
### fail2ban - Application Intrusion Detection & Prevention. Achieves this by scanning application logs such as ssh or apache.
apt install fail2ban -y
#if case the user wants to edit fail2ban's config file
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sudo cp /etc/fail2ban/fail2ban.conf /etc/fail2ban/fail2ban.local
/etc/init.d/fail2ban restart
echo "${green}Installed fail2ban"
###########################################################################################################################################################################################################################################################
#Scans iptables and ip6tables logs to detect and prevent DDOS and Port Scan attcks. Fine to install with fail2ban as they work on different areas.
echo "${purple}installing PSAD..."
apt install psad -y
echo "${green}installed psad, ddos & port scan, detection and prevention"
###########################################################################################################################################################################################################################################################
if [ $ssh_port_userchoice == "yes" ]; then
  ssh_port=$(whiptail --title "change ssh port" --inputbox "Enter what number you'd like to change your ssh port to, note that it must be above 1024 and below 65535" 8 78 3>&1 1>&2 2>&3)
  echo "${purple}changing ssh port..."
  port="Port "
  concatinate="${port} ${ssh_port}"
  echo $concatinate >> /etc/shs/sshd_config
  echo "${green}Finished changing the ssh port"
fi
###########################################################################################################################################################################################################################################################
echo "${purple}restricting, editing cron file to root user..."
touch /etc/cron.deny
user_cron=$(whiptail --title "cron root only" --inputbox "Enter your username below, do not type root. Also make sure to re-run this script if you have more than one user" 8 78 3>&1 1>&2 2>&3)
echo $user_cron >> /etc/cron.deny
echo "${green}Done, editing crontab (task scheduling) should now be restricted to root"
###########################################################################################################################################################################################################################################################
if [ $wireguard_choice == "yes" ]; then
  echo "${purple}selfhosting a wireguard vpn server.."
  echo "${purple}the installer isn't automatic, so you'll need to go through its TUI installer "

  curl -L https://install.pivpn.io | bash

  echo "${purple}creating wireguard config files..."
  echo "${green}please enter a name for the client's config file:"
  pivpn add
  echo "${green}finished selfhosting your vpn, make sure to port forward 51820 to the internet on your router settings in order to actually access the vpn from outside"
  echo "${red}** make sure you download your config files from /home/[username/configs/[name_you_chose].conf], you may then import this into the wireguard app to access your vpn. You can download the files via an SFTP client"
  echo "${green}it is also recommended to have 1 config per device, so feel free to type: sudo pivpn add if you wish to add more clients."
fi
###########################################################################################################################################################################################################################################################
#changing this via systemd currently causes issues, disabled until fixed, might have to resort to installing a dns client
# echo "${purple}configuring dns over tls"
# echo "${red}bare in mind this requires SystemD, if you're using another init system type: ${purple}N${red} below. Else type${purple} Y"
# echo "${red}are you using systemD?"
# read has_systemd
# if [ $has_systemd == "yes" ]; then
#   echo "DNSOverTLS=yes" >> /etc/systemd/resolved.conf
#   #allow downgrade disables it if the upstream resolver doesnt support it, and enables it otherwise
#   echo "DNSSEC=allow-downgrade" >> /ect/systemd/resolved.conf
#   dns_choice=$(whiptail --title "choose dns server" --inputbox "Enter a dns over tls server, or 1 to auto fill quad9's address." 8 78 3>&1 1>&2 2>&3)
#   if [ $dns_choice == "1" ]; then
#     dns_user_choice="DNS=tls://dns11.quad9.net"
#   else
#     dns_user_choice= "DNS={$dns_choice}"
#   echo $dns_user_choice >> /ect/systemd/resolved.conf
# sudo systemctl restart NetworkManager
# sudo systemctl restart systemd-resolved
# echo "${green} Enabled dnssec, dns over tls, and changed dns server. Try resolvectl query a-domain-here to test if it works. To test if dnssec is properly working you can do: resolvectl query sigfail.verteiltesysteme.net , if it fails to a dnssec issue thats good. The website has a bad dnssec signature. If it works, then dnssec is not working."
# fi
###########################################################################################################################################################################################################################################################
if [ $lynis_userchoice == "yes" ]; then
  echo "${purple}installing lynis, a system auditing tool...."
  sudo apt install apt-transport-https ca-certificates host -y
  sudo wget -O - https://packages.cisofy.com/keys/cisofy-software-public.key | sudo apt-key add -
  sudo echo "deb https://packages.cisofy.com/community/lynis/deb/ stable main" | sudo tee /etc/apt/sources.list.d/cisofy-lynis.list
  sudo apt install lynis host
  echo "${green}installed lynis.."
  if (whiptail --title "run lynis now?" --yesno "Installed lynis. Would you like to start a system audit now? Not really necessary on a fresh install" 8 78); then
    sudo lynis update info
    sudo lynis audit system
  fi
  echo "${green}You can run the following command: ${red}lynis audit system,${green} whenever wanting to do a system audit"
###########################################################################################################################################################################################################################################################
echo "${purple}Finished running the script, open ports are listed below so that you can close any unneeded ones. Alternatively, block everything and whitelist those needed."
ss -lntup
echo "${red}when you are ready type y to reboot"
read reboot_server
if [ $reboot_server == "y" ]; then
  shutdown -r now
fi
###########################################################################################################################################################################################################################################################
