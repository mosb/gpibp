function lpz = log_P_Z( Z, alpha )
% Computes the log likelihood of the binary matrix Z under the IBP prior
% with parameter alpha

[N,K] = size(Z);

alphaOverK = alpha/K;

lpz = K * log(alphaOverK);
for k = 1:K

    m_k = sum(Z(:,k));
    lpz = lpz + gammaln( m_k + alphaOverK ) + gammaln( N - m_k + 1 ) ...
        - gammaln( N + 1 + alphaOverK );
    
end

