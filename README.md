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
    
## logs/volumes Directories

The logs/volumes directories used by Docker containers typically require
specific UID/GID settings. In order to facilitate this, the Vagrantfile
uses "rsync" to share the "docker-host-env" directory, excluding the
"logs" and "volumes" directory.

This means that:

a) Any logs/volumes directory needs to be created in the "install.sh" script,
in order for it to be present in the Vagrant machine.

b) The UID/GID for the logs/volumes directory should be set in the "install.sh"
script.

c) Only changes on the host machine can be synced to the guest. After making
changes on the host machine, run `vagrant rsync` to sync the files.
    
## IP Address and Host Names

The IP address is currently set to 192.168.7.25.

If this IP address is changed, appropriate changed should be made to the
"Vagrantfile", and "install.sh" files.

Some of the Docker containers may use hostname-based proxying. The hostnames
to use are specified in the "docker-host-env/nginx-proxy/nginx-service-env.yml"
file, for example:

```
- DOCKER_HOST_SERVER_NAME=docker-host.local
- SEARCH_SERVER_NAME=search.local
- ORCID_SERVER_NAME=orcid.local
- FCREPO_JENKINS_SERVER_NAME=ci-fcrepo-jenkins.local
```

To access these containers from the host, edit the "/etc/hosts" file, and add an
entry such as the following:

```
192.168.7.25 docker-host.local search.local orcid.local ci-fcrepo-jenkins.local
```
## Note

Sometimes Docker does not automatically pull down an image when starting the
stack. Sometimes it is necessary to pull down the images manually using the
"docker pull" command.

## SSL Certificate Handling

The "install.sh" script creates a number of self-signed SSL certificates. Java
requires that a certificate be added to the Java keystore in order for the
certificate to be considered valid. For example, Hippo will _not_ be able to
connect to the Vagrant, unless the appropriate certificate is added to the
keystore.

The self-signed SSL certificated created by the "install.sh" script are in
the "/tmp" directory.

To added an SSL certificate to the Java on the host machine:

1) Determine the "JAVA_HOME" directory:

```
> echo $JAVA_HOME
```

The output value should be used in \<JAVA_HOME> below.

2) In the Vagrant, go to the /tmp directory and find the certificate that Java
needs to accept. On the host machine, create a file named "valid.cert" with the
contents of the certificate file.

3) Run the following command:

```
> keytool -import -alias <CERT_ALIAS> -keystore <JAVA_HOME>/jre/lib/security/cacerts -file valid.cert
```

where \<CERT_ALIAS> is a name for the certificate, and \<JAVA_HOME> is the Java
home location from the previous step.

For example, for the "docker-host.local" cert, and a JAVA_HOME of
"/Library/Java/JavaVirtualMachines/jdk8u212-b03/Contents/Home":

```
> keytool -import -alias docker-host.local -keystore /Library/Java/JavaVirtualMachines/jdk8u212-b03/Contents/Home/jre/lib/security/cacerts -file valid.cert
```

If prompted for a password, the default password is "changeit".

4) When done, the keystore entry can be deleted using:

```
> keytool -delete -keystore <JAVA_HOME>/jre/lib/security/cacerts -alias <CERT_ALIAS>
```

For example, for the "docker-host.local" cert:

```
> keytool -delete -keystore /Library/Java/JavaVirtualMachines/jdk8u212-b03/Contents/Home/jre/lib/security/cacerts -alias docker-host.local
```
