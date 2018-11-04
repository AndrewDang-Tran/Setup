#!/usr/bin/python3

import json
import webbrowser
import sys
from pprint import pprint

def search(url, query): 
    goto(url + query)

def goto(url):
    webbrowser.open_new_tab(url)
    exit()

scriptName = sys.argv[0]
scriptNameLength = len(scriptName)
scriptName = scriptName[2:scriptNameLength-3]
print(scriptName)
query = ''
if len(sys.argv) > 1:
    query = sys.argv[1]

with open('search.json') as searchData:
    searchJson = json.load(searchData)
    pprint(searchJson)

searchMap = searchJson[scriptName]

if query in searchMap:
    goto(searchMap[query])
else:
    search(searchMap['search'], query)

