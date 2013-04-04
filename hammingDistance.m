function d = hammingDistance( Z1, Z2 )

% Get the number of columns of Z 
[N,K] = size( Z1 );

% Check that the sizes are equal (which the following code depends on)
if ~all( [N,K] == size( Z2 ) )
    error('gbibp:argChk', 'Hamming Distance - Z1 and Z2 of unequal size' );
end

% Create a matrix of hamming distances from ith column of Z to jth column
% of Z'
distances = zeros( K );
for i = 1:K
    for j = 1:K
        distances(i,j) = sum( Z1(:,i) & ~Z2(:,j) | ~Z1(:,i) & Z2(:,j) );
    end
end

% Convert costs to scores
scores = max( distances(:) ) - distances;

% Maximum error on solution is e * n
e = 0.01;

% Run the auction
association = auction( scores, e );

d = 0;
for j = 1:K
    i = association( j );
    if i > 0
        d = d + distances( i, j );
    end
end
    