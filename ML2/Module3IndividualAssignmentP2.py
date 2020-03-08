# -*- coding: utf-8 -*-
"""
Module 3 Individual Assignment Part 1: Cheryl Ngo

January 26, 2020
"""

from mrjob.job import MRJob
from mrjob.step import MRStep

class SpentByCustomer(MRJob):
    #Define MapReduce steps
    def steps(self):
        return [
            MRStep(mapper=self.mapper_key_value,
                   reducer=self.reducer_sum_value
                   ),
            MRStep(mapper=self.mapper_make_amount_key,
                   reducer=self.reducer_sort
                   )
        ]

    #Mapper: returns the customer ID and the amount spent
    def mapper_key_value(self, _, line):
        (customerID, itemID, amount) = line.split(',')
        yield customerID, float(amount)

    #Reducer: returns the customer ID and their total amount spent
    def reducer_sum_value(self, customerID, amount):            
        yield customerID,  '%10.02f'%sum(amount)
        
    #Mapper: Switches the key and value        
    def mapper_make_amount_key(self, customerID, amount):
        yield amount, customerID

    #Results in sorted data by amount spent
    def reducer_sort(self, amount, customerID):
        for c in customerID:
            yield round(float(amount),2), c

if __name__ == '__main__':
    SpentByCustomer.run()

#Execution statement
#!python Module3IndividualAssignmentP2.py buad5132-m3-individual-dataset.csv > Module3IndividualAssignmentP2.txt