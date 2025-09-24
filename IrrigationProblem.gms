$ontext
CEE 6410 - Water Resources Systems Analysis
HW 4. Irrigation Problem

THE PROBLEM:

How much Hay and Grain should a farmer produce in a year: Data are as follows:


                         Hay              Grain
June                 2 acft/acre       1 acft/acre         14,000 acft
July                 1 acft/acre       2 acft/acre         18,000 acft
August               1 acft/acre       0 acft/acre          6,000 acft
Number of Acres    greater than 0    greater than 0        10,000 acres
Profit/plant             $100             $120

                Determine the optimal planting for the two plants.

THE SOLUTION:
Uses General Algebraic Modeling System to Solve this Linear Program

Tyler Mindrum
a02355861@usu.edu
September 23, 2025
$offtext

* 1. DEFINE the SETS
SETS plant plants planted /Hay, Grain/
     months months plants are planted /June, July, August, NumberAc/;

* 2. DEFINE input data
PARAMETERS
   plantprofit(plant) Objective function coefficients ($ per plant)
         /Hay 100,
         Grain 120/
   b(months) Right hand constraint values (per resource)
          /June 14000,
           July  18000,
           August  6000,
           NumberAc  10000/;

TABLE A(plant,months) Left hand side constraint coefficients
                 June       July     August     NumberAc
 Hay              2          1         1           1
 Grain            1          2         0           1    ;


* 3. DEFINE the variables
VARIABLES X(plant) plants planted (Number)
          VPROFIT  total profit ($);

* Non-negativity constraints
POSITIVE VARIABLES X;

* 4. COMBINE variables and data in equations
EQUATIONS
   PROFIT Total profit ($) and objective function value
   RES_CONSTRAIN(months) Resource Constraints;

PROFIT..                 VPROFIT =E= SUM(plant, plantprofit(plant)*X(plant));
RES_CONSTRAIN(months) ..    SUM(plant, A(plant,months)*X(plant)) =L= b(months);


* 5. DEFINE the MODEL from the EQUATIONS
MODEL PLANTING /PROFIT, RES_CONSTRAIN/;
*Altnerative way to write (include all previously defined equations)
*MODEL PLANTING /ALL/;


* 6. SOLVE the MODEL
* Solve the PLANTING model using a Linear Programming Solver (see File=>Options=>Solvers)
*     to maximize VPROFIT
SOLVE PLANTING USING LP MAXIMIZING VPROFIT;

* 6. CLick File menu => RUN (F9) or Solve icon and examine solution report in .LST file