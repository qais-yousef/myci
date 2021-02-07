# WIP

This project is still Work In Progress

# Pre-requisites

`sudo apt install docker.io`

# Setup rootless docker

It is advised not to run docker as root and to create a special jenkins user
for it that has minimum privileges.

	https://docs.docker.com/engine/security/rootless/

## Quick Guide

```
sudo adduser jenkins
sudo apt install uidmap
su jenkins
wget https://get.docker.com/rootless
chmod +x rootless
./rootless
# Copy the generated 'export' highlighted by rootless to your .bashrc or
# .bash_alias
```

# First time setup

## Jenkins setup

Download jenkin images and sets up networking and volumes.

`./setup_jenkins.sh`

## Fix jenkins_home permissions

If uid and gid of jenkins user in docker image are different from the host
user, we will get permission errors when trying to share jenkins_home as
a volume. To fix it, we modify the uid/gid of jenkins user in docker to match
the host user.

`./fix_permissions.sh`

## Start Jenkins

`./start_jenkins.sh`

## Install required tools

Install all necessary tools to build the kernel and run Lisa.

`./install_tools.sh`

## Access Jenkins

`firefox localhost:8080`

## username/pass

username: `admin`

password: `./adminpass_jenkins.sh`

## Configure Jenkins

### Plugins

On first run make select `Install suggested plugins`. Make sure they were all
successful. If not, retry. If failure persisted, restart jenkins and try again
via

	manage jenkins -> manage plugins -> available

you might want to take note of these plugins names first.

### Create First Admin User

You can just use the admin user. But it is recommended to create your own
unprivileged user account.

### Instance Configuration

The choice doesn't matter. I usually skip.

### Blue Ocean Plugin

We make use of pipelines, so having Blue Ocean plugin would be recommended, yet
optional if you'd like to skip. You can install it from

	Manage Jenkins -> Manage Plugins -> Available

Search for `Blue Ocean`. In the returned values only select the plugin named
`Blue Ocean` without any additional text.

Click `Download now and install after restart` button after ticking the `Blue
Ocean` checkbox.

Select `Restart Jenkins when installation is complete and no jobs are running`
box when all dependencies are installed.

The GUI sometimes seems to have hanged when Jenkins restarts. If you stopped
seeing any updates on the page, refresh it.

### Setup bash as default shell

From `Configure System` page

	Manage Jenkins -> Configure System

In `Shell` section set `Shell executable` to `/bin/bash`.

Click `Save` button to save and exit.

### Run your first job

You're all ready now!

If you installed `Blue Ocean`, select `Open Blue Ocean` in the left hand side
menu. Then select `Jenkins Healthcheck` job to test your setup. Hit `Run` when
prompted.

# Start/Stop Jenkins

## Start

`./start_jenkins.sh`

## Stop

`./stop_jenkins.sh`

# Using adb in Jenkins

You can't have 2 adb servers running in the machine, even if one of them is
inside a docker image. Only one of the servers will be able to see the device.

So make sure to run `adb kill-server` in the host machine to allow the docker
image access to the device via adb.

# Shell into docker image

`./shell.sh`

## Root shell

`./root_shell.sh`
