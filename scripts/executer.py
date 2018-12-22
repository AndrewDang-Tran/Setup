#!/usr/bin/python3

import subprocess

def cdCommand(path):
    return '\"cd ' + path + '\"'

def aliasCommand(command):
    return 'alias ' + command


def lsCommand(path, flags):
    pathAndFlags = path + ' '
    for flag in flags:
        pathAndFlags += '-' + flag + ' '
    return 'ls ' + pathAndFlags

def run(commands):
    print(';'.join(commands))
    return subprocess.check_output(commands, shell=True)

def ls(path, flags):
    return run([lsCommand(path, flags)])

def alias(command):
    run([aliasCommand(command)])


def generateAlias(absolutePath):
    directoriesString = ls(absolutePath, 'd')
    directories = directoriesString.split(' ')
    for folder in directories:
        folder = folder[:-1]
        pathArray = folder.split('/')
        folderName = pathArray[len(pathArray) - 1]
        alias(folderName + '=' + cdCommand(absolutePath))

generateAlias('/home/andrew/workspace')
