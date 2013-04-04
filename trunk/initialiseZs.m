function [Zs, hashs] = initialiseZs( alpha, N, K, GP_init, GP_initCheat, Z_true )

Zs    = cell( 1, GP_init );
hashs = zeros( 1, GP_init );

if GP_initCheat  == -1
    % Don't cheat
    [Zs1,hash1] = leftOrderedForm( ibprnd( alpha, N, K ) );
else
    % Cheat a little/a lot
    Zs1 = Z_true;
    for i = 1:GP_initCheat
        n = ceil( rand * N );
        k = ceil( rand * K );
        Zs1( n, k ) = ~Zs1( n, k );
    end
    [Zs1,hash1] = leftOrderedForm( Zs1 );
end

Zs{1}    = Zs1;
hashs(1) = hash1;

for i = 2:GP_init
    [Zs{i}, hashs(i)] = leftOrderedForm( ibprnd( alpha, N, K ) );
end


