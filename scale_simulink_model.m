function flag = scale_simulink_model(block_name,N,common_inputs,demux_inputs,mux_outputs)

flag = 0;

model_name = 'new_model';

src_block = [gcs '/' block_name];

pos = get_param(src_block,'Position');

blk_height = pos(4)-pos(2);
blk_width = pos(3)-pos(1);

open_system(new_system(model_name));
for ii=1:N
    new_block_name = sprintf('%s/%s_%i',model_name,block_name,ii)
    add_block(src_block,new_block_name)
    set_param(new_block_name,'position',pos + [0 1 0 1]*1.2*(ii-1)*blk_height)
end

for ii=common_inputs
    source_block_name = sprintf('%s/src_%i',model_name,ii)
    add_block('simulink/Math Operations/Gain',source_block_name)
    set_param(source_block_name,'position',[pos(1) pos(2) pos(1)+50 pos(2)+50] - [1 0 1 0]*2.4*blk_width + [0 1 0 1]*1.2*(ii-1)*blk_height)
    source_port_id = sprintf('src_%i/1',ii);
    for jj=1:N
        target_port_id = sprintf('%s_%i/%i',block_name,jj,ii);
        add_line(model_name,source_port_id,target_port_id) %,'autorouting','on')
    end
end

for ii=mux_outputs
    mux_block_name = sprintf('%s/mux_%i',model_name,ii)
    add_block('simulink/Signal Routing/Mux',mux_block_name)
    set_param(mux_block_name,'position',[pos(1) pos(2) pos(1)+10 pos(2)+20*N] + [1 0 1 0]*2.4*blk_width + [0 1 0 1]*1.2*(ii-1)*10*N)
    set_param(mux_block_name,'Inputs',num2str(N))
    for jj=1:N
        source_port_id = sprintf('%s_%i/%i',block_name,jj,ii)
        target_port_id = sprintf('mux_%i/%i',ii,jj);
        add_line(model_name,source_port_id,target_port_id) %,'autorouting','on')
    end
end

for ii=demux_inputs
    demux_block_name = sprintf('%s/demux_%i',model_name,ii);
    add_block('simulink/Signal Routing/Demux',demux_block_name)
    set_param(demux_block_name,'position',[pos(1) pos(2) pos(1)+10 pos(2)+20*N] - [1 0 1 0]*2.4*blk_width + [0 1 0 1]*1.2*((ii-1)*10*N) + [0 1 0 1]*1.2*(blk_height*(numel(common_inputs)-1)))
    set_param(demux_block_name,'Outputs',num2str(N))
    for jj=1:N
        source_port_id = sprintf('demux_%i/%i',ii,jj);
        target_port_id = sprintf('%s_%i/%i',block_name,jj,ii);
        add_line(model_name,source_port_id,target_port_id) %,'autorouting','on')
    end
end
    
