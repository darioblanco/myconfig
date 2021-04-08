# myconfig

My personal configuration for a macOS programming environment. This repository offers a set of
scripts that can be run idempotently to bootstrap a macOS machine from scratch, getting it ready
for development.

Before running the bootstrap scripts, make sure you know what you are doing.
Even if applying it will not destroy your system, applications installed with this automation script
might not be what you need, or you could misconfigure your current environment.
I suggest you alter the configuration files in a fork from this repo.

The scripts are tested and optimized for macOS Big Sur 11.2.3.

## Components

- `install.sh`: install essential packages, fonts, programming language dependencies and macOS applications
- `configure.sh`: copy configuration files (`./files/*`) and define development environment
- `sync.sh`: clone and pull Github repository for the currently authenticated user
- `utils.sh`: common functions used in the bootstrap scripts

## Run

Clone the repo

```sh
git clone https://github.com/darioblanco/myconfig
```

To bootstrap your macOS machine

### Installation

To install packages:

```sh
make install
```

Sudo password might be prompted, in order to install python/ruby packages.

### Configuration

To configure the development environment:

```sh
make configure
```

The script will prompt the powerlevel10k configurator if it is the first time you
define the zsh theme.

If you have no `.ssh` folder, it will prompt you to set a passphrase for the newly created
SSH key pair.

To finally apply the iTerm configuration, you need to set the `Dario` profile as default
in Preferences > Profile > Other Actions

### Synchronization

To sync only Github repositories

```sh
make sync
```

You will be prompted to log into your Github account the first time the script is run.

### All

This basically runs all the previously defined steps, in order.

```sh
make all
```
