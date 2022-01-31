#!/bin/bash

#Small script made as a starting point on automating a few stuff and hardening certain aspects of my servers.
#By t3dium

###################COLOURS ON THE ECHO PROMPTS#############################
#installing notice
purple=`tput setaf 5`
#important notice
red=`tput setaf 1`
#finished
green=`tput setaf 2`
#normal
reset=`tput sgr0`
###########################################################################

open_ports(){
  if [ $list_ports_userchoice == "yes" ]; then

    echo "${purple} installing netstat to list open ports"
    #this requires the netstat dependency, might change this to a coreutil later.
    apt install netstat
    echo "${green} running netstat - it's best to limit the number of open ports"
    netstat -tulpn
    echo "${red} finished running the script, your server will now restart..."
    echo "${red} restarting..."
    shutdown -r now

  else
    echo "${red} finished running the script, your server will now restart... ${reset}"
    shutdown -r now
  fi
}

###########################################################################
ssh_key(){
    #This is purposely commented out as I haven't tested it yet.
#
#     #might add an unattended setup option soon, but for now the user will have to interact to type their pass etc
#     ssh-keygen
#     #deleting the authorized keys file (as it may already exist and have content in it), and then regenerating it
#     rm ~/.ssh/authorized_keys
#     touch ~/.ssh/authorized_keys
#     #getting public key contents and setting server to accept it
#     cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
#     #logging in via ssh keys
#     echo "Finished.
# **IMPORTANT before continuing make sure to download your ssh private key, so that you can login over ssh.
# You may download your ssh keys via an sftp client such as filezilla, or put it onto a usb.
# Now when trying to ssh you may do so in the following format:
#
# ssh username@ip -p /private/key/path
#
# When you have finished press enter and the script will continue, before disabling normal password authentication (as you're using ssh keys), it's important that you've downloaded the key
# "
#
#
#     #the user needs to disable password authentication, may automate this later
#     echo "Generated ssh keys and setup system to accept them:
# the script will now run nano ~/.ssh/authorized keys.
# You will need to set the following line: password_authentication to no, as it's currently allowing password authentication making this step useless."
#
#     nano ~/.ssh/authorized_keys
#
#     #restarting ssh service to apply changes
#     sudo systemctl restart ssh
    echo "not finished yet"
    open_ports
}
###########################################################################
wireguard(){
  #might add an unattended install option soon
  if [ $wireguard_choice == "yes" ]; then
    echo "${purple} selfhosting a wireguard vpn server.."
    echo "${purple} the installer isn't automatic, so you'll need to go through its TUI installer "

    curl -L https://install.pivpn.io | bash

    echo "${green} finished selfhosting your vpn, make sure to port forward 51820 to the internet on your router settings in order to actually access the vpn from outside"

    open_ports

  else
    open_ports
  fi
}
###########################################################################
ssh_fail2ban(){
  echo "${purple} installing fail2ban..."
  ### Securing SSH - fail2ban###
  apt install fail2ban
  #if case the user wants to edit fail2ban's config file
  cp /etc/fail2ban/jail.local /etc/fail2ban/jail.conf
  sudo cp /etc/fail2ban/fail2ban.conf /etc/fail2ban/fail2ban.local
  /etc/init.d/fail2ban restart
  echo "${green} Installed fail2ban"
  wireguard
}
###########################################################################
ssh_port_change(){
  ### Securing SSH - changing port###
  echo "${purple} changing ssh port..."
  echo "${reset} Enter what number you'd like to change your ssh port to, note that it must be above 1024 and below 65535"
  read ssh_port
  #to append values into the following format: Port number
  port="Port "
  concatinate="${port} ${ssh_port}"
  echo $concatinate >> /etc/shs/sshd_config
  echo "${green} Finished changing the ssh port"

  fail2ban
}
###########################################################################
portainer(){

#only running if the user wants this option
  if [ $portainer_userchoice == "yes" ]; then
    echo "${purple} installing portainer..."
    #installing portainer, a gui for docker.

    #creating its docker volume
    docker volume create portainer_data

    #running + installing it
    docker run -d -p 8000:8000 -p 9443:9443 --name portainer \
        --restart=always \
        -v /var/run/docker.sock:/var/run/docker.sock d
        -v portainer_data:/data \
        portainer/portainer-ce:latest

    echo "${green} Installed portainer, You may access it via https://YOURIP:9443"
    ssh_port_change
  else
    ssh_port_change
  fi
}
###########################################################################
docker(){
  if [ $docker_userchoice == "yes" ]; then
    echo "${purple} installing docker..."
    #installing docker
    curl -sSL https://get.docker.com | sh
    echo "${green} Installed docker"
    portainer
  else
    portainer
  fi
}
###########################################################################
ssh_screenfetch(){
  if [ $screenfetch_userchoice == "yes" ]; then
    echo "${purple} installing screenfetch"
    #faster/less bloated alternative to neofetch
    apt install screenfetch
    echo "${green} Installed screenfetch"
    echo "screenfetch" >> ~/.bashrc
    echo "${green} added to terminal startup"
    docker
  else
    docker
  fi
}
###########################################################################
daily_updates(){
  echo "${purple} setting daily updates..."
  job="@daily apt update; apt dist-upgrade -y"
  touch job
  echo $job >> job
  crontab job
  rm job
  echo "${green} Updates will now occur daily"
  ssh_screenfetch
}
###########################################################################
grub_root_only(){
  echo "${purple} setting grub to root only..."
  echo "${red} coming soon"

  daily_updates
}
###########################################################################
cron_root_only(){
  echo "${purple} setting cron to root only..."
  #restricting cron to root only
  touch /etc/cron.deny
  echo "${red} Please enter your username below, do not type root.
        Also, make sure to re-run this script, if you have more than one user."
  read user1
  echo $user >> /etc/cron.deny
  echo "${green} Done, editing crontab (task scheduling) should now be restricted to root"

  grub_root_only
}
###########################################################################
#UPDATE SYSTEM BEFORE RUNNING SCRIPT#
update_system(){
  echo "${red} Your system is being updated before proceeding.."
  apt update
  apt upgrade -y
  apt dist-upgrade -y
  echo "${green} Finished updating, continuing.."
  cron_root_only
}

