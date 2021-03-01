# Introduction

MyCI does not maintain any tests on its own except for the single
Jenkins-Healthcheck. The concept is to keep Jenkins maintenance and development
separate from actual tests. Allowing this core infrastructure to be customized
and used for different purposes that suits each individual need.

# Add new tests

## From existing git repository

### Clone

```
cd jenkins_home/jobs/
git submodule add $URL
```
### Apply

If Jenkins is already running, you need to reload Jenkins

	Manage Jenkins -> Reload Configuration from disk

Alternatively you can also restart Jenkins.

# Create new tests

## Create Folder

## Add to git submodule

```
git submodule init jenkins_home/jobs/$NEW_FOLDER
```
