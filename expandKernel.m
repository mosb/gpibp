function C = expandKernel( C, Zs, Z_new )
% Adds the new matrix Z_new to the Kernel C

L = size( C, 1 );
C(L+1,L+1) = 0;

fprintf('Expanding kernel: 000%%');
for i = 1:L
    % Currently using the simple hamming distance kernel. Can easily change
    % to another kernel type
    C(i,end) = 1 - hammingDistance( Zs{i}, Z_new );
    C(end,i) = C(i,end);
    fprintf('\b\b\b\b%3.3d%%', floor( i * 100 / L) );
end
fprintf('\n');
