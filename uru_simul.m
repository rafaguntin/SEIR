%% Simulations

clearvars;close all;clc;

addpath('/Users/rafaelguntin/Dropbox/PhD - Year IV/covid19/SEIR/ECheynet-SEIR-c733b29');

% Time definition
dt = 1; % time step
time1 = datetime(2020,03,22,0,0,0):dt:datetime(2020,12,31,0,0,0);
N = numel(time1);
t = [0:N-1].*dt;

%% baseline

% parametrization Uruguay

Npop= 3500000; % population (3,500,000)
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

% load data

T = readtable('total-cases-covid-19.csv');

C_obs = T.cases(2:end)';
C_obs = C_obs*2;
t_obs = 1:length(C_obs);
t_obs = t_obs + 1;

[S,E,I,Q,R,D,P] = SEIQRDP(alpha,beta,gamma,delta,Lambda01,Kappa01,Npop,E0,I0,Q0,R0,D0,t);

lambda = Lambda01(1)*(1-exp(-t*Lambda01(2)));
kappa = Kappa01(1)*exp(-t*Kappa01(2));

C = I + Q + R + D; % all cases

ftsize = 20;
set(groot, 'DefaultAxesTickLabelInterpreter','latex'); 
set(groot, 'DefaultLegendInterpreter','latex');
set(groot, 'DefaultAxesFontSize',ftsize);

% infected at each t

figure(1)
plot(t(1:101)+10,I(1:101)+Q(1:101),'k-','LineWidth',6,'Color',[0/256,165/256,120/256]) 
hold on;
plot(t(1:101)+10,Q(1:101),'k-','LineWidth',6,'Color',[255/256,165/256,0/256]) 
hold off;
grid on;
ylabel('people','FontSize',ftsize,'interpreter','latex')
xlabel('days from 1st case','FontSize',ftsize,'interpreter','latex')
legend('Infected','Quarentined Infected', 'data','Location','Northeast' );
xlim([0 120]);
grid on;

fig = gcf;
fig.PaperPositionMode = 'auto'
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3)*.25 fig_pos(4)*.25];  
print( gcf, '-dpng', '-r300', 'infected_uru');

% stock of infected people at each t

figure(2)
plot(t(1:101)+10,C(1:101),'k-','LineWidth',6,'Color',[120/256,0/256,0/256]) 
hold on;
plot(t_obs,C_obs,'o','Color',[120/256,120/256,120/256]) 
hold off;
grid on;
ylabel('people','FontSize',ftsize,'interpreter','latex')
xlabel('days from 1st case','FontSize',ftsize,'interpreter','latex')
legend('Stock Infected','observed (x2)', 'Location','Southeast' );
xlim([0 120]);
grid on;

fig = gcf;
fig.PaperPositionMode = 'auto'
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3)*.25 fig_pos(4)*.25];  
print( gcf, '-dpng', '-r300', 'stock_infected_uru');

%% alphas robustness

Npop= 3500000; % population (3,500,000)
Q0 = 140; % Initial number of infectious that have been quarantined
I0 = 140; % Initial number of infectious cases non-quarantined
E0 = 280; % Initial number of exposed
R0 = 1; % Initial number of recovers
D0 = 0; % Initial number of deads
alpha = [0.01:.01:0.18]; %  protection rate
beta = 1.2; %  infection rate
gamma= 1/2; % inverse of average latent time
delta= 1/7; % inverse of average quarantine time
Lambda01 = [0.03 10000000]; % cure rate (fixed)
Kappa01 =  [0.01 0]; % mortality rate (fixed)

C = zeros(length(t),length(alpha));
Inf = zeros(length(t),length(alpha));
QInf = zeros(length(t),length(alpha));

for i=1:length(alpha)
[S,E,I,Q,R,D,P] = SEIQRDP(alpha(i),beta,gamma,delta,Lambda01,Kappa01,Npop,E0,I0,Q0,R0,D0,t);
C(:,i) = I + Q + R + D; % all cases
Inf(:,i) = I + Q;
QInf(:,i) = Q;
end

C = C./Npop;
Inf = Inf./Npop;

figure(3)
for i = 1:length(alpha)-1
plot(t(1:101)+11,C(1:101,i),'k-','LineWidth',2,'Color',[i/length(alpha)*220/256,i/length(alpha)*220/256,i/length(alpha)*220/256]) 
hold on;
end
plot(t(1:101)+11,C(1:101,end),'k-','LineWidth',2,'Color',[220/256,220/256,220/256]) 
hold off;
grid on;
ylabel('people','FontSize',ftsize,'interpreter','latex')
xlabel('days from 1st case','FontSize',ftsize,'interpreter','latex')
legend(strcat('max alpha =', num2str(max(alpha))),strcat('min alpha =', num2str(min(alpha))),'Location','Northwest' );
grid on;

fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3)*.25 fig_pos(4)*.25];  
print( gcf, '-dpng', '-r300', 'alpha_simul_1');

figure(4)
for i = 1:length(alpha)-1
plot(t(1:101)+11,Inf(1:101,i),'k-','LineWidth',2,'Color',[i/length(alpha)*220/256,i/length(alpha)*220/256,i/length(alpha)*220/256]) 
hold on;
end
plot(t(1:101)+11,Inf(1:101,end),'k-','LineWidth',2,'Color',[220/256,220/256,220/256]) 
hold off;
grid on;
ylabel('people','FontSize',ftsize,'interpreter','latex')
xlabel('days from 1st case','FontSize',ftsize,'interpreter','latex')
legend(strcat('max alpha =', num2str(max(alpha))),strcat('min alpha =', num2str(min(alpha))),'Location','Northeast' );
grid on;

fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3)*.25 fig_pos(4)*.25];  
print( gcf, '-dpng', '-r300', 'alpha_simul_2');


%% high and low beta

% parametrization Uruguay

Npop= 3500000; % population (3,500,000)
Q0 = 140; % Initial number of infectious that have been quarantined
I0 = 140; % Initial number of infectious cases non-quarantined
E0 = 280; % Initial number of exposed
R0 = 1; % Initial number of recovers
D0 = 0; % Initial number of deads
alpha = 0.15; %  protection rate
beta = [.5,.96]; %  infection rate
gamma= 1/2; % inverse of average latent time
delta= 1/7; % inverse of average quarantine time
Lambda01 = [0.03 0.02]; % cure rate (time dependant)
Kappa01 =  [0.03 0.02]; % mortality rate (time dependant)

C = zeros(length(t),length(alpha));
Inf = zeros(length(t),length(alpha));
QInf = zeros(length(t),length(alpha));

for i=1:length(beta)
[S,E,I,Q,R,D,P] = SEIQRDP(alpha,beta(i),gamma,delta,Lambda01,Kappa01,Npop,E0,I0,Q0,R0,D0,t);
C(:,i) = I + Q + R + D; % all cases
Inf(:,i) = I + Q;
QInf(:,i) = Q;
end

ftsize = 20;
set(groot, 'DefaultAxesTickLabelInterpreter','latex'); 
set(groot, 'DefaultLegendInterpreter','latex');
set(groot, 'DefaultAxesFontSize',ftsize);

% infected at each t

figure(5)
plot(t(1:101)+10,Inf(1:101,2),'k-','LineWidth',6,'Color',[0/256,165/256,120/256]) 
hold on;
plot(t(1:101)+10,QInf(1:101,2),'k-','LineWidth',6,'Color',[255/256,165/256,0/256]) 
hold on;
plot(t(1:101)+10,Inf(1:101,1),'k--','LineWidth',6,'Color',[0/256,165/256,120/256]) 
hold on;
plot(t(1:101)+10,QInf(1:101,1),'k--','LineWidth',6,'Color',[255/256,165/256,0/256]) 
hold off;
grid on;
ylabel('people','FontSize',ftsize,'interpreter','latex')
xlabel('days from 1st case','FontSize',ftsize,'interpreter','latex')
legend('Infected','Quarentined Infected', 'Inf low $\beta$','QInf low $\beta$','Location','Northeast' );
xlim([0 120]);
grid on;

fig = gcf;
fig.PaperPositionMode = 'auto'
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3)*.25 fig_pos(4)*.25];  
print( gcf, '-dpng', '-r300', 'infected_uru_beta');

% stock of infected people at each t

figure(6)
plot(t(1:101)+10,C(1:101,2),'k-','LineWidth',6,'Color',[120/256,0/256,0/256]) 
hold on;
plot(t(1:101)+10,C(1:101,1),'k--','LineWidth',6,'Color',[120/256,0/256,0/256]) 
hold on;
plot(t_obs,C_obs,'o','Color',[120/256,120/256,120/256]) 
hold off;
grid on;
ylabel('people','FontSize',ftsize,'interpreter','latex')
xlabel('days from 1st case','FontSize',ftsize,'interpreter','latex')
legend('Stock Infected','low $\beta$','observed (x2)', 'Location','Southeast' );
xlim([0 120]);
ylim([0 max(C(:,2))*1.02]);
grid on;

fig = gcf;
fig.PaperPositionMode = 'auto'
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3)*.25 fig_pos(4)*.25];  
print( gcf, '-dpng', '-r300', 'stock_infected_uru_beta');

