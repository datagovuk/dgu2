[![Build Status](https://semaphoreci.com/api/v1/ross/dgu2/branches/master/badge.svg)](https://semaphoreci.com/ross/dgu2)

## Developer Setup

This repository currently requires the Virtual Machine specified by https://github.com/datagovuk/dgu_deploy
so you should use that repository to generate your working environment.


### Virtual Machine Setup

To build the development environment, you will need to have the following
software installed:

* Virtualbox (recent) v5.0.26
* Vagrant (vagrantup.com) v1.8.5+
* Ansible (pip install ansible) v2.1+

Follow the instructions at https://github.com/datagovuk/dgu_deploy


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
brew install elm
npm install -g npm
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
elm-package install
mix run priv/repo/seeds.exs  # Load seed data
```

## Running the server

For development, you can run the backend server with the following command:

```bash
mix phoenix.server
```

As live-reloading is enabled, any changes you make to ```src/dguweb/web/static/{css,js}``` or ```src/dguweb/web/elm/*.elm``` or ```src/dguweb/web/templates/*.eex``` should be reflected in the browser without reloading or restarting anything.

## Users

Until authentication is addressed you must perform a manual step to set up your users in the prototype.

1. Connect to your new CKAN from the dgu_deploy repository, and register some users and assign to the appropriate organisations.

2. For each user, visit their user profile and obtain their API keys. You may use the UI, or access the public."user" table in the ckan database.

3. In the dguweb_dev database you need to assign these API keys to users who have registered in the prototype front-end. You can do this in the public.users table in the dguweb_dev database.

Once this is complete, when users log in to the prototype the list of organisations they can manage is retrieved and stored against their connection so that user and permitted organisations are available to the prototype.


## Translations

It's kind of nice to be able to provide translations into languages used in the UK - such as Welsh.

To re-generate the PO files use 

```
mix gettext.extract --merge
```

To make something translatable, use ```<%= gettext "My text string" %>```

You can test for now by passing ```?locale=en``` as a querystring until we provide a proper route.

