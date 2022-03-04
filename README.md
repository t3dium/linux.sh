# linux.sh
A bash script I've made to automate my ubuntu server installs, it'll harden various aspects of the server and secure it, as well as automating some other useful tasks on a fresh install.

## How to run
1) `git clone https://github.com/t3dium/linux.sh.git`
2) `cd linux.sh`
3) `sudo bash linux.sh`

It'll work on any debian/ubuntu based distro

## What's been implemented so far:
**(The script will allow user choice, and won't run all the tasks listed below)**
#### Security Automations - Misc
- [x] Automated System updates
- [x] Restricting editing cron to root
- [x] lynis, system audit tool
- [x] overview of open ports at the end 

#### Security Automations - Networking
- [x] fail2ban - Application Intrusion Detection And Prevention
- [x] psad - iptables Intrusion Detection And Prevention (prevents ddos and port scan attacks)
- [x] Change SSH port - [Defense in depth](https://en.m.wikipedia.org/wiki/Defense_in_depth_(computing)), **not** security by obscurity.
- [x] securing dns, dnssec and encryption
- [ ] Setup SSH key authentication and disable password authentication
 
#### Misc Automations
- [x] installing docker
- [x] installing portainer, a gui for docker
- [ ] installing nginx proxy manager + making some self signed certs
- [x] installing screenfetch
- [x] setup a wireguard vpn server easily
