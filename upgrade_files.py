#!/usr/bin/env python
# -*- coding: UTF-8 -*-

import argparse
import glob
import shutil
import os
from subprocess import Popen, PIPE


hosts = {
    'unicorn': '/home/dario'
}


def upgrade_files(hostpath, homepath):
    """Searchs for config files in the host home folder, copies them to the
    destination folder, adds them to the github repository and prompts a commit
    """
    for destpath in glob.glob("{}/.*".format(hostpath)):
        basepath, filename = os.path.split(destpath)
        sourcepath = "{}/{}".format(homepath, filename)
        shutil.copy(sourcepath, destpath)
        print "Copied '{}' into '{}'".format(sourcepath, destpath)

        git_command = ["git", "add", destpath]
        p = Popen(git_command, stdout=PIPE, stderr=PIPE)
        error_code = p.wait()
        error_str = p.stderr.read()
        if error_code:
            print ("Error adding file '{}' to the git repository "
                   "(code: {})").format(filename, error_code)
        if error_str:
            print ("Error adding file '{} to the git repository "
                   "(reson: {})").format(filename, error_str)

    git_command = ["git", "commit"]
    p = Popen(git_command, stderr=PIPE)
    error_code = p.wait()
    error_str = p.stderr.read()
    if error_code:
        print ("Error creating git commit "
               "(code: {})").format(filename, error_code)
    if error_str:
        print ("Error creating git commit "
               "(reson: {})").format(filename, error_str)


def valid_host(hostname):
    """Checks that the given hostname has a folder"""
    hostpath = os.path.dirname(os.path.abspath(__file__)) + os.sep + hostname
    if not os.path.exists(hostpath):
        msg = "Unable to find host folder in '{}'".format(hostpath)
        raise argparse.ArgumentTypeError(msg)
    try:
        homepath = hosts[hostname]
    except KeyError:
        msg = "Unable to find home path for the host '{}'".format(hostname)
        raise argparse.ArgumentTypeError(msg)
    return hostpath, homepath


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='Upgrades the config files for the selected host')
    parser.add_argument('hostname', type=valid_host, help=('The name of the '
                        'host whose files will be updated'))

    hostpath, homepath = vars(parser.parse_args())['hostname']
    upgrade_files(hostpath, homepath)
