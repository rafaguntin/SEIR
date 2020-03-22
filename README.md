**Goal**: learn how these models work. Not a credible quantiative exercise.

# SEIR model for Uruguay

SEIR models the flows of people between four states: susceptible (S), exposed (E), infected (I), and resistant (R). Metodological notes are based on [code](https://github.com/ECheynet/SEIR), [Wikipedia](https://en.wikipedia.org/wiki/Compartmental_models_in_epidemiology), [slides](http://indico.ictp.it/event/7960/session/3/contribution/19/material/slides/0.pdf) and [paper](https://www.medrxiv.org/content/10.1101/2020.02.16.20023465v1.full.pdf).

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
* <img src="https://render.githubusercontent.com/render/math?math=\delta">: inverse of the average quarantine time
* <img src="https://render.githubusercontent.com/render/math?math=(\lambda_0,\lambda_1)">: coefficients used in the time-dependant cure rate
* <img src="https://render.githubusercontent.com/render/math?math=(\kappa_0,\kappa_1)">: coefficient used in the time-dependant mortality rate

## ODE and solution

Each state evolves over time as follows:

![Image description](https://github.com/rafaguntin/SEIR/blob/master/model_diagram.png)

with equations

* <img src="https://render.githubusercontent.com/render/math?math=\frac{S_t}{\text{d}t} = -\alpha S_t - \beta \frac{I_t}{N} S_t ">
* <img src="https://render.githubusercontent.com/render/math?math=\frac{P_t}{\text{d}t} = \alpha S_t">
* <img src="https://render.githubusercontent.com/render/math?math=\frac{E_t}{\text{d}t} = -\gamma E_t %2B \beta \frac{S_t I_t}{N}">
* <img src="https://render.githubusercontent.com/render/math?math=\frac{I_t}{\text{d}t} = \gamma E_t - \delta I_t">
* <img src="https://render.githubusercontent.com/render/math?math=\frac{Q_t}{\text{d}t} = \delta I_t - \lambda_t  Q_t - \kappa_t Q_t">
* <img src="https://render.githubusercontent.com/render/math?math=\frac{R_t}{\text{d}t} = \lambda_t Q_t">
* <img src="https://render.githubusercontent.com/render/math?math=\frac{D_t}{\text{d}t} = \kappa_t Q_t">
with <img src="https://render.githubusercontent.com/render/math?math=\kappa_t = \kappa_0 exp(-\kappa_1 t)"> and <img src="https://render.githubusercontent.com/render/math?math=\lambda_t = \lambda_0 [1-exp(-\lambda_1 t)]">. We solve this using this [matlab code](https://www.mathworks.com/matlabcentral/fileexchange/74545-generalized-seir-epidemic-model-fitting-and-computation?s_tid=LandingPageTabfx) which uses the standard 4th order Runge-Kutta method.

## Parametrization for Uruguay

We assume the following values:
* <img src="https://render.githubusercontent.com/render/math?math=\E_0 = 280,\I_0 = \Q_0 = 140,\alpha = 0.15,\beta =0.96,\gamma=1/2,\delta=1/7,\kappa_0 = \lambda_0 = 0.03,\kappa_0 = \lambda_0 = 0.01"> 
* Based on confirmed cases in Uruguay through [03/22/2020](https://www.elobservador.com.uy/nota/gobierno-anuncio-que-hay-135-casos-de-coronavirus-2020321205120) and parameters for [China](https://www.medrxiv.org/content/10.1101/2020.02.16.20023465v1.full.pdf).

## Simulation for Uruguay 

Simulations [code](https://github.com/rafaguntin/SEIR/blob/master/uru_simul.m).

* Infected people each period (Q and I + Q)

<img src="https://github.com/rafaguntin/SEIR/blob/master/infected_uru.png" width="450" height="320">

* Stock of infected people (I + Q + R + D)

<img src="https://github.com/rafaguntin/SEIR/blob/master/stock_infected_uru.png" width="450" height="320">