###########################################################################
check_root(){
  if [ "$USER" != "root" ]; then
        echo "${red} Permission Denied"
        echo "${red} Can only be run as root, make sure to run the script with sudo at the start of your command. For e.g, sudo bash linux.sh"
        exit
  else
        echo "${reset} Welcome"
  fi
  update_system
}
###########################################################################

echo "${reset} Welcome to Linux.sh by t3dium

----------------------------------------------
General Security
----------------------------------------------
1 = Restrict cron editing (task scheduling) to root **important
2 = Restrict grub editing to root **important
----------------------------------------------
Securing SSH
----------------------------------------------
2 = fail2ban
3 = change ssh port - optional
4 = ssh key authentication - optional
----------------------------------------------
Misc Security
----------------------------------------------
5 = daily updates
6 = list open ports - optional
----------------------------------------------
Optional Software
----------------------------------------------
7 = install screenfetch
8 = install docker
9 = install portainer
10 = setup a wireguard vpn server
----------------------------------------------
Any tasks that need interaction will run at the end

The script will now prompt you if you would like to proceed with the optional tasks,
so that later on you dont have to be prescent, and can just let the script run."

echo "would you like to install screenfetch? Y or N"
read screenfetch_userchoice

echo "would you like to install docker? Y or N"
read docker_userchoice

echo "would you like to install screenfetch? Y or N"
read portainer_userchoice

echo "would you like to have ssh key based authentication? Y or N"
read ssh_key_userchoice

echo "would you like to change the ssh port? Y or N"
read ssh_port_userchoice

echo "would you like to list open ports at the end? Y or N"
read list_ports_userchoice

echo "would you like to setup a wireguard vpn server? It is highly advised to vpn into your server as opposed to port forwarding to the internet."
read vpn_choice

check_root
