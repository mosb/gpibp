function [Z, hash] = leftOrderedForm( Z )

[N,K] = size( Z );

B = 2.^((N-1):-1:0)';

b = zeros( 1, K );

for k = 1:K
    b( k ) = sum( Z(:,k) .* B );   
end

[~,lo] = sort( b, 'descend' );

Z = Z(:, lo);

hash = sum( b );
