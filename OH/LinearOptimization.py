# -*- coding: utf-8 -*-
"""
Cheryl Ngo

9/15/19
"""
#Jones Financial Planning
from gurobipy import *

#Create model
m=Model('Jones')

#Use array to create decision variables
dvars=[]
for i in range(8):
    dvars.append(m.addVar(vtype=GRB.CONTINUOUS,name=["Savings Account","C.D.","Atlantic Lighting", "Arkansas REIT","Bedrock Insurance Annuity",
                                                     "Nocal Mining Bond", "Minicomp Systems","Antony Hotels"][i],lb=0))

m.update()

#Use array to add constraints
#Create variable names
constr_names=["TotalInvestment","ExpectedReturn","A-Rated","LiquidInvestments","SavingsAndCD"]
#Constraint LHS
constr_coef={}
expReturn=[.04,.052,.071,.1,.082,.065,.2,.125]
for i in range(5):
    for j in range (8):
        constr_coef[(i,j)]=0
        if i==0:
            constr_coef[(i,j)]=1
        if i==1:
            constr_coef[(i,j)]=expReturn[j]
        if i==2 and j in (0,1,4,6):
            constr_coef[(i,j)]=1
        if i==3 and j in (0,2,3,6,7):
            constr_coef[(i,j)]=1
        if i==4 and j in (0,1):
            constr_coef[(i,j)]=1
            
#Constraint RHS
rhs=[100000,7500,50000,40000,30000]

for i in range(len(rhs)):
    if i==0:
        m.addConstr(quicksum(constr_coef[(i,j)]*dvars[j] for j in range(len(dvars))),
                    GRB.EQUAL,rhs[i],constr_names[i])
    if i in (1,2,3):
        m.addConstr(quicksum(constr_coef[(i,j)]*dvars[j] for j in range(len(dvars))),
                    GRB.GREATER_EQUAL,rhs[i],constr_names[i])
    if i==4:
        m.addConstr(quicksum(constr_coef[(i,j)]*dvars[j] for j in range(len(dvars))),
                    GRB.LESS_EQUAL,rhs[i],constr_names[i])
    
m.update()

#Create objective function
obj_coef=[0,0,25,30,20,15,65,40]
m.setObjective(quicksum(obj_coef[i]*dvars[i] for i in range(len(dvars))))
m.ModelSense=GRB.MINIMIZE

m.update()

m.optimize()

print("The minimum total risk needed on to satisfy the portfolio constraints and expected return is $%s.  The requirements are attainable with the investment specifications below:"%("{0:,.2f}".format(m.objVal,2)))
for var in m.getVars():
    print("\t %s: $%s" % (var.varName,"{0:,.2f}".format(var.x,2)))