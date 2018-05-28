#!/bin/bash
# This script is meant to be run in the User Data of each EC2 Instance while it's booting. The script uses the
# run-consul script to configure and start Consul in client mode and the run-nomad script to configure and start Nomad
# in client mode. Note that this script assumes it's running in an AMI built from the Packer template in
# examples/nomad-consul-ami/nomad-consul.json.

set -e

function wait_for_dpkg_lock {
  # check for a lock on dpkg (another installation is running)
  set +e
  sudo lsof /var/lib/dpkg/lock > /dev/null
  dpkg_is_locked=$?
  set -e
  if [ "$dpkg_is_locked" == "0" ]; then
    echo "Waiting for another installation to finish"
    sleep 5
    wait_for_dpkg_lock
  fi
}


function installDocker() {
  echo "Installing Docker..."

  echo "Checking for dpkg lock..."
  wait_for_dpkg_lock

  sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
  sudo apt-add-repository 'deb https://apt.dockerproject.org/repo ubuntu-xenial main'
  sudo apt-get update

  echo "Checking for dpkg lock again..."
  wait_for_dpkg_lock
  sudo apt-get install -y docker-engine
}

# Send the log output from this script to user-data.log, syslog, and the console
# From: https://alestic.com/2010/12/ec2-user-data-output/
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# These variables are passed in via Terraform template interplation
/opt/consul/bin/run-consul --client --cluster-tag-key "${cluster_tag_key}" --cluster-tag-value "${cluster_tag_value}"
/opt/nomad/bin/run-nomad --client

sleep 30

installDocker
