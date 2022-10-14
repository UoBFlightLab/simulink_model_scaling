function flag = scale_simulink_model(model_file_name,block_name,N)
% SCALE_SIMULINK_MODEL Create a multi-agent Simulink model by scaling up a single-agent template
%
%   flag = SCALE_SIMULINK_MODEL(model_file_name,block_name,N)
%
% A new file containing the contents of the template 'model_file'. will be
% created.  Block 'block_name' will be replicated N times.  Its connections
% will be handled as follows:
%
% - Any input connected to a demultiplexer will have the demultiplexer
% scaled up to have N outputs.  The corresponding input of each newly
% replicated block will be connected to the respective output of the
% demultiplexer.
%
% - Any other inputs will be connected together back to the original source
% port.
%
% - Any output connected to a multiplexer will cause that mutliplexer to be
% scaled up to have N inputs.  The corresponding output of each newly
% replicated block will be connected to the respective input of the
% multiplexer.
%
% - Any other output will be left unconnected.
%
% See also SCALE_EXAMPLE GCS ADD_BLOCK ADD_LINE SET_PARAM


flag = 0;
model_name = 'new_model';
for kk=1:50
    if exist(model_name,'file')
        model_name = sprintf('new_model_%i',kk);
    else
        break
    end
end

h_model = new_system(model_name,'FromFile',model_file_name);
open_system(h_model);

src_block = [gcs '/' block_name];

pos = get_param(src_block,'Position');

blk_height = pos(4)-pos(2);
blk_width = pos(3)-pos(1);

for ii=2:N
    new_block_name = sprintf('%s/%s_%i',model_name,block_name,ii);
    add_block(src_block,new_block_name)
    set_param(new_block_name,'position',pos + [0 1 0 1]*1.2*(ii-1)*blk_height)
end

block_conns = get_param(src_block,'PortConnectivity');
for jj = 1:numel(block_conns)
    this_conn = block_conns(jj);
    this_port_num = str2num(block_conns(jj).Type);
    if ~isempty(this_port_num)
        if ~isempty(this_conn.SrcBlock)
            % it's an input
            other_blk = getfullname(this_conn.SrcBlock);
            other_blk_local = other_blk(1+find(other_blk=='/',1,'last'):end);
            other_port = this_conn.SrcPort+1;
            if strcmp(get_param(other_blk,'BlockType'),'Demux')
                % it's connected to a demux
                set_param(other_blk,'Outputs',num2str(N))
                for ii=2:N
                    target_port_id = sprintf('%s_%i/%i',block_name,ii,this_port_num);
                    source_port_id = sprintf('%s/%i',other_blk_local,ii);
                    add_line(model_name,source_port_id,target_port_id) %,'autorouting','on')
                end
            else
                for ii=2:N
                    target_port_id = sprintf('%s_%i/%i',block_name,ii,this_port_num);
                    source_port_id = sprintf('%s/%i',other_blk_local,other_port);
                    add_line(model_name,source_port_id,target_port_id) %,'autorouting','on')
                end
            end
        elseif ~isempty(this_conn.DstBlock)
            % it's an output - extract the details
            other_blk = getfullname(this_conn.DstBlock);
            other_blk_local = other_blk(1+find(other_blk=='/',1,'last'):end);
            if strcmp(get_param(other_blk,'BlockType'),'Mux')
                set_param(other_blk,'Inputs',num2str(N))
                for ii=2:N
                    source_port_id = sprintf('%s_%i/%i',block_name,ii,this_port_num);
                    target_port_id = sprintf('%s/%i',other_blk_local,ii);
                    add_line(model_name,source_port_id,target_port_id) %,'autorouting','on')
                end
            end
        end
    end
end