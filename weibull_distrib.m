%% How to compute the Weibull distribution parameters
% from a wind speed time series
% Robin Roche, UTBM, 2013 - robin.roche/at/utbm.fr

% For more information about the Weibull distribution, see:
% http://en.wikipedia.org/wiki/Weibull_distribution

% The attached file (wind_speed.xls) contains a wind speed time series,
% with a time resolution of 10 minutes over several months.

clear all
close all
clc


%% EXTRACT AND PLOT RAW DATA

% Extract wind speed data from a file
v = xlsread('wind_speed');

% Plot the measured wind speed
figure
plot(v)
title('Wind speed time series');
xlabel('Measurement #');
ylabel('Wind speed [m/s]');


%% PROCESS DATA

% Remove nil speed data (to avoid infeasible solutions in the following)
v(find(v==0)) = [];

% Extract the unique values occuring in the series
uniqueVals = unique(v);

% Get the number of unique values
nbUniqueVals = length(uniqueVals);

% Find the number of occurences of each unique wind speed value
for i=1:nbUniqueVals
    nbOcc = v(find(v==uniqueVals(i)));
    N(i) = length(nbOcc);
end

% Get the total number of measurements
nbMeas = sum(N);

% To take into account the measurement resolution
% (i.e., a measured wind speed of 2.0 m/s may actually correspond to a
% real wind speed of 2.05 or 1.98 m/s), compute the delta vector which
% contains the difference between two consecutive unique values
delta(1) = uniqueVals(1);
for i=2:(nbUniqueVals)
    delta(i) = uniqueVals(i) - uniqueVals(i-1);
end

% Get the frequency of occurence of each unique value
for i=1:nbUniqueVals
    prob(i) = N(i)/(nbMeas*delta(i));
end

% Get the cumulated frequency
freq = 0;
for i=1:nbUniqueVals
    freq = prob(i)*delta(i) + freq;
    cumFreq(i) = freq;
end


%% PLOT THE RESULTING DISTRIBUTION

% Plot the distribution
figure
subplot(2,1,1);
plot(uniqueVals,prob)
title('Distribution extracted from the time series');
xlabel('Wind speed [m/s]');
ylabel('Probability');

% Plot the cumulative distribution
subplot(2,1,2);
plot(uniqueVals,cumFreq)
title('Cumulative distribution extracted from the time series');
xlabel('Wind speed [m/s]');
ylabel('Cumulative probability');


%% EXTRACT THE PARAMETERS USING A GRAPHICAL METHOD

% See the following references for more explanations:
% - Akdag, S.A. and Dinler, A., A new method to estimate Weibull parameters
% for wind energy applications, Energy Conversion and Management,
% 50 :7 1761–1766, 2009
% - Seguro, J.V. and Lambert, T.W., Modern estimation of the parameters of
% the Weibull wind speed distribution for wind energy analysis, Journal of
% Wind Engineering and Industrial Aerodynamics, 85 :1 75–84, 2000


% Linearize distributions (see papers)
ln = log(uniqueVals);
lnln = log(-log(1-cumFreq));

% Check wether the vectors contain inifinite values, if so, remove them
test = isinf(lnln);
for i=1:nbUniqueVals
    if (test(i)==1)
        ln(i)= [];
        lnln(i)= [];
    end
end

% Extract the line parameters (y=ax+b) using the polyfit function
params = polyfit(ln,lnln',1);
a = params(1);
b = params(2);
y=a*ln+b;

% Compare the linealized curve and its fitted line
figure
plot(ln,y,'b',ln,lnln,'r')
title('Linearized curve and fitted line comparison');
xlabel('x = ln(v)');
ylabel('y = ln(-ln(1-cumFreq(v)))');

% Extract the Weibull parameters c and k
k = a
c = exp(-b/a)


%% CHECK RESULTS

% Define the cumulative Weibull probability density function
% F(V) = 1-exp(-((v/c)^k)) = 1-exp(-a2), with a1 = v/c, a2 = (v/c)^k
a1 = uniqueVals/c;
a2 = a1.^k;
cumDensityFunc = 1-exp(-a2); 

% Define the Weibull probability density function
%f(v)=k/c*(v/c)^(k-1)*exp(-((v/c)^k))=k2*a3.*exp(-a2), 
% with  k2 = k/c, a3 = (v/c)^(k-1)
k1 = k-1;
a3 = a1.^k1;
k2 = k/c;
densityFunc = k2*a3.*exp(-a2);  

% Plot and compare the obtained Weibull distribution with the frequency plot
figure
subplot(2,1,1);
plot(uniqueVals,prob,'.',uniqueVals,densityFunc, 'r')
title('Weibull probability density function');
xlabel('v');
ylabel('f(v)');

% Same for the cumulative distribution
subplot(2,1,2);
plot(uniqueVals,cumFreq,'.',uniqueVals,cumDensityFunc, 'r')
title('Cumulative Weibull probability density function');
xlabel('v');
ylabel('F(V)');



