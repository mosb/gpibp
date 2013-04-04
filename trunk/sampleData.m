function [X,Z,A] = sampleData( N, D, K, alpha, sigma2_A, sigma2_X )

%% Sample Z
Z = ibprnd( alpha, N, K );

%% Sample A
A = randn(K,D) * sqrt(sigma2_A);

%% Sample X
X = zeros(N,D);
for d = 1:D
    X(:,d) = Z * A(:,d) + randn(N,1)*sqrt(sigma2_X);
end

