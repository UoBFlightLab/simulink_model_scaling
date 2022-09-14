function src_block_name = connect_demux_input(N, src_block_type, src_block_port)

demux_block_port_name = sprintf('demux_%i/1',N)
src_block_name = sprintf('common_src_%i',N)
src_block_port_name = sprintf('common_src_%i/%i',N,src_block_port)

add_block(src_block_type,[gcs '/' src_block_name])
add_line(gcs,src_block_port_name,demux_block_port_name)