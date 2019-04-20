# -*- coding: utf-8 -*-
"""
Created on Sun Feb 17 17:11:00 2019

@author: chery
"""
def binpack(articles,bin_cap):
    """ Write your heuristic bin packing algorithm in this function using the argument values that are passed
             articles: a dictionary of the items to be loaded into the bins: the key is the article id and the value is the article volume
             bin_cap: the capacity of each (identical) bin (volume)
    
        Your algorithm must return two values as indicated in the return statement:
             my_team_number_or_name: if this is a team assignment then set this variable equal to an integer representing your team number;
                                     if this is an indivdual assignment then set this variable to a string with you name
             bin_contents: A list of lists, where each sub-list indicates the dictionary keys for the items assigned to each bin.      
                           Each sublist contains the item id numbers (integers) for the items contained in that bin.  The integers refer to 
                           keys in the items dictionary. 
   """
        
    myUsername = 'cango'    # always return this variable as the first item
    myNickname = 'CN'    # name to appear on the leaderboard: to opt out specify ''
    bin_contents = []    # use this list document the article ids for the contents of 
                         # each bin, the contents of each is to be listed in a sub-list
#Sort the items descending by volume
    item_sorted=[]
#    items={}
#    items={0:1,1:5,2:5,3:4,4:2}
    for item in sorted(articles, key=articles.get, reverse=True):
        item_sorted.append([item, articles[item],''])
#    print(item_sorted) 
    
#Initialize variables
    bin_contents=[[]]
#    bin_cap=5
    cap_left=[bin_cap]
#Iterate through sorted items
    #If the item is less than or equal to the remaining bin capacity, add the item to the bin
    for i in range(len(item_sorted)):
        for j in range(len(cap_left)):
            if item_sorted[i][1]<=cap_left[j]:
                bin_contents[j].append(item_sorted[i][0])        
                #item_sorted[i][2]=j                              
                cap_left[j]-=item_sorted[i][1]
                #bin+=1
                break
    #If the item does not fit in any of the bins, start a new bin
            elif j==len(cap_left)-1:
                bin_contents.append([item_sorted[i][0]])            
                #item_sorted[i][2]=len(cap_left)                                
                cap_left.append(bin_cap - item_sorted[i][1]) 
                break

#    print(bin_contents)
#    print(item_sorted)
#    print(cap_left)
       
    return myUsername, myNickname, bin_contents       # use this return statement when you have items to load in the knapsack
