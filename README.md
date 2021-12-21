# WIP

This project is still Work In Progress

# Pre-requisites

`sudo apt install default-jre`
`sudo apt install default-jre-headless`
`sudo apt install openssl`

# Jenkins User

It'd be safer to create a special Jenkins user to run your server. In case
there's a security problem in Jenkins that allows external actor to gain access
to your system, then Jenkins user will limit their accessibility.

`sudo adduser jenkins`

# First time setup

## Jenkins setup

Download jenkin images and sets up networking, volumes and SSL certificates.

`./setup_jenkins.sh dns:$SERVER_DNS_NAME`

or

`./setup_jenkins.sh ip:$SERVER_IP_ADDRESS`

Where replace $SERVER_DNS_NAME/$SERVER_IP_ADDRESS with your real values. This
is required to avoid python generating an error when talking to the server via
myci cli due to a missing subjectAltName in the certificate.

If you're accessing the server via localhost then use that as SERVER_DNS_NAME.

## Start Jenkins

`./start_jenkins.sh`

### Java version

Jenkins is picky about which java version to use. If you encounter issues (look
at nohup.out), then check the latest docs of Jenkins

[https://www.jenkins.io/doc/administration/requirements/java/](https://www.jenkins.io/doc/administration/requirements/java/)

You can update your PATH to point to the right java version for `jenkins` user
if you had to install multiple versions of java.

## Access Jenkins

`firefox https://localhost:8443`

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

You can just use the admin user. But it is recommended to create your own user
account.

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

### Setup git user.name and user.email

From `Configure System` page

	Manage Jenkins -> Configure System

In `Git plugin` section set `Global Config user.name Value` and
`Global Config user.email Value`.

### Setup bash as default shell

From `Configure System` page

	Manage Jenkins -> Configure System

In `Shell` section set `Shell executable` to `/bin/bash`.

Click `Save` button to save and exit.

### Run your first job

You're all ready now!

If you installed `Blue Ocean`, select `Open Blue Ocean` in the left hand side
menu. Then select `Jenkins-Healthcheck` job to test your setup. Hit `Run` when
prompted.

# Start/Stop Jenkins

## Start

`./start_jenkins.sh`

## Stop

`./stop_jenkins.sh`
