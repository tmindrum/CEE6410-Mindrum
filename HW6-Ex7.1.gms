$ontext
CEE 6410 - Water Resources Systems Analysis
MILP of Problem 7.1 from Bishop Et Al Text (https://digitalcommons.usu.edu/ecstatic_all/76/)

A farmer plans to develop water for irrigation, he is considering a gravity diversion or a pump from a lower river diversion
Seasonal flow in demand is given in the following table:

Season, t       River Inflow, Q (acft)      Irrigation Demand, (acft/acre)
    1                   600                             1.0
    2                   200                             3.0

It was assumed that there are only two possible sizes of reservoir:
- A high dam that has a capacity of 700 acft, with a capital cost of $10,000/yr
- A low dam that has a capacity of 300 acft, with a capital cost of $6,000/yr

If a pump is built it has a fixed capacity of 2.2 acft/day, with a capital cost of $8,000/yr and an operation cost of $20/acft.

THE SOLUTION:
Uses Mixed Integer Linear Programing to Solve this Problem

Tyler Mindrum
a02355861@usu.edu
October 20, 2025
$offtext

* 1. DEFINE the SETS
SETS wss water supply sources /div "diversion from reservoir", pump "pump from river"/
     lev source size /lev0 "zero", lev1 "small", lev2 "large"/
     t time in seasons /s1*s2/;


* 2. DEFINE the variables
VARIABLES I(wss,lev) decision to build project from source (1=yes 0=no)
          X(wss,t) vol water provided by source (acft per season)
          RESREL(t) Reservoir release to river (acft per season)
          STORAGE(t) Reservoir storage vol (acft)
          AREA Area irrigated (acre)
          TBEN Total net benefits minus capital and operating costs ($);

BINARY VARIABLES I;
* Non-negativity constraints
POSITIVE VARIABLES X, RESREL, STORAGE;


* 3. DEFINE input data
TABLE CapCost(wss,lev) capital cost ($ to build)
          lev1      lev2
div       6000     10000
pump      8000         0;

PARAMETER
    OpCost(wss) operating cost ($ per acft)
                /div      0,
                 pump    20/ ;

TABLE MaxCap(wss,lev) Max capacity of source when built (acft per season)
           lev1    lev2
     div    300     700;

*Maximum capacity for the pump converted from daily to seasonal
MaxCap("pump","lev1") = 2.2*365/card(t);

PARAMETERS
    RiverQIn(t) River inflow (acft)
                 /s1 600, s2 200/
    IrrDemand(t) Irrigation demand (acft per acre)
                 /s1 1.0, s2 3.0/
    IStorage Initial reservoir storage (acre)
                 /0.5/
    Baseflow River baseflow (acft)
                 /2/
    Rev  Revenue from irrigation ($ per year per acre)
                 /300/;

*Convert daily baseflow to seasonal baseflow
Baseflow = Baseflow*365/card(t);


* 4. COMBINE variables and data in equations
EQUATIONS
    NetBen               Net benefits ($) and obj function value
    AToSupply(t)         Area to supply (acre)
    PumpCap(t)           Pumping capacity (acft per season)
    ResCapacity(t)       Reservoir capacity (acft)
    OneProjSize(wss)     Can only implement one project size (#)
    RiverMB(t)           River mass balance ds of reservoir (acft)
    ResMB(t)             Reservoir mass balance (acft);


NetBen..                 TBEN =E= Rev*AREA - SUM(wss,SUM(lev,CapCost(wss,lev)*I(wss,lev)) + SUM(t,OpCost(wss)*X(wss,t)));
AToSupply(t)..           AREA =L= SUM(wss,X(wss,t))/IrrDemand(t);
PumpCap(t)..             X("pump",t) =L= SUM(lev,MaxCap("pump",lev)*I("pump",lev));
ResCapacity(t)..         STORAGE(t) =L= SUM(lev,MaxCap("div",lev)*I("div",lev));
RiverMB(t)..             X("pump",t) =L= RESREL(t) + Baseflow;
OneProjSize(wss)..       SUM(lev,I(wss,lev)) =L= 1;
ResMB(t)..               STORAGE(t) =E= RiverQIn(t) - RESREL(t) - X("div",t) +  IStorage*SUM(lev,MaxCap("div",lev)*I("div",lev))$(ord(t) eq 1)  +  STORAGE(t-1)$(ord(t) gt 1);

* 5. DEFINE the MODEL from the EQUATIONS
MODEL ResDesign /ALL/;

* 6. Solve the Model as a LP
SOLVE ResDesign USING MIP Maximizing TBEN;
