function scale_example(N)
% SCALE_EXAMPLE  demonstrate automated scaling of Simulink model
%
%   SCALE_EXAMPLE produces an 18-agent simulation based on the template
%   model 'single_example.slx'
%
%   SCALE_EXAMPLE(N) produces an N-agent simulation
%
% This scaling script uses SCALE_SIMULINK_MODEL to create the N-agent model
% 
% See also SCALE_SIMULINK_MODEL SET_PARAM ADD_LINE ADD_BLOCK

if nargin<1
    N = 18
end

scale_simulink_model('single_example.slx','dynamics',N)

% set the value of the "frequency" block to suit the new problem size
set_param([gcs '/Constant'],'Value',mat2str(1:N))