`include "timescale.v"
module tb_flit_buffer;

reg     [Fw-1 :0]    din             ;
reg     [V-1 :0]     vc_num_wr       ;
reg     [V-1 :0]     vc_num_rd       ;
reg                  wr_en           ;
reg                  rd_en           ;
wire    [Fw-1 :0]    dout            ;
wire    [V-1 :0]     vc_not_empty    ;
reg                  reset           ;
reg                  clk             ;
reg     [V-1 :0]     ssa_rd          ;

flit_buffer uut (
    .din             (    din             ),
    .vc_num_wr       (    vc_num_wr       ),
    .vc_num_rd       (    vc_num_rd       ),
    .wr_en           (    wr_en           ),
    .rd_en           (    rd_en           ),
    .dout            (    dout            ),
    .vc_not_empty    (    vc_not_empty    ),
    .reset           (    reset           ),
    .clk             (    clk             ),
    .ssa_rd          (    ssa_rd          )
);

parameter PERIOD = 10;

initial begin
    $dumpfile("db_tb_flit_buffer.vcd");
    $dumpvars(0, tb_flit_buffer);
    clk = 1'b0;
    #(PERIOD/2);
    forever
        #(PERIOD/2) clk = ~clk;
end

endmodule
