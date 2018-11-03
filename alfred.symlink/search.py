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


SEARCH_KEY = 'search'
PATH_TO_URL_MAP = 'search.json'

scriptName = sys.argv[0]
scriptNameLength = len(scriptName)
scriptName = scriptName[2:scriptNameLength-3]
print(scriptName)
query = ''
if len(sys.argv) > 1:
    query = sys.argv[1]

with open(PATH_TO_URL_MAP) as searchData:
    searchJson = json.load(searchData)
    pprint(searchJson)

searchMap = searchJson[scriptName]

if query in searchMap:
    goto(searchMap[query])
else:
    search(searchMap[SEARCH_KEY], query)

