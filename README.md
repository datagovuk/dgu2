
## Developer Setup

Currently only Postgres and ElasticSearch are installed inside the VM - this is
due to issues with virtualbox noticing file changes.  Because it doesn't notice
file changes, live reloading during development doesn't work, and we like
live-reloading. For now to develop on the host this means there are two stages.


### Virtual Machine Setup

To build the development environment, you will need to have the following
software installed:

* Virtualbox (recent) v5.0.26
* Vagrant (vagrantup.com) v1.8.5+
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


### Local machine setup

On your local machine you need to have the following installed:

* Erlang 19.x
* Elixir 1.3.1
* Elm
* Node/NPM

#### OSX

If you are using homebrew you should get all the deps that you need with the following:

```bash
brew update
brew install elixir # Want v1.3.x
brew install nodejs
brew install npm
```

#### Initialising

Once you have all of the dependencies installed you should be able to do the following (assuming the VM is running):

```bash
cd src/dguweb/
mix local.hex # If this is your first elixir app
mix local.rebar # If this is your first elixir app
mix deps.get
mix deps.compile
mix ecto.create
mix ecto.migrate
npm install
```

## Running the server

For development, you can run the backend server with the following command:

```bash
mix phoenix.server
```

As live-reloading is enabled, any changes you make to ```src/dguweb/web/static/{css,js}``` or ```src/dguweb/web/templates/*.eex``` should be reflected in the browser without reloading or restarting anything.
