function [association, n] = auction( bids, epsilon )
% Auction algorithm for the assignment problem
% Chris Lloyd (c) 2013, christopher.lloyd@eng.ox.ac.uk
% See pages 333-336 of Design and Analysis of Modern Tracking Systems

% Step 1: Initialise: all observations are un-assigned, prices are zero
T = size( bids, 1 );
M = size( bids, 2 );

association = zeros( 1, M );
prices      = zeros( 1, T );

n = 0;
done = false;
while ~done
    done = true;
    for j = 1:M
        % Step 2: Select an observation j that is unassigned - is non
        % exists we're done
        if ~association( j )
            i_j  = 0;
            max1 = 0;
            max2 = 0; 
            % Step 3: Find the best track i_j for each observation j:
            % Find i_j such that bids(i_j,j) - prices(i_j) 
            % = max(i=1:N){ bids(i,j) - prices(i) }
            for i = 1:T
                if bids(i,j) ~= -Inf
                    tmp = bids( i, j ) - prices( i );
                    if tmp > epsilon
                        if tmp > max1
                            max2 = max1;
                            max1 = tmp;
                            i_j  = i;
                        elseif tmp > max2
                            max2 = tmp;
                        end
                    end
                end
            end
            if i_j
                % Step 4: Unassign the observation previously assigned to
                % i_j (if any) and assign track i_j observation j
                association( association == i_j ) = 0;
                association( j )                  = i_j;
                % Step 5: Set the price of track i_j to the level at which
                % observation j is almost happy 
                % prices(i_j) := prices(i_j) +  y_i + epsilon, y_i is the 
                % difference between the best and second best bid
                % values for j
                y_i           = max1 - max2;
                prices( i_j ) = prices( i_j ) + y_i + epsilon;
                % Step 6: Goto step 2
                done = false;
                % Count the number of times we incremented by epsilon
                n = n + 1;
            end
        end
    end
end
