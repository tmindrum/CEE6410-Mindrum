$ontext
CEE 6410 - Water Resources Systems Analysis
Example 2. Automobile Production
Modifies Example to add a labor constraint

and further modified to represent the vehicle production problem with metal, circut boards, and labor as constraints.

THE PROBLEM:

How many coups and minivans should a car manufacurer produce in a year: Data are as follows:

Seasonal Resource
Inputs or Profit        Crops        Resource
Availability
                       Coups        Minivans
Metal          1x103 gal/plant        2x103 gal/plant      4x106 gal/year
Circut Boards        4 ft2/plant        3 ft2/plant               1.2x104 ft2
Labor               5hr/plant        2.5/hr plant              17,500 hours
Profit/plant             $6000        $7000

                Determine the optimal planting for the two crops.

THE SOLUTION:
Uses General Algebraic Modeling System to Solve this Linear Program

David E Rosenberg
david.rosenberg@usu.edu
September 15, 2015
$offtext

* 1. DEFINE the SETS
SETS car cars manufactured /Coup, Minivans/
     materials materials used to produce vehicles /Metal, CircutBoards, Labor/;

* 2. DEFINE input data
PARAMETERS
   carprofit(car) Objective function coefficients ($ per car)
         /Coup 6000,
         Minivans 7000/
   b(materials) Right hand constraint values (per resource)
          /Metal 4000000,
           CircutBoards  12000,
           Labor  17500/;

TABLE A(car,materials) Left hand side constraint coefficients
                 Metal    CircutBoards   Labor
 Coup           1000          4            5
 Minivans        2000          3            2.5;


* 3. DEFINE the variables
VARIABLES X(car) cars manufactured (Number)
          VPROFIT  total profit ($);

* Non-negativity constraints
POSITIVE VARIABLES X;

* 4. COMBINE variables and data in equations
EQUATIONS
   PROFIT Total profit ($) and objective function value
   RES_CONSTRAIN(materials) Resource Constraints;

PROFIT..                 VPROFIT =E= SUM(car, carprofit(car)*X(car));
RES_CONSTRAIN(materials) ..    SUM(car, A(car,materials)*X(car)) =L= b(materials);


* 5. DEFINE the MODEL from the EQUATIONS
MODEL MANUFACTURING /PROFIT, RES_CONSTRAIN/;
*Altnerative way to write (include all previously defined equations)
*MODEL PLANTING /ALL/;


* 6. SOLVE the MODEL
* Solve the PLANTING model using a Linear Programming Solver (see File=>Options=>Solvers)
*     to maximize VPROFIT
SOLVE MANUFACTURING USING LP MAXIMIZING VPROFIT;

* 6. CLick File menu => RUN (F9) or Solve icon and examine solution report in .LST file