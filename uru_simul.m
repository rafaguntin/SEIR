%% Simulations

clearvars;close all;clc;

% Time definition
dt = 1; % time step
time1 = datetime(2020,03,22,0,0,0):dt:datetime(2020,12,31,0,0,0);
N = numel(time1);
t = [0:N-1].*dt;

% parametrization Uruguay

Npop= 3500000; % population (60 millions)
Q0 = 140; % Initial number of infectious that have been quarantined
I0 = 140; % Initial number of infectious cases non-quarantined
E0 = 280; % Initial number of exposed
R0 = 1; % Initial number of recovers
D0 = 0; % Initial number of deads
alpha = 0.15; %  protection rate
beta = .96; %  infection rate
gamma= 1/2; % inverse of average latent time
delta= 1/7; % inverse of average quarantine time
Lambda01 = [0.03 0.02]; % cure rate (time dependant)
Kappa01 =  [0.03 0.02]; % mortality rate (time dependant)

[S,E,I,Q,R,D,P] = SEIQRDP(alpha,beta,gamma,delta,Lambda01,Kappa01,Npop,E0,I0,Q0,R0,D0,t);

lambda = Lambda01(1)*(1-exp(-t*Lambda01(2)));
kappa = Kappa01(1)*exp(-t*Kappa01(2));

C = I + Q + R + D; % all cases

ftsize = 13;
set(groot, 'DefaultAxesTickLabelInterpreter','latex'); 
set(groot, 'DefaultLegendInterpreter','latex');
set(groot, 'DefaultAxesFontSize',ftsize);

% infected at each t

figure(1)
plot(t(1:101),I(1:101)+Q(1:101),'k-','LineWidth',2,'Color',[0/256,165/256,120/256]) 
hold on;
plot(t(1:101),Q(1:101),'k-','LineWidth',2,'Color',[255/256,165/256,0/256]) 
hold off;
grid on;
ylabel('people','FontSize',ftsize,'interpreter','latex')
xlabel('days','FontSize',ftsize,'interpreter','latex')
legend('Infected','Quarentined Infected', 'data','Location','Northeast' );
grid on;

fig = gcf;
fig.PaperPositionMode = 'auto'
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];  
print( gcf, '-dpng', '-r300', 'infected_uru');

% stock of infected people at each t

figure(2)
plot(t(1:101),C(1:101),'k-','LineWidth',2,'Color',[120/256,0/256,0/256]) 
hold off;
grid on;
ylabel('people','FontSize',ftsize,'interpreter','latex')
xlabel('days','FontSize',ftsize,'interpreter','latex')
legend('Stock Infected','Quarentined Infected', 'data','Location','Southeast' );
grid on;

fig = gcf;
fig.PaperPositionMode = 'auto'
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];  
print( gcf, '-dpng', '-r300', 'stock_infected_uru');
