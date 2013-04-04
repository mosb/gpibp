
clc
clear all

% Number of rows of the matrix
D  = 100;
% Number of columns of Z
K  = 900;
% Number of columns of Z' (N.B. choose K' < K)
Kp = 800;

if( Kp > K )
    fprintf('Choose Kp <= K\n' )
end

% Fraction of 1s in each matrix
onesFraction = 1/10;

% Initialise Z randomly
Z  = rand( D, K ) < onesFraction;
% Initialise Z' randomly
Zp = rand( D, Kp ) < onesFraction;

% Create a matrix of hamming distances from ith column of Z to jth column
% of Z'
distances = zeros( K, Kp );
for i = 1:K
    for j = 1:Kp
        distances(i,j) = sum( Z(:,i) & ~Zp(:,j) | ~Z(:,i) & Zp(:,j) );
    end
end

% Convert costs to scores
scores = max( distances(:) ) - distances;

% Maximum error on solution is e * n
e = 0.01;

% Run the auction
tic
[association,n] = auction( scores, e );
aucTime = toc;

% Find the unassociated columns of Z
unassoc = setdiff( 1:K, association );
association = [association, unassoc];

auctionDistance1 = 0;
for j = 1:Kp
    i = association( j );
    if i > 0
        auctionDistance1 = auctionDistance1 + distances( i, j );
    end
end
for i = unassoc
    auctionDistance1 = auctionDistance1 + sum( Z(:,i) );
end

% Check that the distance matches the re ordered version of Z

% Padd out Zp with some extra zeros
K_diff = K - Kp;
Zp = [Zp zeros(D, K_diff)];

% Measure the hamming distance
Z_auction   = Z( :, association );
auctionDistance2 = sum( Z_auction(:) & ~Zp(:) | ~Z_auction(:) & Zp(:) );

% Check the two ways of measuring the distance agree
if auctionDistance1 ~= auctionDistance2
    fprintf('WARNING!!! - Auction distances don''t match\n');
end

fprintf('Auction time = %f, distance = %i, n = %i\n', ...
    aucTime, auctionDistance1, n );

figure(1)
spy( Z )
figure(2)
spy( Zp );
figure(3)
spy( Z_auction );

% Brute force check for small values of K
if K < 11
    fprintf('Brute force check ...');
    bruteDistance = Inf;
    brutePerm     = [];
    numBest       = 1;
    ps            = perms( 1:K );
    for i = 1:size( ps, 1 )
        Zb  = Z( :, ps(i,:) );
        dist = sum( Zp(:) & ~Zb(:) | ~Zp(:) & Zb(:) );
        if dist < bruteDistance
            bruteDistance = dist;
            brutePerm     = ps(i,:);
            numBest       = 1;
        elseif dist == bruteDistance
            numBest = numBest + 1;
        end
    end
    fprintf('done\n');
    if auctionDistance1 ~= bruteDistance
        fprintf('WARNING!!! - Auction didn''t find optimal\n');
    end
end


    
    