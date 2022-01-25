# linux.sh
A simple bash script I've made to automate my ubuntu server installs, it'll harden various aspects of the server and secure it, as well as automating some other useful tasks on a fresh install. **Not Yet Released**

## How to run
1) `git clone https://github.com/t3dium/linux.sh.git`
2) `cd linux.sh`
3) `sudo bash linux.sh`

The script will also allow user choice, and won't run all the tasks listed below.

## What's been implemented so far:

#### Security Automations - General
- [ ] Automated updates
- [ ] Restricting editing cron to root
- [ ] Restricting editing grub to root
- [ ] list open ports, so the user can then close any unneeded ones.

#### Security Automations - SSH
- [ ] Install Fail2Ban
- [ ] Change SSH port
- [ ] Setup SSH key authentication and disable password authentication

#### Misc Automations
- [ ] installing docker
- [ ] installing portainer, a gui for docker
- [ ] installing nginx proxy manager + making some self signed certs
- [ ] installing screenfetch
