$ontext
CEE 6410 - Water Resources Systems Analysis
Dual Formulation of Problem 2.3 from Bishop Et Al Text (https://digitalcommons.usu.edu/ecstatic_all/76/)

Formulate and solve the PRIMAL and DUALs of THE PROBLEM:

An irrigated farm can be planted in two crops:  Hay and Grain.  Data are as follows:

Seasonal Resource
Inputs or Profit        Crops        Resource
Availability
                      Hay                Grain
June              2 acft/acre        1 acft/acre           14000 acft
July              1 acft/acre        2 acft/acre           18000 acft
August            1 acft/acre        0 acft/acre            6000 acft
Number Acres     greater than 0     greater than o         10000 acre
Return/Acre          $100               $120
                Determine the optimal planting for the two crops.

THE SOLUTION:
Uses General Algebraic Modeling System to Solve this Linear Program

Tyler Mindrum
a02355861@usu.edu
October 20, 2025
$offtext

* 1. DEFINE the SETS
SETS plnt crops growing /Hay, Grain/
     res resources /June, July, August, NumAcre/;

* 2. DEFINE input data
PARAMETERS
   c(plnt) Objective function coefficients ($ per plant)
         /Hay 100,
         Grain 120/
   b(res) Right hand constraint values (per resource)
          /June 14000,
           July  18000,
           August 6000,
           NumAcre 10000/;

TABLE A(plnt,res) Left hand side constraint coefficients
                 June    July    August    NumAcre 
 Hay              2       1        1         1
 Grain            1       2        0         1;     

* 3. DEFINE the variables
VARIABLES X(plnt) plants planted (Number)
          VPROFIT  total profit ($)
          Y(res)  value of resources used (units specific to variable)
          VREDCOST total reduced cost ($);

* Non-negativity constraints
POSITIVE VARIABLES X,Y;

* 4. COMBINE variables and data in equations
EQUATIONS
   PROFIT_PRIMAL Total profit ($) and objective function value
   RES_CONS_PRIMAL(res) Resource constraints
   REDCOST_DUAL Reduced Cost ($) associated with using resources
   RES_CONS_DUAL(plnt) Profit levels ;

*Primal Equations
PROFIT_PRIMAL..                 VPROFIT =E= SUM(plnt,c(plnt)*X(plnt));
RES_CONS_PRIMAL(res) ..    SUM(plnt,A(plnt,res)*X(plnt)) =L= b(res);

*Dual Equations
REDCOST_DUAL..                 VREDCOST =E= SUM(res,b(res)*Y(res));
RES_CONS_DUAL(plnt)..          sum(res,A(plnt,res)*Y(res)) =G= c(plnt);

X.LO(plnt) = 5;

* 5. DEFINE the MODELS
*PRIMAL model
MODEL PLANT_PRIMAL /PROFIT_PRIMAL, RES_CONS_PRIMAL/;
*Set the options file to print out range of basis information
*PLANT_PRIMAL.optfile = 1;

*DUAL model
MODEL PLANT_DUAL /REDCOST_DUAL, RES_CONS_DUAL/;

* 6. SOLVE the MODELS
* Solve the PLANTING PRIMAL model using a Linear Programming Solver (see File=>Options=>Solvers)
*     to maximize VPROFIT
SOLVE PLANT_PRIMAL USING LP MAXIMIZING VPROFIT;

* Solve the PLANTING DUAL model using a Linear Programming Solver (see File=>Options=>Solvers)
*     to maximize VPROFIT
SOLVE PLANT_DUAL USING LP MINIMIZING VREDCOST;
*Order does not matter!

* 6. CLick File menu => RUN (F9) or Solve icon and examine solution report in .LST file
