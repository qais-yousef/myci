# Introduction

For each target system you want to execute tests on, you must create a Jenkins
Node.

There are several configurations to setup your NODEs and DUTs (Device Under
Test).

# Manage Linux DUTs natively

In this configuration your NODE and DUT are the same. We start the jenkins node
inside the DUT where it can run the test localy/natively on the DUT.

              DUT
    +----------------------+
    |                      |
    | +--------+           |
    | |Jenkins |           |
    | | Node   |           |
    | +--------+           |
    |                      |
    +----------------------+

# Manage Linux DUTs via SSH

In this configuration your NODE and DUT are different systems that communicate
via SSH. The NODE in this case can be any system that is able to communicate
with the DUT via SSH.

This configuration is useful when you can't setup a NODE in the DUT (it's
a small IoT device maybe) or you don't want Jenkins to interfere with your
testing.

TODO: This config not tried yet.

        Jenkins Node                            DUT
    +----------------------+          +----------------------+
    |                      |          |                      |
    |                      |   ssh    |                      |
    |                      |<-------->|                      |
    |                      |          |                      |
    |                      |          |                      |
    |                      |          |                      |
    +----------------------+          +----------------------+

# Manage Android devices via ADB

Similar to previous configuration but instead of SSH we communicate with the
DUT via ADB - which imply an Android based DUT.

You can use Wireless ADB or talk via USB.

TODO: Add USB support.

        Jenkins Node                            DUT
    +----------------------+          +----------------------+
    |                      |          |                      |
    |                      |   adb    |                      |
    |                      |<-------->|                      |
    |                      |          |                      |
    |                      |          |                      |
    |                      |          |                      |
    +----------------------+          +----------------------+

# Pre-requisites

`sudo apt install default-jre`
`sudo apt install adb`

It is better to get adb from latest sdk. The distribution version is usually
old and don't work with latest devices.

[https://developer.android.com/studio/releases/platform-tools](https://developer.android.com/studio/releases/platform-tools)

Download latest commandline tools from here:

[https://developer.android.com/studio](https://developer.android.com/studio)

```
mkdir ~/android-sdk/
cd ~/android-sdk/
unzip path/to/commandlinetools-linux-XXXXX_latest.zip
```

You might need to move cmdline-tools to `latest` if you get an error telling
you to do so.

```
cd ~/android-sdk/cmdline-tools
mkdir latest
mv * latest/
```

And use bundled sdkmanager to install build-tools

`~/android-sdk/cmdline-tools/latest/bin/sdkmanager --list`

Note down the latest version of build-tools, then get it

`~/android-sdk/cmdline-tools/latest/bin/sdkmanager "build-tools;$VERSION"`

# Jenkins User

Like Jenkins server, it'd be safer to create a special Jenkins user on the node
too. In case there's a security problem in Jenkins that allows external actor
to gain access to your system, then Jenkins user will limit their
accessibility.

`sudo adduser jenkins`

## Setup trace-cmd and perfetto on Native Linux

On Native Linux nodes, if you want to allow the user to run trace-cmd or
perfetto without giving it root privileges:

### Create a trace group and add Jenkins user to it

```
sudo addgroup trace
sudo usermod -a -G trace jenkins
```

### Install/Download trace-cmd or perfetto

`sudo apt install trace-cmd`

Download latest perfetto for Linux from github

[https://github.com/google/perfetto/releases](https://github.com/google/perfetto/releases)

### Setup permissions, owner and setuid on the binaries

```
sudo chown root:trace /usr/local/bin/trace-cmd
sudo chmod u+s,o-x /usr/local/bin/trace-cmd
```

```
sudo cp $PATH_TO_PERFETTO_DOWNLOAD/* /usr/local/bin/
for bin in $PATH_TO_PERFETTO_DOWN/*
do
	bin=`basename $bin`
	sudo chown root:trace /usr/local/bin/$bin
	sudo chmod u+s,ug+x,o-x /usr/local/bin/$bin
done
```

# Create workspace directory for jenkins

Login as jenkins user

`mkdir -p ~/nodes/$MY_NODE_NAME`

# Create New Node

	Manage Jenkins -> Manage Nodes and Clouds -> New Node

Specify the `Node name` and select `Permanent Agent`.

Set `# of executers` to 1 if this is a test target. Otherwise multiple test
could run concurrently and interfere with each others, unless you know this is
not a problem for you.

Set `Remote root directory` to the workspace directory you created above
`/home/jenkins/nodes/$MY_NODE_NAME`.

Set `labels` to match node name. Labels are used to manage where your jobs are
run. You can assign a label to a group of nodes. And you can set more than one
label for each node. For example you can have `android` label for all of your
android devices, then you can tell a job to select any node that has this
label.

Set `Usage` to `Only builds jobs with label expressions matching this node`.

Set `Launch method` to `Launch agents via SSH`. Then set the `Host` and
`Credentials` to your node hostname/ipaddress and jenkins username and
password respectively.

# Environment variables

You must define some environment variables to help identify the NODE
configuration.

## MYCI_NODE_TYPE

Must be one of two:
- linux
- android

## ANDROID_SERIAL

Only required for android.

If you're using adp over TCP, set it to IPADDRESS:PORT, otherwise the serial
number of the device as display by `adb devices`.

## PATH

You might want to update PATH to point to the location of where to find
android-sdk and ~/.local/bin if you install python deps locally.

`$HOME/.local/bin:$HOME/android-sdk/platform-tools:$HOME/android-sdk/build-tools/$VERSION/:$PATH`

# Setting up Wireless ADB

[Android 11+](https://developer.android.com/studio/command-line/adb#connect-to-a-device-over-wi-fi-android-11+)
[Android 10 or lower](https://developer.android.com/studio/command-line/adb#wireless)
