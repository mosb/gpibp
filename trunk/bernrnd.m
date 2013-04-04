function r = bernrnd( p, varargin )
% Generates bernouli random variables

r = rand(varargin{:}) < p;
