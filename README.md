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

Sudo password might be prompted (for instance, to install `n` to manage `node` versions).
