# SEIR model

SEIR models the flows of people between four states: susceptible (S), exposed (E), infected (I), and resistant (R).

## States and parameters

Population <img src="https://render.githubusercontent.com/render/math?math=(N)"> assumed to be constant and partitioned in 7 states:
* Suceptible <img src="https://render.githubusercontent.com/render/math?math=(S_t)">
* Insusceptibles <img src="https://render.githubusercontent.com/render/math?math=(P_t)">
* Exposed <img src="https://render.githubusercontent.com/render/math?math=(E_t)">
* Infectious <img src="https://render.githubusercontent.com/render/math?math=(I_t)">
* Quarantined <img src="https://render.githubusercontent.com/render/math?math=(Q_t)">
* Recovered <img src="https://render.githubusercontent.com/render/math?math=(R_t)">
* Dead <img src="https://render.githubusercontent.com/render/math?math=(D_t)">

8 parameters deterime the dynamics of the model:
* <img src="https://render.githubusercontent.com/render/math?math=\alpha">: protection rate
* <img src="https://render.githubusercontent.com/render/math?math=\beta">: infection rate
* <img src="https://render.githubusercontent.com/render/math?math=\gamma">: inverse of the average latent time
* <img src="https://render.githubusercontent.com/render/math?math=(\lambda_0,\lambda_1)">: coefficients used in the time-dependant cure rate
* <img src="https://render.githubusercontent.com/render/math?math=(\kappa_0,\kappa_1)">: coefficient used in the time-dependant mortality rate

## ODE

Each state evolves as follows:

* <img src="https://render.githubusercontent.com/render/math?math=S_t = A_t">
