function sink_block_name = connect_mux_output(N, sink_block_type, sink_block_port)

mux_block_port_name = sprintf('mux_%i/1',N)
sink_block_name = sprintf('common_sink_%i',N)
sink_block_port_name = sprintf('common_sink_%i/%i',N,sink_block_port)

add_block(sink_block_type,[gcs '/' sink_block_name])
add_line(gcs,mux_block_port_name,sink_block_port_name)