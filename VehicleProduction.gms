$ontext
CEE 6410 - Water Resources Systems Analysis
HW 4. Vehicle Production

THE PROBLEM:

How many trucks and sedans should a car manufacurer produce in a year: Data are as follows:


                         Trucks          Sedans
Fuel Tanks            2 per truck       1 per sedan         14,000 / year
Seats                 1 per truck       2 per sedan         18,000 / year
FWD                   1 per truck       0 per sedan          6,000 / year
Number of Vehicles   greater than 0    greater than 0       10,000 / year
Profit/plant              $100             $110

                Determine the optimal manufacturing for the two cars.

THE SOLUTION:
Uses General Algebraic Modeling System to Solve this Linear Program

Tyler Mindrum
a02355861@usu.edu
September 23, 2025
$offtext

* 1. DEFINE the SETS
SETS car cars manufactured /Truck, Sedan/
     materials materials used to produce vehicles /FuelTank, Seats, FWD, NumberVeh/;

* 2. DEFINE input data
PARAMETERS
   carprofit(car) Objective function coefficients ($ per car)
         /Truck 100,
         Sedan 110/
   b(materials) Right hand constraint values (per resource)
          /FuelTank 14000,
           Seats  18000,
           FWD  6000,
           NumberVeh  10000/;

TABLE A(car,materials) Left hand side constraint coefficients
                 FuelTank    Seats     FWD     NumberVeh
 Truck              2          1        1           1
 Sedan              1          2        0           1    ;


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