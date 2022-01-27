# linux.sh
A bash script I've made to automate my ubuntu server installs, it'll harden various aspects of the server and secure it, as well as automating some other useful tasks on a fresh install. **Not Yet Released**

## How to run
1) `git clone https://github.com/t3dium/linux.sh.git`
2) `cd linux.sh`
3) `sudo bash linux.sh`

It'll work on any debian/ubuntu based distro

## What's been implemented so far:
**(The script will allow user choice, and won't run all the tasks listed below)**
#### Security Automations - General
- [x] Automated updates
- [x] Restricting editing cron to root
- [ ] Restricting editing grub to root
- [x] list open ports, so the user can then close any unneeded ones.

#### Security Automations - SSH
- [x] Install Fail2Ban - currently doesn't work if you change the ssh port
- [ ] Change SSH port
- [ ] Setup SSH key authentication and disable password authentication

#### Misc Automations
- [x] installing docker
- [x] installing portainer, a gui for docker
- [x] installing nginx proxy manager + making some self signed certs
- [x] installing screenfetch
- [x] setup a wireguard vpn server easily
