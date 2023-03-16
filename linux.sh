#!/bin/bash
###################COLOURS ON THE ECHO PROMPTS################
purple=$(tput setaf 5)
red=$(tput setaf 1)
green=$(tput setaf 2)
reset=$(tput sgr0)

###################WHIPTAIL (tui) colourscheme################
export NEWT_COLORS='root=,black
border=green,black
title=green,black
roottext=red,black
window=red,black
textbox=white,black
button=black,green
compactbutton=white,black
listbox=white,black
actlistbox=black,white
actsellistbox=black,green
checkbox=green,black
actcheckbox=black,green
'
###########################UPDATING###########################
echo "${red}Your system is being updated before proceeding.."
apt update
apt upgrade -y
apt dist-upgrade -y
echo "${red}installing git, if not already installed"
apt install git -y
echo "${green}finished tasks, continuing.."
#############################################################
echo "$red whiptail tui.. if you get an error you might need to install whiptail"

##--checking if ran as root--##
#############################################################################################################################################
if [ "$USER" != "root" ]; then
      whiptail --title "warning" --msgbox "Permission Denied, script needs to run as root. Re-run this command but with sudo at the start" 8 78
      exit
else
      whiptail --title "linux.sh" --msgbox "Welcome to linux.sh, press [enter] to continue" 8 78
fi
#############################################################################################################################################

##--menu-- --choosing options--##
#####################################################################################################################################################################################################################################
whiptail --title "message" --msgbox "You will now be prompted on which functions to enable. Only ones that are optional will require confirmation, press [enter] to receive a full list on what this script will do." 8 78

echo "${red}

An overview of functions the script currently supports.
Press [enter] to choose which functions you'd like to enable (in the next window), the script will then automate them.

Any tasks that need interaction will run at the end
[Warning: functions flagged as [experimental] may cause breakage]
${green}
----------------------------------------------
Network Security
----------------------------------------------
1 = fail2ban - Application Intrusion Detection And Prevention
2 = PSAD - iptables Intrusion Detection And Prevention (prevents ddos and port scan attacks)
3 = change ssh port
4 = ssh key authentication
5 = configure dns encryption
6 = list open ports at end
7 = enforce strong ciphers & MACs
----------------------------------------------
Misc Security
----------------------------------------------
8 = harden cron and sshd editing permissions
9 = daily updates
10 = automatic docker updates (via watchtower)
11 = lynis, system audit tool
12 = systemd service sandbox hardening - [optional] - [very experimental] - info: ${reset}https://github.com/t3dium/systemd-sandboxing${green}
13 = LKRG - prevent changes & exploits to the linux kernel - may affect performance slightly, especially wireguard
14 = MountPoint Hardening - hardening /boot, /boot/efi, and /var and hiding /proc - [optional]
15 = disable core dumps - contains sensitive info in its memory snapshots (used for troubleshooting)
16 = restricting /proc/kallsyms - info on how kernel memory is laid out which makes it easier to attack the kernel itself
17 = Disable various compilers: as byacc yacc bcc kgcc cc gcc c++ g++, ${purple}to re-enable just edit the permissions, for e.g chmod 755 /usr/bin/gcc${green}
18 = Prevent malicious bashrc & bash_profile editing ${purple} (if you want to edit it simply run:  chattr -i ~/.bashrc && chattr -i ~/.bash_profile)${green}
19 = Disable unecessary modules
20 = Disable unecessary network protocols
21 = Replace timesyncd with chrony, and configure it to use NTS
----------------------------------------------
Software - all optional again
----------------------------------------------
22 = install screenfetch
23 = install docker
24 = selfhost portainer or yacht (docker web-gui)
25 = setup a wireguard vpn server - pivpn - user friendly cli
26 = setup a wireguard vpn server - wg-easy - web gui
27 = selfhost bender - dashboard - homer fork which allows editing entries via its web gui - info: ${reset}https://github.com/jez500/bender${green}
28 = selfhost nginx proxy manager - webgui for nginx for reverse proxying services and configuring SSL
29 = generate some selfsigned certs (signed with a generated CA)
----------------------------------------------

Every point in the list above is optional and will only execute if saying yes on the options page which comes next.
"

echo "${red} Press ENTER to begin."
read random_wait_variable

###########################################################################################################################################################################################################################################################
if (whiptail --title "Harden bashrc" --yesno "Require sudo to edit bashrc and bash_profile? (highly recommended as its easy to execute malware as sudo, without knowing the password, by maliciously creating aliases)" 8 78); then
  harden_bash_userchoice="yes"
