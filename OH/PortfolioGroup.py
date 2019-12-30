# -*- coding: utf-8 -*-
"""
Jacob Myer, Cheryl Ngo, and Keerti Sharma

10/6/2019
"""
import mysql.connector

from gurobipy import *

db=mysql.connector.connect(user='root',password='root',host='localhost',database='nasdaq')

#Create cursor
cur=db.cursor()

#This returns all data in cov
cur.execute('select * from cov')
Q=cur.fetchall()

#This returns all data r
cur.execute('select * from r')
r=cur.fetchall()

max_risk=[.6,.55,.5,.45,.4,.3,.2,.15,.14,.13,.12,.11,.1,.09,.08,.07,.06,.05,.04,.03,.02,.01,.005]

#Create model
m=Model('Portfolio')
    
#Use array to create decision variables
dvars=[]
for i in range(len(r)):
    dvars.append(m.addVar(vtype=GRB.CONTINUOUS,name=r[i][0],lb=0,ub=1))

#Use array to add constraints
#Create variable names
constr_names=["Portfolio Total","Portfolio Risk"]
#Constraint LHS
s=[Q[i][2]*dvars[i%len(dvars)] for i in range(len(Q))]
constr_coef=[[1 for i in range(len(r))],[sum(s[i:i+len(r)]) for i in range(0, len(s), len(r))]]

#Loop with varying maximum risk values
for z in range(len(max_risk)):
    #Constraint RHS
    rhs=[1,max_risk[z]]
    
    for i in range(len(rhs)):
        if i==0:
            m.addConstr(quicksum(constr_coef[i][j]*dvars[j] for j in range(len(dvars))),
                        GRB.EQUAL,rhs[i],constr_names[i])
        if i != 0:
            m.addConstr(quicksum(constr_coef[i][j]*dvars[j] for j in range(len(dvars))),
                        GRB.LESS_EQUAL,rhs[i],constr_names[i])
    
    #Create objective function
    m.setObjective(quicksum(dvars[i]*r[i][1] for i in range(len(dvars))))
    m.ModelSense=GRB.MAXIMIZE
    
    m.update()
    
    m.optimize()
    
    """print("The maximum return is %s for a maximum risk of %s.  This is achieved with the following portfolio:"%("{0:,.2f}".format(m.objVal),max_risk[z]))
    for var in m.getVars():
        print("\t %s: %s" % (var.varName,round(var.x,2)))"""
    
    #Write to MySQL
    sqlInsert = "INSERT INTO portfolio (expReturn, expRisk) VALUES (%s, %s)" % (m.objVal,max_risk[z])
    cur.execute(sqlInsert)

db.commit()

#Close the database connection
db.close()

