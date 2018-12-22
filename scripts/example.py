#!/usr/bin/python

from __future__ import print_function
from pprint import pprint
import json
import webbrowser
import sys

def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)

def search(url, query):
    searchUrl = url + query
    eprint(searchUrl)
    goto(searchUrl)

def goto(url):
    webbrowser.open_new_tab(url)
    exit()

scriptName = sys.argv[0]
scriptNameLength = len(scriptName)
if scriptName.startswith('./'):
    scriptName = scriptName[2:scriptNameLength-3]
elif '/' in scriptName:
    paths = scriptName.split('/')  
    scriptName = paths[len(paths) - 1]
    scriptNameLength = len(scriptName)
    scriptName = scriptName[0:scriptNameLength-3]
else:
    scriptName = scriptName[0:scriptNameLength-3]

query = ''
if len(sys.argv) > 1:
    query = sys.argv[1]

eprint('scriptName: ' + scriptName)
eprint('query: ' + query)

with open('/Users/andrewd/.alfred/search/search.json') as searchData:
    searchJson = json.load(searchData)
    eprint(searchJson)

searchMap = searchJson[scriptName]

if query in searchMap:
    goto(searchMap[query])
else:
    search(searchMap['search'], query)