else
  harden_bash_userchoice="no"
fi
###########################################################################################################################################################################################################################################################
if (whiptail --title "Better ntp" --yesno "Replace timesyncd with chrony? (tends to have much more accurate time syncing) Also configures it to use some NTS (secure ntp) servers" 8 78); then
  chrony_userchoice="yes"
else
  chrony_userchoice="no"
fi
###########################################################################################################################################################################################################################################################
if (whiptail --title "Harden cron/ssh" --yesno "Harden cron and sshd editing permissions? (recommended) " 8 78); then
  harden_cron_sshd_userchoice="yes"
else
  harden_cron_sshd_userchoice="no"
fi
###########################################################################################################################################################################################################################################################
if (whiptail --title "Reduce attack surface?" --yesno "Would you like to disable unnecessary modules and network protocols to reduce attack surface (highly recommended) " 8 78); then
  disable_unnecessary_userchoice="yes"
else
  disable_unnecessary_userchoice="no"
fi
###########################################################################################################################################################################################################################################################
if (whiptail --title "Reduce port scanning attempts?" --yesno "Would you like to install psad to protect against port scans? (recommended)" 8 78); then
  psad_userchoice="yes"
else
  psad_userchoice="no"
fi
###########################################################################################################################################################################################################################################################
if (whiptail --title "Rate limit ssh?" --yesno "Would you like to install fail2ban to protect ssh? (highly recommended) " 8 78); then
  fail2ban_userchoice="yes"
else
  fail2ban_userchoice="no"
fi
###########################################################################################################################################################################################################################################################
if (whiptail --title "Harden ssh?" --yesno "Would you like to harden ssh? (enforcing strong ciphers & mac's) (recommended) " 8 78); then
  harden_ssh_userchoice="yes"
else
  harden_ssh_userchoice="no"
fi
###########################################################################################################################################################################################################################################################
if (whiptail --title "Auto Updates?" --yesno "Would you like to automate daily updates (highly recommended)? " 8 78); then
  automate_updates_userchoice="yes"
else
  automate_updates_userchoice="no"
fi
###########################################################################################################################################################################################################################################################
if (whiptail --title "Harden Mountpoints?" --yesno "Would you like to harden Mount Points? " 8 78); then
  mountpoints_userchoice="yes"
else
  mountpoints_userchoice="no"
fi
###########################################################################################################################################################################################################################################################
if (whiptail --title "Harden /proc/kallsyms?" --yesno "Would you like to harden /proc/kallsyms (recommended)? " 8 78); then
  harden_kallsyms_userchoice="yes"
else
  harden_kallsyms_userchoice="no"
fi
###########################################################################################################################################################################################################################################################
if (whiptail --title "Disable core dumps?" --yesno "Would you like to disable core dumps? (recommended)" 8 78); then
  disable_core_dumps_userchoice="yes"
else
  disable_core_dumps_userchoice="no"
fi
###########################################################################################################################################################################################################################################################
if (whiptail --title "get LKRG?" --yesno "Would you like to install LKRG? A linux kernel runtime guard" 8 78); then
  lkrg_userchoice="yes"
else
  lkrg_userchoice="no"
fi
###########################################################################################################################################################################################################################################################
if (whiptail --title "Disable various compilers?" --yesno "Disable various compilers? You can re-enable by just changing permissions for e.g chmod 775 /usr/bin/gcc " 8 78); then
  compilers_userchoice="yes"
else
  compilers_userchoice="no"
fi
###########################################################################################################################################################################################################################################################
if (whiptail --title "harden systemd?" --yesno "Would you like to use some pre-made hardened systemd service templates" 8 78); then
  systemd_userchoice="yes"
else
  systemd_userchoice="no"
fi
###########################################################################################################################################################################################################################################################
if (whiptail --title "install lynis?" --yesno "Would you like to install lynis? A tool which audits your system when run?" 8 78); then
  lynis_userchoice="yes"
else
  lynis_userchoice="no"
fi
###########################################################################################################################################################################################################################################################
if (whiptail --title "dns encryption?" --yesno "Would you like to enable dns encryption? via nextdns, quad9 or custom" 8 78); then
  dns_userchoice="yes"
else
  dns_userchoice="no"
fi

