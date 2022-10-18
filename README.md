# Simulink Model Scaling

Build multi-agent Simulink models from single agent templates.

## Reference

```
flag = SCALE_SIMULINK_MODEL(model_file_name,block_name,N)
```

A new file containing the contents of the template `model_file`. will be
created.  Block `block_name` will be replicated `N` times.  Its connections
will be handled as follows:

- Any input connected to a demultiplexer will have the demultiplexer
scaled up to have `N` outputs.  The corresponding input of each newly
replicated block will be connected to the respective output of the
demultiplexer.

- Any other inputs will be connected together back to the original source
port.

- Any output connected to a multiplexer will cause that mutliplexer to be
scaled up to have `N` inputs.  The corresponding output of each newly
replicated block will be connected to the respective input of the
multiplexer.

- Any other output will be left unconnected.

## Example

The code below is reproduced from the SCALE_EXAMPLE script provided.

```
scale_simulink_model('single_example.slx','dynamics',N)

% set the value of the "frequency" block to suit the new problem size
set_param([gcs '/Constant'],'Value',mat2str(1:N))
```

It takes the `single_sxample.slx` file pictured below as its template.

![](single_example.png)

Its immediate output is the model shown below.

![](scaled_example_raw.png)

This is pretty ugly, but tidies up OK with the auto-arrange tool, found in 
the Simulink Format menu.

![](scaled_example_layout.png)
