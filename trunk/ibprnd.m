function Z = ibprnd( alpha, N, K )
% Sample from the IBP for a finite matrix size K

Z = zeros(N,K);
mu = betarnd(alpha/K,1,[1 K]);

for k = 1:K
    Z(:,k) = bernrnd( mu(k), [N,1] );
end