if [[ $dns_userchoice == "yes" ]]; then
  dnsoption_userchoice=$(whiptail --title "dns option" --inputbox "Enter 1 to use nextdns (requires account [free]), 2 for quad9, or 3 for a custom dns server " 8 78 3>&1 1>&2 2>&3)
fi
###########################################################################################################################################################################################################################################################
if (whiptail --title "change ssh port?" --yesno "Would you like to change the ssh port? May reduce spam in logs against automated or inexperienced attacks, defence in depth - NOTE that functions which require interaction will run at the end" 8 78); then
  ssh_port_userchoice="yes"
  ssh_port=$(whiptail --title "change ssh port" --inputbox "Enter what number you'd like to change your ssh port to, note that it must be above 1024 and below 65535" 8 78 3>&1 1>&2 2>&3)
else
  ssh_port_userchoice="no"
fi
###########################################################################################################################################################################################################################################################
#if (whiptail --title "setup ssh key's?" --yesno "Setup ssh keys? This is highly recommended as not only does it increase convenience but it also prevents brute forcing into ssh. However if not, fail2ban will already be installed which should help by ratelimiting." 8 78); then
#  sshkeys_userchoice="yes"
#else
#  sshkeys_userchoice="no"
#fi
###########################################################################################################################################################################################################################################################
if (whiptail --title "setup pivpn?" --yesno "would you like to setup a wireguard vpn server via pivpn? (cli) (web gui option in next menu) It is highly advised to vpn into your server as opposed to port forwarding to the internet." 8 78); then
  pivpn_choice="yes"
else
  pivpn_choice="no"
fi
###########################################################################################################################################################################################################################################################
if (whiptail --title "setup wgeasy?" --yesno "would you like to setup a wireguard vpn server via wg-easy? (webgui) It is highly advised to vpn into your server as opposed to port forwarding to the internet." 8 78); then
  wgeasy_userchoice="yes"
else
  wgeasy_userchoice="no"
fi
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
if (whiptail --title "automated docker updates?" --yesno "Automate docker updates via watchtower?" 8 78); then
  watchtower_userchoice="yes"
else
  watchtower_userchoice="no"
fi
###########################################################################################################################################################################################################################################################
if (whiptail --title "install portainer?" --yesno "Would you like to install portainer - a docker webgui?" 8 78); then
  portainer_userchoice="yes"
else
  portainer_userchoice="no"
fi
###########################################################################################################################################################################################################################################################
if (whiptail --title "install yacht?" --yesno "Would you like to install yacht - a docker webgui?" 8 78); then
  yacht_userchoice="yes"
else
  yacht_userchoice="no"
fi
###########################################################################################################################################################################################################################################################
if (whiptail --title "install nginx proxy manager?" --yesno "Would you like to install nginx proxy manager?" 8 78); then
  npm_userchoice="yes"
else
  npm_userchoice="no"
fi
###########################################################################################################################################################################################################################################################
if (whiptail --title "mkcert?" --yesno "Would you like to generate some CA signed, self signed certs??" 8 78); then
  mkcert_userchoice="yes"
else
  mkcert_userchoice="no"
fi
###########################################################################################################################################################################################################################################################
if (whiptail --title "install bender?" --yesno "Would you like to install yacht - a docker webgui?" 8 78); then
  bender_userchoice="yes"
else
  bender_userchoice="no"
fi
###########################################################################################################################################################################################################################################################
##--running functions--##
if [[ $automate_updates_userchoice == "yes" ]]; then
  echo "${purple}setting daily system updates..."
  job="@daily apt update; apt upgrade -y"
  touch job
  echo $job >> job
  crontab job
  rm job
  echo "${green}System updates will now occur daily"
