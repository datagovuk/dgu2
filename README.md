
## Developer Setup

To build the development environment, you will need to have the following 
software installed:

* Virtualbox (recent)
* Vagrant (vagrantup.com) v1.8.4+
* Ansible (pip install ansible) v2.1+

To install the development environment you should run the following command:

```
vagrant up
```

    NOTE: If you encounter an error related to mapping folders in the host 
    then this is a known bug with the xenial box and you should run the 
    following commands before continuing.

        vagrant ssh
        sudo apt-get --no-install-recommends install virtualbox-guest-utils
        exit
        vagrant reload

This should download the appropriate box, set it up and then provision it 
using the ansible scripts in the deploy directory.  If you wish to re-provision
at any time you can use the ```vagrant provision``` command to rebuild the VM.

Once the environment is up and running, you can connect to the box with

```
vagrant ssh
```

NOTE: Temporarily you should run 
```
sudo dpkg-reconfigure tzdata
```
