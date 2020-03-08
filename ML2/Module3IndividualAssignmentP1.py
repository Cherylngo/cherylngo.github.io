# -*- coding: utf-8 -*-
"""
Module 3 Individual Assignment Part 1: Cheryl Ngo

January 26, 2020
"""

from mrjob.job import MRJob

class SpentByCustomer(MRJob):

    #Mapper: returns the customer ID and the amount spent
    def mapper(self, _, line):
        (customerID, itemID, amount) = line.split(',')
        yield customerID, float(amount)

    #Reducer: returns the customer ID and their total amount spent
    def reducer(self, customerID, amount):            
        yield customerID, round(sum(amount),2)

if __name__ == '__main__':
    SpentByCustomer.run()

#Execution statement
#!python Module3IndividualAssignmentP1.py buad5132-m3-individual-dataset.csv > Module3IndividualAssignmentP1.txt