fi
###########################################################################################################################################################################################################################################################
if [[ $compilers_userchoice == "yes" ]]; then
  echo "${purple}Disabling as byacc yacc bcc kgcc cc gcc c++ g++ compilers..."
  chmod 000 /usr/bin/as >/dev/null 2>&1
  chmod 000 /usr/bin/byacc >/dev/null 2>&1
  chmod 000 /usr/bin/yacc >/dev/null 2>&1
  chmod 000 /usr/bin/bcc >/dev/null 2>&1
  chmod 000 /usr/bin/kgcc >/dev/null 2>&1
  chmod 000 /usr/bin/cc >/dev/null 2>&1
  chmod 000 /usr/bin/gcc >/dev/null 2>&1
  chmod 000 /usr/bin/*c++ >/dev/null 2>&1
  chmod 000 /usr/bin/*g++ >/dev/null 2>&1
  echo "${green}Done, to re-enable just edit the permissions, for e.g chmod 755 /usr/bin/gcc"
fi
###########################################################################################################################################################################################################################################################
if [[ $lkrg_userchoice == "yes" ]]; then
  echo "${purple}adding kicksecure repository"
  wget https://www.kicksecure.com/derivative.asc
  cp derivative.asc /usr/share/keyrings/derivative.asc
  echo "deb [signed-by=/usr/share/keyrings/derivative.asc] https://deb.kicksecure.com bullseye main contrib non-free" | sudo tee /etc/apt/sources.list.d/derivative.list
  echo "${purple}installing LKRG"
  apt install lkrg-dkms linux-headers-amd64
  echo "${green}instaled LKRG"
fi
###########################################################################################################################################################################################################################################################
if [[ $screenfetch_userchoice == "yes" ]]; then
  echo "${purple}installing screenfetch"
  #faster/less bloated alternative to neofetch
  apt install screenfetch -y
  echo "${green}Installed screenfetch"
  echo "screenfetch" >> ~/.bashrc
  echo "${green}added to terminal startup"
fi
###########################################################################################################################################################################################################################################################
if [[ $npm_userchoice == "yes" ]]; then
  echo "${purple}installing nginx proxy manager"
  echo "${red} !! this requires port 80 to be open (which is a common port), so that when setting a dns rewrite for: for e.g, website.lan > server_ip_address, it'll point to nginx due to it being on port 80, which will then point to the correct ports with ssl optionally  !!"

  docker run -d \
      --name=nginx-proxy-manager \
      -p 81:8181 \
      -p 80:8080 \
      -p 443:4443 \
      -v /docker/appdata/nginx-proxy-manager:/config:rw \
      jlesage/nginx-proxy-manager

  echo "${green}installed nginx proxy manager"
  echo "${red}Browse to http://your-host-ip:81 to access the Nginx Proxy Manager web interface."
  echo "${purple}This is a good guide on making selfsigned SSL certs: https://github.com/dani-garcia/vaultwarden/wiki/Private-CA-and-self-signed-certs-that-work-with-Chrome"
fi
###########################################################################################################################################################################################################################################################
if [[ $bender_userchoice == "yes" ]]; then
  echo "${purple}installing bender"
  #dashboard - homer fork which allows editing entries via its web gui

  docker run -d \
  --name bender \
  -p 8080:8080 \
  -v </your/local/assets/>:/app/static \
  --restart=always \
  jez500/bender:latest

  echo "${green}Installed bender, ${red}you may access it from http://YOURIP:8080"
fi
###########################################################################################################################################################################################################################################################
if [[ $docker_userchoice == "yes" ]]; then
  echo "${purple}installing docker..."
  #installing docker
  curl -sSL https://get.docker.com | sh
  echo "${green}Installed docker"
fi
###########################################################################################################################################################################################################################################################
if [[ $watchtower_userchoice == "yes" ]]; then
  echo "${purple}installing watchtower..."
  #installing watchtower
  docker run -d --name watchtower \
    -v /var/run/docker.sock:/var/run/docker.sock \
    containrrr/watchtower
  echo "${green}Installed watchtower"
  echo "${red} This won't do anything by default, to enable auto-updates for a container you have to run it with a label: for e.g:"
  echo "${red} ydocker run -d --label=com.centurylinklabs.watchtower.enable=true appname"
  echo "${red} you can also do this visually via  (advanced options when (re)deploying container)"
fi
###########################################################################################################################################################################################################################################################
if [[ $portainer_userchoice == "yes" ]]; then
  echo "${purple}installing portainer..."
  #installing portainer, a gui for docker.

  #creating its docker volume
  docker volume create portainer_data

  #running + installing it - forcing https
  docker run -d -p 8000:8000 -p 9443:9443 --name portainer \
      --restart=always \
      -v /var/run/docker.sock:/var/run/docker.sock \
      -v portainer_data:/data \
      portainer/portainer-ce:latest\
      --http-disabled

  echo "${green} Installed portainer, ${red}You may access it via https://YOURIP:9443"
  echo "${purple} you might want to consider re-deploying portainer as rootless ${purple} https://www.portainer.io/blog/portainer-and-rootless-docker"
fi
###########################################################################################################################################################################################################################################################
if [[ $yacht_userchoice == "yes" ]]; then
  echo "${purple}installing yacht..."
  #installing yacht
  docker volume create yacht
  docker run -d -p 8000:8000 -v /var/run/docker.sock:/var/run/docker.sock -v yacht:/config --name yacht selfhostedpro/yacht
  echo "${green}Installed yacht, ${red}You may access it via https://YOURIP:8000"
fi
###########################################################################################################################################################################################################################################################
if [[ $fail2ban_userchoice == "yes" ]]; then
  echo "${purple}installing fail2ban..."
  ### fail2ban - Application Intrusion Detection & Prevention. Achieves this by scanning application logs such as ssh or apache.
  apt install fail2ban -y
  #if case the user wants to edit fail2ban's config file
  cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
  cp /etc/fail2ban/fail2ban.conf /etc/fail2ban/fail2ban.local
  /etc/init.d/fail2ban restart
  echo "${green}Installed fail2ban"
  echo "${red}Switching fail2ban's ban type to DROP instead of reject is arguably better, since an attacker won't know if they're banned and hence will keep trying as opposed to changing their ip address"
  echo "${red}to do so, you can add the following line under [DEFAULT]:"
  echo "${red}banaction = iptables-multiport[blocktype=DROP]"
fi
###########################################################################################################################################################################################################################################################
if [[ $psad_userchoice == "yes" ]]; then
  #Scans iptables and ip6tables logs to detect and prevent DDOS and Port Scan attacks. Fine to install with fail2ban as they work on different areas.
  echo "${purple}installing PSAD..."
  apt install psad -y
  echo "${green}installed psad, ddos & port scan, detection and prevention"
fi
###########################################################################################################################################################################################################################################################
if [[ $systemd_userchoice == "yes" ]]; then
  echo "${purple}fetching templates"
  git clone https://github.com/t3dium/systemd-sandboxing
  echo "${green}downloaded templates"
  echo "${purple}moving templates to /etc/systemd/system and reloading daemon"
  mv systemd-sandboxing/* /etc/systemd/system
  systemctl daemon-reload
  echo "${green}hardened systemd services, you may run ${purple}systemd-analyze security${green} for an overview, or ${purple}systemd-analyze security appname"
  echo "${red}if this causes breakage just delete the folder for your service in /etc/systemd/service/[name-of-service] which contains the override"
fi
###########################################################################################################################################################################################################################################################
if [[ $ssh_port_userchoice == "yes" ]]; then
  echo "${purple}changing ssh port..."
  port="Port"
  concatinate="${port} ${ssh_port}"
  echo $concatinate >> /etc/shs/sshd_config
  echo "${green}Finished changing the ssh port"
fi
###########################################################################################################################################################################################################################################################
if [[ $harden_ssh_userchoice == "yes" ]]; then
  echo "${purple}Enforcing strong ssh ciphers and mac's..."
  echo "Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes256-ctr" >> /etc/shs/sshd_config
  echo "MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512,hmac-sha2-256" >> /etc/shs/sshd_config
  echo "${green}done"
fi
###########################################################################################################################################################################################################################################################
if [[ $disable_unnecessary_userchoice == "yes" ]]; then
  echo "${purple}Disabling unecessary modules"
  echo "blacklist bluetooth" >> /etc/modprobe.d/bluetooth.conf
  echo "${green}Disabled bluetooth"
  echo "blacklist bnep" >> /etc/modprobe.d/bnep.conf
  echo "${green}Disabled bnep - module related to bluetooth"
  echo "blacklist cpia2" >> /etc/modprobe.d/cpia2.conf
  echo "${green}Disabled cpia2 - module related to cameras"
  echo "blacklist firewire-core" >> /etc/modprobe.d/firewire-core.conf
  echo "${green}Disabled firewire-core - used for firewire cables"
  echo "blacklist floppy" >> /etc/modprobe.d/floppy.conf
  echo "${green}Disabled floppy - used for floppy disks"
  echo "blacklist n_hdlc" >> /etc/modprobe.d/n_hdlc.conf
  echo "${green}Disabled n_hdlc - unecessary"
  echo "blacklist net-pf-31" >> /etc/modprobe.d/net-pf-31.conf
  echo "${green}Disabled net-pf-31 - module related to bluetooth"
  echo "blacklist pcspkr" >> /etc/modprobe.d/pcspkr.conf
  echo "${green}Disabled pcspkr - module related to sound"
  echo "blacklist soundcore" >> /etc/modprobe.d/soundcore.conf
  echo "${green}Disabled soundcore - module related to sound"
  echo "blacklist thunderbolt" >> /etc/modprobe.d/thunderbolt.conf
  echo "${green}Disabled thunderbolt - unecessary for a server"
  echo "blacklist uvcvideo" >> /etc/modprobe.d/uvcvideo.conf
  echo "${green}Disabled uvcvideo - module used for UVC - video streaming over usb - for stuff like webcams"
  echo "blacklist v4l2_common" >> /etc/modprobe.d/v4l2_common.conf
  echo "${green}Disabled v4l2_common - module related to cameras"
  echo "${green}done"
  ######################################################
  echo "${purple}Disabling unecessary network protocols"
  echo "blacklist dccp" >> /etc/modprobe.d/dccp.conf
  echo "blacklist sctp" >> /etc/modprobe.d/sctp.conf
  echo "blacklist rds" >> /etc/modprobe.d/rds.conf
  echo "blacklist tipc" >> /etc/modprobe.d/tipc.conf
  echo "${green}Disabled unecessary network protocols"
fi
###########################################################################################################################################################################################################################################################
if [[ $mountpoints_userchoice == "yes" ]]; then
  echo "${purple} Backing up fstab file to /etc/ftab-COPY"
  cp /etc/fstab /etc/fstab-COPY
  echo "${purple} opening fstab file"
  echo "${red} for /boot, /boot/efi, and /var:  append ,nodev,nosuid,noexec to the list of mount options in column 4"
  echo ""
  echo "${red}also append the following line at the end:     proc    /proc   proc    defaults,hidepid=2  0   0"
  echo "${purple} enter [y] when you're ready to continue"
  read random_wait_variable2
  nano /etc/fstab
  #remounting /proc
  mount -o remount,hidepid=2 /proc
fi
###########################################################################################################################################################################################################################################################
if [[ $harden_cron_sshd_userchoice == "yes" ]]; then
  echo "${purple}hardening cron and sshd editing permissions"
  chmod 600 /etc/crontab
  chmod 600 /etc/ssh/sshd_config
  chmod 700 /etc/cron.d
  chmod 700 /etc/cron.daily
  chmod 700 /etc/cron.hourly
  chmod 700 /etc/cron.weekly
  chmod 700 /etc/cron.monthly
  echo "${green}done"
fi
###########################################################################################################################################################################################################################################################
if [[ $harden_kallsyms_userchoice == "yes" ]]; then
  echo "${purple}hardening /proc/kallsyms"
  chmod 400 /proc/kallsyms
  echo "${green}done"
fi
###########################################################################################################################################################################################################################################################
if [[ $chrony_userchoice == "yes" ]]; then
  echo "${purple}installing chrony for better time management than timesynd"
  apt install chrony -y
  systemctl start chrony && systemctl enable chrony
  echo "${purple} Configuring it to use NTS (secure ntp)"
  cat ./chrony.conf > /etc/chrony/chrony.conf
  systemctl restart chrony
  echo "${green}done"
fi
###########################################################################################################################################################################################################################################################
if [[ $harden_bash_userchoice == "yes" ]]; then
  echo "${purple}Using chattr +i on ~/.bashrc to prevent malicious editing."
  # setting bashrc & bash_profile as immutable, so it can't be modified. To modify, root access is needed to remove the chattr
  chattr +i ~/.bashrc
  chattr +i ~/.bash_profile
  echo "${green}hardened ~/.bashrc & bash_profile to prevent malicious edits, *** to undo ***, or to edit bashrc run the following command: sudo chattr -i ~/.bashrc && sudo chattr -i ~/.bash_profile"
fi
###########################################################################################################################################################################################################################################################

if [[ $disable_core_dumps_userchoice == "yes" ]]; then
  echo "${green}disabling core dumps.."
  echo "* soft core 0" >> /etc/security/limits.conf
  echo "* hard core 0" >> /etc/security/limits.conf
  echo "fs.suid_dumpable=0" >> /etc/sysctl.conf
  #applying
  sysctl -p
fi
###########################################################################################################################################################################################################################################################
if [[ $pivpn_choice == "yes" ]]; then
  echo "${purple}selfhosting a wireguard vpn server via pivpn.."
  echo "${purple}the installer isn't automatic, so you'll need to go through its TUI installer "

  curl -L https://install.pivpn.io | bash

  echo "${purple}creating wireguard config files..."
  echo "${green}please enter a name for the client's config file:"
  pivpn add
  echo "${green}finished selfhosting your vpn, make sure to port forward 51820 to the internet on your router settings in order to actually access the vpn from outside"
  echo "${red}** make sure you download your config files from /home/[username/configs/[name_you_chose].conf], you may then import this into the wireguard app to access your vpn. You can download the files via an SFTP client"
  echo "${green}it is also recommended to have 1 config per device, so type: sudo pivpn add if you wish to add more clients."
fi
###########################################################################################################################################################################################################################################################
if [[ $wgeasy_userchoice == "yes" ]]; then
  echo "${purple}selfhosting a wireguard vpn server via wg-easy.."

  your_server_ip=$(whiptail --title "Enter WAN ip" --inputbox "Enter your public WAN ip address:" 8 78 3>&1 1>&2 2>&3)
  your_admin_password=$(whiptail --title "Choose password" --inputbox "Enter a secure admin password:" 8 78 3>&1 1>&2 2>&3)

 #installing wg-easy
  docker run -d \
  --name=wg-easy \
  -e WG_HOST=$your_server_ip \
  -e PASSWORD=$your_admin_password \
  -v ~/.wg-easy:/etc/wireguard \
  -p 51820:51820/udp \
  -p 51821:51821/tcp \
  --cap-add=NET_ADMIN \
  --cap-add=SYS_MODULE \
  --sysctl="net.ipv4.conf.all.src_valid_mark=1" \
  --sysctl="net.ipv4.ip_forward=1" \
  --restart unless-stopped \
  weejewel/wg-easy
fi
###########################################################################################################################################################################################################################################################
if [[ $mkcert_userchoice == "yes" ]]; then
  echo "${purple}fetching the mkcert binary"
  # curl'ing from his website to fetch latest release
  curl -JLO "https://dl.filippo.io/mkcert/latest?for=linux/amd64"
  chmod +x mkcert-v*-linux-amd64
  cp mkcert-v*-linux-amd64 /usr/local/bin/mkcert
  echo "${purple}generating CA cert"
  mkcert -install
  echo "${green}generated CA cert"
  echo "${red}what domains or ips would you like the ssl cert to be valid for?"
  read domains_for_cert
  mkcert ${domains_for_cert}
  echo "${green}generated cert, to create more run: mkcert either_domain_here or_ip_here"
fi
###########################################################################################################################################################################################################################################################
# nextdns
if [[ $dnsoption_userchoice == "1" ]]; then
  sh -c 'sh -c "$(curl -sL https://nextdns.io/install)"'
  confignextdns=$(whiptail --title "Enter nextdns config id" --inputbox "Enter your nextdns config id here, (you'll need a free nextdns account), you can find this on my.nextdns.io:" 8 78 3>&1 1>&2 2>&3)
  nextdns config set \
    -config ${confignextdns}
fi
#
## quad9
#if [ $dnsoption_userchoice == "2" ]; then
#
#fi
#
## custom
#if [ $dnsoption_userchoice == "3" ]; then
#
#fi
############################################################################################################################################################################################################################################################
#if [ $sshkeys_userchoice == "1" ]; then
#
#fi

###########################################################################################################################################################################################################################################################
if [[ $lynis_userchoice == "yes" ]]; then
  echo "${purple}installing lynis, a system auditing tool...."
  apt install apt-transport-https ca-certificates host -y
  wget -O - https://packages.cisofy.com/keys/cisofy-software-public.key | apt-key add -
  echo "deb https://packages.cisofy.com/community/lynis/deb/ stable main" | tee /etc/apt/sources.list.d/cisofy-lynis.list
  apt install lynis host
  echo "${green}installed lynis.."
  if (whiptail --title "run lynis now?" --yesno "Installed lynis. Would you like to start a system audit now?" 8 78); then
    lynis update info
    lynis audit system
  fi
fi
  echo "${green}You can run the following command: ${red}lynis audit system,${green} whenever wanting to do a system audit"
###########################################################################################################################################################################################################################################################
echo "${purple}Finished running the script, open ports are listed below so that you can close any unneeded ones. Alternatively, block everything and whitelist those needed."
ss -lntup
echo "${red}when you are ready press ENTER to reboot"
read random_wait_variable_2
shutdown -r now
###########################################################################################################################################################################################################################################################