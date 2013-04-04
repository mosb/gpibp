function lpz = log_P_Z_X( Z, X, sigma2_A, sigma2_X )

[N,D] = size( X );

lpz = 0;
for d = 1:D
    % Compute the sum of negative negative log-likelihoods
    lpz = lpz - mvnlike(  X(:,d), zeros(N,1), Z*Z'*sigma2_A + eye(N)*sigma2_X );
end

