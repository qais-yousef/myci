# Introduction

MyCI is meant as a personal CI with mostly local access. But that doesn't mean
there can't be potential security threats that you need to be aware of.

## Unsafe tests from malicious sources

When adding a new test to your system from a submodule, make sure you trust the
source. These tests will run on your target devices and if they were malicious
can try to take advantage for example from running on a rooted device to try to
get access to your internal network and potentially steal some data.

## Always update Jenkins

## Secure your Jenkins setup

Especially if you allow access through the internet!

## Unless necessary, always create special unprivileged Jenkins user

For both running Jenkins server and for your target devices you want to run
tests on. The less privilege the user has, the less likely any harm is done if
the user was compromised.
