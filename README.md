# myconfig

My personal configuration for a macOS programming environment. This repository offers a set of
scripts that can be run idempotently to bootstrap a macOS machine from scratch, getting it ready
for development.

Before running the bootstrap scripts, make sure you know what you are doing.
Even if applying it will not destroy your system, applications installed with this automation script
might not be what you need, or you could misconfigure your current environment.
I suggest you alter the configuration files in a fork from this repo.

## Bootstrap your Mac

Steps to be done in a brand new Macbook (tested with `macOS Ventura`):

1. Run `git --version` in a Terminal. There will be a prompt to install the Command Line Developer Tools.
2. Configure your SSH key in `~/.ssh` or your PAT if you will clone via HTTPs.
3. `git clone git@github.com:darioblanco/myconfig.git`
4. `cd myconfig`
5. `make install`. Sudo password might be prompted to install certain tools.


## Components

- `install.sh`: install essential packages, fonts, programming language dependencies and macOS applications.
- `utils.sh`: common functions used in the bootstrap scripts.
