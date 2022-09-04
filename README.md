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
- [x] Automated docker updates
- [x] Hardening cron editing permissions
- [x] Hardening sshd editing permissions
- [x] Systemd service sandbox hardening - https://github.com/t3dium/systemd-sandboxing
- [x] LKRG - prevent changes & exploits to the linux kernel
- [X] Mountpoint hardening - hardening /boot, /boot/efi, and /var and hiding /proc
- [x] Disable core dumps - contains sensitive info in its memory snapshots
- [x] Restricting /proc/kallsyms - info on how kernel memory is laid out which makes it easier to attack the kernel itself
- [x] Lys, system audit tool
- [x] Oerview of open ports at the end 

#### Security Automations - Networking
- [x] Fail2ban - Application Intrusion Detection And Prevention
- [x] Psad - iptables Intrusion Detection And Prevention (prevents ddos and port scan attacks)
- [x] Change SSH port - [Defense in depth](https://en.m.wikipedia.org/wiki/Defense_in_depth_(computing)), **not** security by obscurity.
- [x] Securing dns, dnssec and encryption - partially done
- [ ] Setup SSH key authentication and disable password authentication
 
#### Misc Automations
- [x] installing docker
- [x] installing portainer, a gui for docker
- [x] or installing yacht, a gui for docker
- [x] installing nginx proxy manager 
- [ ] + making some self signed certs
- [x] installing screenfetch
- [x] installing bender - homer fork which allows editing entries via its webgui - dashboard
- [x] setup a wireguard vpn server easily - pivpn - cli
- [x] or setup a wireguard vpn server easily - wg-easy - web gui
