function scale_example(N)
% SCALE_EXAMPLE  demonstrate automated scaling of Simulink model
%
%   SCALE_EXAMPLE produces an 18-agent simulation based on the template
%   model 'single_example.slx'
%
%   SCALE_EXAMPLE(N) produces an N-agent simulation
%
% This scaling script uses SCALE_SIMULINK_MODEL to create the N-agent model
% and then connects various other blocks to the new inputs and outputs.
%
% See also SCALE_SIMULINK_MODEL CONNECT_COMMON_INPUT CONNECT_DEMUX_INPUT
% CONNECT_MUX_OUTPUT

if nargin<1
    N = 18
end

% open the single agent system to be used as the template
open_system('single_example')

% make multiple copies of the 'dynamics' block
block_name = 'dynamics';
common_inputs = [1]; % all blocks' input 1 port will connect to a common constant source
demux_inputs = [2]; % each input 2 port will be connected to respective output on a demux
mux_outputs = [1]; % all output 1 ports will be muxed together

scale_simulink_model(block_name,N,common_inputs,demux_inputs,mux_outputs)

% attach a clock to the common input feeding port 1 inputs
clock_name = connect_common_input(1,'simulink/Sources/Clock',1)

% attach a constant to the demux feeding port 2 inputs
const_name = connect_demux_input(2,'simulink/Sources/Constant',1)
set_param([gcs '/' const_name],'Value',mat2str(1:N))

% attach a scope to the mux combining port 1 outputs
scope_name = connect_mux_output(1,'simulink/Sinks/Scope',1)