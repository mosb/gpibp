%% Main function for GP-IBP

close all
clear all

%% Model Parameters

% Alpha parameter of the IBP
alpha = 20;

% Maximum number of columns of the IBP
K_max = 100;

% Dimensionality of the Data
D = 10;

% Number of sample points
N = 100;

% Observation Noise (variance)
sigma2_X = 0.01;

% Latent variable distribution (variance)
sigma2_A = 0.1;

%% Algorithm parameters

% Maximum number of points in the GP
GP_max = 1000;

% Number of points to start the GP
GP_init = 2;

% GP initialisation cheat mode initial solution contains matrix 
% $GP_initCheat$ bit flips from the true solution. -1 to turn cheat off.
GP_initCheat = 10;

% maximum number of iterations
maximumIterations = 10;

%% Data Structures

% GP Kernel
C = [];

% GP mean function
u = [];

% All the Binary matrices we've evaluated so far
Zs = {}; %#ok<NASGU>

% All the log-likelihoods we've evaluated so far
LL = [];

%% Data Generation
[X,Z_true,A_true] = sampleData( N,D,K_max, alpha,sigma2_A,sigma2_X );

%% Initialisation

% Generate Initial Zs
Zs = initialiseZs( alpha, N,K_max, GP_init, GP_initCheat, Z_true );
% Add the initial Zs to the Kernel
C = expandKernel( C, {}, Zs{1} );
for i = 2:length( Zs )
    fprintf('Adding sample %i to kernel\n', i);
    C = expandKernel( C, Zs(1:(i-1)), Zs{i} );
end

for i = 1:length( Zs )
    LL(i) = log_P_Z_X( Zs{i}, X, sigma2_A, sigma2_X ) ... 
        + log_P_Z( Zs{i}, alpha ); %#ok<SAGROW>
end

%% Main loop

for it = 1:maximumIterations

    % To test the rest of the code
    Z_new = ibprnd( alpha, N, K_max );
    
    % Expand the kernel with the new matrix Z
    fprintf('Adding sample %i to kernel\n', length(Zs) );
    C = expandKernel( C, Zs, Z_new );

    % Compute the log likelihood of the new matrix
    LL(end+1) = log_P_Z_X( Z_new, X, sigma2_A, sigma2_X ) ...
        + log_P_Z( Z_new, alpha ); %#ok<SAGROW>
    
    % Add the new matrix to the store of matrices
    Zs{end+1} = Z_new; %#ok<SAGROW>
    
end

%%















