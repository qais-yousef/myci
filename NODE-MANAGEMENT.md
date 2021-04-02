# Introduction

For each target system you want to execute tests on, you must create a Jenkins
Node.

# Manage Linux systems natively
# Manage Linux systems via SSH
# Manage Android devices via ADB

# Pre-requisites

`sudo apt install default-jre`
`sudo apt install adb`

# Jenkins User

Like Jenkins server, it'd be safer to create a special Jenkins on the node too.
In case there's a security problem in Jenkins that allows external actor to
gain access to your system, then Jenkins user will limit their accessibility.

`sudo adduser jenkins`

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
adroid devices, then you can tell a job to select any node that has this label.

Set `Usage` to `Only builds jobs with label expressions matching this node`.

Set `Launch method` to `Launch agents via SSH`. Then set the `Host` and
`Credentials` to your node hostname/ipaddress and jenkins username and
password respectively.

# Environment variables

## IPADDRESS
## PORT
