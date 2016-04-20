#!/bin/bash

sudo su

yes | apt-get update
yes | apt-get upgrade

apt-get install build-essential
apt-get install git

apt-get clean
