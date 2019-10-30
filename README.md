# docker-host Vagrant

## Introduction

This repository is an attempt to mimic the "docker-host" server, using Vagrant.

## Prerequisites

1) Clone the "docker-host-env" Git repository into the root directory of this
project:

    ```
    > git clone git@bitbucket.org:umd-lib/docker-host-env.git
    ```

2) Populate the "env_files" directory with the .env/*-env.yml files needed for
the Docker containers.

3) Copy the "env_files" directory into the "docker-host-env/" directory:

    ```
    > cp -R env_files/ docker-host-env/
    ```

4) In the "docker-host-env" directory, change the permissions on the following
directories, so that the Docker containers can write to the directories:

    Note: This is needed because the "docker-host-env" directory is shared with
    the Vagrant machine, and cannot use uid/gid settings, as in the Vagrant
    machine the uid/gid for the directories is always "vagrant/vagrant".

    ```
    > chmod -R 777 docker-host-env/logs/solr-textbook/app
    ```

## Running the Vagrant machine:

1) Run the following command:

    ```
    > vagrant up
    ```

2) Once the Vagrant setup process is complete and the Vagrant machine is
running, SSH into the Vagrant machine:

    ```
    > vagrant ssh
    ```

3) In the Vagrant machine, add credentials for accessing the UMD Docker
repository:

    ```
    > docker login https://docker.lib.umd.edu
    ```

## IP Address

The IP address is currently set to 192.168.7.25.

If this IP address is changed, appropriated changed should be made to the
"Vagrantfile", and "install.sh" files.

## Note

Sometimes Docker does not automatically pull down an image when starting the
stack. Sometimes it is necessary to pull down the images manually using the
"docker pull" command.
