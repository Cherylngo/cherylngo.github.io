# -*- coding: utf-8 -*-
"""

@author: chery
"""
#Import packages
import requests

#URL, editing headers
url = 'http://buckets.peterbeshai.com/api/?player=201939&season=2015'
headerText = {"User-Agent": "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36"}

#Import data
response = requests.get(url, headers=headerText)
json2 = response.json()

#Username
print('cango')

#Jump shots counted
jshot=0
for attempt in json2:
    if "Jump Shot"==attempt['ACTION_TYPE']:
        jshot+=1
print(jshot)

#Count of jump shots made
jshotMade=0
for attempt in json2:
    if "Jump Shot"==attempt['ACTION_TYPE'] and 'Made Shot'==attempt['EVENT_TYPE']:
        jshotMade+=1
print(jshotMade)

print(jshotMade/jshot)