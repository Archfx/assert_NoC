module one_hot_mux 
    (
        input [IN_WIDTH-1       :0] mux_in,
        output[OUT_WIDTH-1  :0] mux_out,
        input[SEL_WIDTH-1   :0] sel

    );
    
    parameter   IN_WIDTH      = 20;
    parameter   SEL_WIDTH =   5;
    parameter   OUT_WIDTH = IN_WIDTH/SEL_WIDTH;

    wire [IN_WIDTH-1    :0] mask;
    wire [IN_WIDTH-1    :0] masked_mux_in;
    wire [SEL_WIDTH-1:0]    mux_out_gen [OUT_WIDTH-1:0]; 
    
    genvar i,j;
    integer x;
    //first selector masking
    generate    // first_mask = {sel[0],sel[0],sel[0],....,sel[n],sel[n],sel[n]}
        for(i=0; i<SEL_WIDTH; i=i+1) begin : mask_loop
            assign mask[(i+1)*OUT_WIDTH-1 : (i)*OUT_WIDTH]  =   {OUT_WIDTH{sel[i]} };
        end
        
        assign masked_mux_in    = mux_in & mask;
        
        for(i=0; i<OUT_WIDTH; i=i+1) begin : lp1
            for(j=0; j<SEL_WIDTH; j=j+1) begin : lp2
                assign mux_out_gen [i][j]   =   masked_mux_in[i+OUT_WIDTH*j];
            end
            assign mux_out[i] = | mux_out_gen [i];
        end
    endgenerate


    // Asserting the Property m1 : During multiplexing output data shlould be equal to input data
    
    always @ * begin
        // $display("in %b sel %b out %b", mux_in,sel, mux_out);
        
        // if (sel!=1'b0 && $onehot(sel)) begin
            // for(x=0;x<SEL_WIDTH;x=x+1) begin :asserion_check_loop0
                // Branch statement
                //m1
                // if (sel[x]==1) begin
                //     if (mux_in[OUT_WIDTH*(x)+:OUT_WIDTH]==mux_out) $display(" m1 succeeded");  
                //     else $display(" $error :m1 failed in %m at %t", $time);          
                // end
                // Assert statement
                //m1
                assert (!$onehot(sel) || sel!=1'b0 || (sel[0]==1'b1 && (mux_in[OUT_WIDTH*(0)+:OUT_WIDTH]==mux_out))==1);
                assert (!$onehot(sel) || sel!=1'b0 || (sel[1]==1'b1 && (mux_in[OUT_WIDTH*(1)+:OUT_WIDTH]==mux_out))==1);
                assert (!$onehot(sel) || sel!=1'b0 || (sel[2]==1'b1 && (mux_in[OUT_WIDTH*(2)+:OUT_WIDTH]==mux_out))==1);
                assert (!$onehot(sel) || sel!=1'b0 || (sel[3]==1'b1 && (mux_in[OUT_WIDTH*(3)+:OUT_WIDTH]==mux_out))==1);
            // end
        // end
        

    end
    


endmodule
