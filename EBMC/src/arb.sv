

module arbiter 
(    
   clk, 
   reset, 
   request, 
   grant,
   any_grant
);

    parameter    ARBITER_WIDTH    =8;
    
    input    [ARBITER_WIDTH-1             :    0]    request;
    output    [ARBITER_WIDTH-1            :    0]    grant;
    output                                        any_grant;
    input                                        clk;
    input                                        reset;



    // generate 
    // if(ARBITER_WIDTH==1)  begin: w1
    //     assign grant= request;
    //     assign any_grant =request;
    // end else if(ARBITER_WIDTH<=4) begin: w4
    //     //my own arbiter 
    //     one_hot_arb my_one_hot_arbiter 
    //     
    //     (    
    //         .clk            (clk), 
    //         .reset         (reset), 
    //         .request        (request), 
    //         .grant        (grant),
    //         .any_grant    (any_grant)
    //     );
    
    // end else begin : wb4
        
         thermo_arbiter one_hot_arb 
        
        (    
            .clk            (clk), 
            .reset         (reset), 
            .request        (request), 
            .grant        (grant),
            .any_grant    (any_grant)
        );
    // end
    // endgenerate

    

    // Asserting the Property a1 : Always at most one grant issued by the arbiter
    // Asserting the Property a2 : As long as the request is available, it will eeventually be granted by the arbiter within T cycles
    // Asserting the Property a3 : No grant can be issued without a request
    // Asserting the Property a4 : Time between two issued grants is always the same for all requests


    integer i,x,y,z,counter,t_const,t_count;
    integer rx_t[0:3]; // a4 First time time counter variable
    integer tx_flag[0:3]; // a4 First time time counter variable
    integer rx_t_2[0:3]; // a4 real time always counter variable
    integer tx_flag_2[0:3]; // a4 real time always counter variable

    // initial begin
    //     t_const=0;
    //     t_count=0;
    //     rx_t={0,0,0,0};
    //     tx_flag={0,0,0,0};
    //     tx_flag_2={0,0,0,0};
    // end
    // Branch statements
    always@(posedge clk) begin
        //$display("%b", grant);
        //a1
        if ($onehot0(grant)) begin
            if ($onehot(grant)) $display (" a1 succeeded");
        end
        else $display(" $error :a1 failed in %m at %t", $time);
        //a2
        // if ($onehot(request)) begin
        //     for(i=0;i<ARBITER_WIDTH;i=i+1) begin :loop0
        //         if(request[i]==1'b1) begin
        //             counter = 0; // clock counter initialization
        //             while(request[i]==1'b1) begin 
        //                 @(posedge clk); // when clock signal gets high
        //                 if ( grant[i]==1'b1) $display (" a2 Request granted after %d clock cycles", counter); 
        //                 counter++; // increase counter by 1
        //             end
        //             
        //         end
        //     end
        //     if ($onehot(grant) && grant[i]==1'b1 && request!=grant) $display(" $error :a2 failed in %m at %t", $time);
        // end
       
        //a3
        for(x=0;x<ARBITER_WIDTH;x=x+1) begin :loop1
            if (!request[x]) begin
                // #1
                if (!grant[x]) $display (" a3 succeeded");
                else $display(" $error :a3 failed in %m at %t", $time);
            end
        end

        //a4
        // if($onehot(grant)) begin
        //     // $display("%d $size(grant)",$size(grant));
        //     for(y=0;y<ARBITER_WIDTH;y=y+1) begin :loop2
        //         if (grant[y]==1'b1) begin
        //             if (rx_t[y]==0 && tx_flag[y]==0) begin
        //                 tx_flag[y]=1;
        //                 while(tx_flag[y]==1 && request[y]==1'b1) begin 
        //                     @(posedge clk); // when clock signal gets high
        //                     rx_t[y]++; // increase counter by 1
        //                     // $display("counter is %d for %d", rx_t[y],y);
        //                 end
        //             end
        //             else tx_flag[y]=0;
        //         end
        //     end

        //     for(z=0;z<ARBITER_WIDTH;z=z+1) begin :loop3
        //         if (grant[z]==1'b1 && tx_flag_2[z]==0) begin
        //                 tx_flag_2[z]=1;
        //                 rx_t_2[z]=0;
        //                 while(tx_flag_2[z]==1 && request[z]==1'b1) begin 
        //                     @(posedge clk); // when clock signal gets high
        //                     rx_t_2[z]++; // increase counter by 1
        //                     $display("real time counter is %d for %d", rx_t[z],z);
        //                 end
        //         end
        //         if (grant[z]==1'b1 && tx_flag_2[z]==1) begin    
        //             tx_flag_2[z]=0;
        //             if (rx_t[z]==rx_t_2[z] && rx_t[z]!=0) $display(" a4 (real time check) succeeded");
        //             else $display(" $error :a4 (real time check) failed in %m at %t", $time);
        //         end
        //     end

        //     if (rx_t[0]==rx_t[1]==rx_t[2]==rx_t[3] && tx_flag[0]==tx_flag[1]==tx_flag[2]==tx_flag[3]==0 && rx_t[0]!=0) $display (" a4 (first time check) succeeded");
        //     else $display(" $error :a4 (first time check) failed in %m at %t", $time);
            
        // end
    end

    // Assert statements
    //a1
    a1: assert property ( $onehot0(grant));
    
    //a2
    genvar j;
    generate
        for (j=0; j < ARBITER_WIDTH; j=j+1) begin
            // From SystemVerilog Assertions and Functional Coverage: Guide to Language pg: 85
            // a2: assert property($onehot(request) && $rose(request[j]) |-> request[j][*1:$] ##0 $rose(grant[j]));
            a2_liveliness: assert property (request[j] |-> s_eventually grant[j]); // liveliness property with infinite counter examples
            // a2_safety: assert property (@(posedge clk) request[j] until_with grant[j]); // if grant[j] does not happen, request[j] holds forever
            // a2_general: assert property (@(posedge clk) request[j] s_until_with grant[j]); // grant[j] must eventually happen
        end
    endgenerate  

    //a3
    genvar k;
    generate
        for (k=0; k < ARBITER_WIDTH; k=k+1) begin
            a3: assert property ( !request[k] |->  ##1 !grant[k]);
        end
    endgenerate
    //a4
    // genvar l;
    // generate
    //     for (l=0; l < ARBITER_WIDTH ; l=l+1) begin
    //         a4_1: assert property (grant[l]==1'b1 && tx_flag_2[l]==1 && rx_t[l]==rx_t_2[l] && rx_t[l]!=0); // time of north to north, east to east.... check
    //         
    //     end
    // endgenerate
    // a4_2: assert property (rx_t[0]==rx_t[1]==rx_t[2]==rx_t[3] && tx_flag[0]==tx_flag[1]==tx_flag[2]==tx_flag[3]==0 && rx_t[0]!=0); // time of north, east, west, south check


endmodule


 


// module one_hot_to_bin 
// (
//     input   [ONE_HOT_WIDTH-1        :   0] one_hot_code,
//     output  [BIN_WIDTH-1            :   0]  bin_code

// );

//   
//     // function integer log2;
//     //   input integer number; begin   
//     //      log2=(number <=1) ? 1: 0;    
//     //      while(2**log2<number) begin    
//     //         log2=log2+1;    
//     //      end 	   
//     //   end   
//     // endfunction // log2 
//     
//     parameter ONE_HOT_WIDTH =   8;
//     parameter BIN_WIDTH     =  (ONE_HOT_WIDTH>1)? ((ONE_HOT_WIDTH==2)? 1 : 2):1;
//     // parameter BIN_WIDTH     =  (ONE_HOT_WIDTH>1)? log2(ONE_HOT_WIDTH):1

// localparam MUX_IN_WIDTH =   BIN_WIDTH* ONE_HOT_WIDTH;

// wire [MUX_IN_WIDTH-1        :   0]  bin_temp ;

// genvar i;
// generate 
//     if(ONE_HOT_WIDTH>1)begin :if1
//         for(i=0; i<ONE_HOT_WIDTH; i=i+1) begin :mux_in_gen_loop
//             assign bin_temp[(i+1)*BIN_WIDTH-1 : i*BIN_WIDTH] =  i[BIN_WIDTH-1:0];
//         end


//         one_hot_mux #(
//             .IN_WIDTH   (MUX_IN_WIDTH),
//             .SEL_WIDTH  (ONE_HOT_WIDTH)
//             
//         )
//         one_hot_to_bcd_mux
//         (
//             .mux_in     (bin_temp),
//             .mux_out        (bin_code),
//             .sel            (one_hot_code)
//     
//         );
//      end else begin :els
//         assign  bin_code = one_hot_code;
//      
//      end

// endgenerate

// endmodule

module thermo_arbiter
(    
   clk, 
   reset, 
   request, 
   grant,
   any_grant
);

        
parameter    ARBITER_WIDTH    =8;
    
    input        [ARBITER_WIDTH-1             :    0]    request;
    output    [ARBITER_WIDTH-1            :    0]    grant;
    output                                            any_grant;
    input                                                reset,clk;
    
    
    wire        [ARBITER_WIDTH-1             :    0]    termo1,termo2,mux_out,masked_request,edge_mask;
    reg        [ARBITER_WIDTH-1             :    0]    pr;


    thermo_gen  tm1
    (
        .in(request),
        .out(termo1)
    );




    thermo_gen tm2
    (
        .in(masked_request),
        .out(termo2)
    );

    
assign mux_out=(termo2[ARBITER_WIDTH-1])? termo2 : termo1;
assign masked_request= request & pr;
assign any_grant=termo1[ARBITER_WIDTH-1];

always @(posedge clk or posedge reset)begin 
    if(reset) pr<= {ARBITER_WIDTH{1'b1}};
    else begin 
        if(any_grant) pr<= edge_mask;
    end

end

assign edge_mask= {mux_out[ARBITER_WIDTH-2:0],1'b0};
assign grant= mux_out ^ edge_mask;



endmodule

module thermo_gen(
    input  [WIDTH-1    :    0]in,
    output [WIDTH-1    :    0]out
);
parameter WIDTH=16;
    genvar i;
    generate
    for(i=0;i<WIDTH;i=i+1)begin :lp
        assign out[i]= | in[i    :0];    
    end
    endgenerate

endmodule

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
