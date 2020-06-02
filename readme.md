# Assertion Implementation Progress

## Properties table

| prop. | Formalization  | Assert | Branch | Module |
|---|---|---|---|---|
| b1  | Read and write pointers are incremented when r_en/w_en are set | [✓](https://github.com/Archfx/assert_NoC/blob/f5228c866aec6c081659e0584900fe2e7e236e44/src_verilog/lib/flit_buffer.sv#L295-L310)  | [✓](https://github.com/Archfx/assert_NoC/blob/f5228c866aec6c081659e0584900fe2e7e236e44/src_verilog/lib/flit_buffer.sv#L333-L336) | [flit_buffer.sv](src_verilog/lib/flit_buffer.sv) |
| b2  | Age of packet is incremented in each cycle |  [✓](https://github.com/Archfx/assert_NoC/blob/f5228c866aec6c081659e0584900fe2e7e236e44/src_verilog/lib/flit_buffer.sv#L480-L489) | [✓](https://github.com/Archfx/assert_NoC/blob/f5228c866aec6c081659e0584900fe2e7e236e44/src_verilog/lib/flit_buffer.sv#L491-L492) | [flit_buffer.sv](src_verilog/lib/flit_buffer.sv) |
| b3 | Read and Write pointers are not incremented when the buffer is empty and full | [✓](https://github.com/Archfx/assert_NoC/blob/f5228c866aec6c081659e0584900fe2e7e236e44/src_verilog/lib/flit_buffer.sv#L318-L324) | [✓](https://github.com/Archfx/assert_NoC/blob/f5228c866aec6c081659e0584900fe2e7e236e44/src_verilog/lib/flit_buffer.sv#L333-L336) | [flit_buffer.sv](src_verilog/lib/flit_buffer.sv) |
|  b4  | Buffer can not be both full and empty at the same time |  [✓](https://github.com/Archfx/assert_NoC/blob/f5228c866aec6c081659e0584900fe2e7e236e44/src_verilog/lib/flit_buffer.sv#L325-L327) | [✓](https://github.com/Archfx/assert_NoC/blob/f5228c866aec6c081659e0584900fe2e7e236e44/src_verilog/lib/flit_buffer.sv#L325-L327) | [flit_buffer.sv](src_verilog/lib/flit_buffer.sv) |
|  b5  | Data that was read from the buffer was at some point in time written into the buffer | [✓](https://github.com/Archfx/assert_NoC/blob/f5228c866aec6c081659e0584900fe2e7e236e44/src_verilog/lib/flit_buffer.sv#L422-L425) | [✓](https://github.com/Archfx/assert_NoC/blob/f5228c866aec6c081659e0584900fe2e7e236e44/src_verilog/lib/flit_buffer.sv#L443-L444) | [flit_buffer.sv](src_verilog/lib/flit_buffer.sv) |
|  b6  | The same number of packets that were written in to the buffer can be read from the buffer | [✓](https://github.com/Archfx/assert_NoC/blob/f5228c866aec6c081659e0584900fe2e7e236e44/src_verilog/lib/flit_buffer.sv#L456-L458)  | [✓](https://github.com/Archfx/assert_NoC/blob/f5228c866aec6c081659e0584900fe2e7e236e44/src_verilog/lib/flit_buffer.sv#L460-L461) | [flit_buffer.sv](src_verilog/lib/flit_buffer.sv) |
|  r1  |  Route can issue at most one request | [✓](https://github.com/Archfx/assert_NoC/blob/f5228c866aec6c081659e0584900fe2e7e236e44/src_verilog/lib/route_mesh.sv#L116-L118) | [✓](https://github.com/Archfx/assert_NoC/blob/f5228c866aec6c081659e0584900fe2e7e236e44/src_verilog/lib/route_mesh.sv#L129-L130) | [route_mesh.sv](src_verilog/lib/route_mesh.sv) |
|  r2  | Route should issue a request whenever a data is valid |  [✓](https://github.com/Archfx/assert_NoC/blob/f5228c866aec6c081659e0584900fe2e7e236e44/src_verilog/lib/route_mesh.sv#L119-L123)  | [✓](https://github.com/Archfx/assert_NoC/blob/f5228c866aec6c081659e0584900fe2e7e236e44/src_verilog/lib/route_mesh.sv#L131-L132) | [route_mesh.sv](src_verilog/lib/route_mesh.sv) |
|  r3  | Desired routing algorithm should be correctly implemented |  [✓](https://github.com/Archfx/assert_NoC/blob/f5228c866aec6c081659e0584900fe2e7e236e44/src_verilog/lib/route_mesh.sv#L124-L126) | [✓](blob/f5228c866aec6c081659e0584900fe2e7e236e44/src_verilog/lib/route_mesh.sv#L133-L134) | [route_mesh.sv](src_verilog/lib/route_mesh.sv) |
|  a1  | Always at most one grant issued by the arbiter | ✓ | ✓ | [arbiter.sv](src_verilog/lib/arbiter.sv) |
|  a2  | As long as the request is available, it will eventually be granted by the arbiter within T cycles | ✓ | ✓ | [arbiter.sv](src_verilog/lib/arbiter.sv) |
|  a3  | No grant can be issued without a request | ✓ | ✓ | [arbiter.sv](src_verilog/lib/arbiter.sv) |
|  a4  | Time between two issued grants is always the same for all requests | ✓ | ✓ | [arbiter.sv](src_verilog/lib/arbiter.sv) |
|  m1  | During multiplexing output data shlould be equal to input data | ✓  | ✓ | [main_comp.sv](src_verilog/lib/main_comp.sv) |

## Combined Properties

| prop. | Formalization  | Comb. | 
|---|---|---|
| R1 | No packet loss inside the router | a2^b6^m1 |
| R2 | No packet duplication inside the router | a1^m1^r1  |
| R3 | No packet modification inside the router  | b1^b3^b4^b5^m1  |
| R4 | Packet that enteres the router will eventually leave the router at some point of time  | a1^a2^a3^b1^b2^b4^m1^r1^r2^r3 |
| R5 | Packet is correctly routed to the correct port according to the destination | r3^R2 |
| R6 | Age of the packet leaving the router will be at least Tmin | ✓  |
| R7 | Age of the packet leaving the router should not exceed Tmax  |  ✓  |


