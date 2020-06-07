module flit_buffer 
    (
        din,     // Data in
        vc_num_wr,//write vertual channel   
        vc_num_rd,//read vertual channel    
        wr_en,   // Write enable
        rd_en,   // Read the next word
        dout,    // Data out
        vc_not_empty,
        reset,
        clk,
        ssa_rd
    );

    parameter V        =   2;//4;
    parameter B        =   4;   // buffer space :flit per VC 
    parameter Fpay     =   32;
    // parameter DEBUG_EN =   1;
    parameter SSA_EN="NO" ;// "YES" , "NO"       
    parameter CL        =   10;
    // function integer log2;
    //   input integer number; begin   
    //      log2=(number <=1) ? 1: 0;    
    //      while(2**log2<number) begin    
    //         log2=log2+1;    
    //      end 	   
    //   end   
    // endfunction // log2 
    
    localparam      Fw      =   2+V+Fpay,   //flit width
                    BV      =   B   *   V,
                    Tmin    =   0, // R6 time constant
                    Tmax    =   10000; // R7 time constant

    
    
    input  [Fw-1      :0]   din;     // Data in
    input  [V-1       :0]   vc_num_wr;//write vertual channel   
    input  [V-1       :0]   vc_num_rd;//read vertual channel    
    input                   wr_en;   // Write enable
    input                   rd_en;   // Read the next word
    output [Fw-1       :0]  dout;    // Data out
    output [V-1        :0]  vc_not_empty;
    input                   reset;
    input                   clk;
    input  [V-1        :0]  ssa_rd;
    
    localparam BVw              =   4,
               Bw               =   (B==1)? 1 : 2,//log2(B),
               Vw               =  (V==1)? 1 : 2,//log2(V),
               DEPTHw           =   Bw+1,
               BwV              =   Bw * V,
               BVwV             =   BVw * V,
               RAM_DATA_WIDTH   =   Fw - V;
               
         
               
    wire  [RAM_DATA_WIDTH-1     :   0] fifo_ram_din;
    wire  [RAM_DATA_WIDTH-1     :   0] fifo_ram_dout;
    wire  [V-1                  :   0] wr;
    wire  [V-1                  :   0] rd;
    reg   [DEPTHw-1             :   0] depth    [V-1            :0];
    
    
    assign fifo_ram_din = {din[Fw-1 :   Fw-2],din[Fpay-1        :   0]};
    assign dout = {fifo_ram_dout[Fpay+1:Fpay],{V{1'bX}},fifo_ram_dout[Fpay-1        :   0]};    
    assign  wr  =   (wr_en)?  vc_num_wr : {V{1'b0}};
    assign  rd  =   (rd_en)?  vc_num_rd : ssa_rd;


    
    // Assertion variables

    // integer packet_age [10          :0]; // Counting packet age
    reg [15     :   0] packet_age [CL-1          :0]={16'b0,16'b0,16'b0,16'b0,16'b0,16'b0,16'b0,16'b0,16'b0,16'b0}; // Counting packet age
    reg [15     :   0] packet_age_check [CL-1         :0]; // Counting packet age
    reg [1      :   0] age_ptr [CL-1      :   0] ={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
    reg [8     :   0] b5_check_buffer [CL-1          :0]; // Buffer table
    reg [1      :   0] b5_check_ptr [CL-1     :   0] ={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0} ;
    reg [4     :   0] b6_buffer_counter [CL-1         :0]={5'b0,5'b0,5'b0,5'b0,5'b0,5'b0,5'b0,5'b0,5'b0,5'b0}; // Packet counter
    reg packet_count_flag_in=1'b0;
    reg packet_count_flag_out=1'b0;
    integer x,y,z,p,q;

genvar i;


// initial begin
//     // 
//     // for(x=0;x<10;x=x+1) begin :assertion_loop0
//     //     b5_check_ptr[x] <= 1'b0;
//     //     b6_buffer_counter[x] <= 1'b0;
//     //     packet_age[x]=1'b0; 
//     //     // packet_age[x] <= 0; 
//     //     age_ptr[x] = 1'b0;
//     // end
//     // packet_count_flag_in<=1'b0;
//     // packet_count_flag_out<=1'b0;
// end


// generate 
    // if((2**Bw)==B)begin :pow2
        /*****************      
          Buffer width is power of 2
        ******************/
    reg [Bw- 1      :   0] rd_ptr [V-1          :0];
    reg [Bw- 1      :   0] wr_ptr [V-1          :0];
    
    
    
    
    wire [BwV-1    :    0]  rd_ptr_array;
    wire [BwV-1    :    0]  wr_ptr_array;
    wire [Bw-1     :    0]  vc_wr_addr;
    wire [Bw-1     :    0]  vc_rd_addr; 
    wire [Vw-1     :    0]  wr_select_addr;
    wire [Vw-1     :    0]  rd_select_addr; 
    wire [Bw+Vw-1  :    0]  wr_addr;
    wire [Bw+Vw-1  :    0]  rd_addr;
    
    
    
    
    //assign  wr_addr =   {wr_select_addr,vc_wr_addr};
    // assign  rd_addr =   {rd_select_addr,vc_rd_addr};

    assign wr_addr[Vw-1:0] = wr_select_addr[Vw-1     :    0];
    assign wr_addr[Bw-1+Vw:Vw] = vc_wr_addr[Bw-1     :    0];

    assign rd_addr[Vw-1:0] = rd_select_addr[Vw-1     :    0];
    assign rd_addr[Bw-1+Vw:Vw] = vc_rd_addr[Bw-1     :    0];
    
    
    reg [Bw- 1      :   0] rd_ptr_check [V-1          :0];
    reg [Bw- 1      :   0] wr_ptr_check [V-1          :0];


    
    one_hot_mux  wr_ptr_mux
    (
        .mux_in         (wr_ptr_array),
        .mux_out            (vc_wr_addr),
        .sel                (vc_num_wr)
    );
    
        
    
    one_hot_mux rd_ptr_mux
    (
        .mux_in         (rd_ptr_array),
        .mux_out            (vc_rd_addr),
        .sel                (vc_num_rd)
    );
    
    
    
    one_hot_to_bin 
    // #(
    // .ONE_HOT_WIDTH  (V)
    // 
    // )
    wr_vc_start_addr
    (
    .one_hot_code   (vc_num_wr),
    .bin_code       (wr_select_addr)

    );
    
    one_hot_to_bin 
    // #(
    // .ONE_HOT_WIDTH  (V)
    // 
    // )
    rd_vc_start_addr
    (
    .one_hot_code   (vc_num_rd),
    .bin_code       (rd_select_addr)

    );

    // fifo_ram   
    //  #(
    //     .DATA_WIDTH (RAM_DATA_WIDTH),
    //     .ADDR_WIDTH (BVw ),
    //     .SSA_EN(SSA_EN)       
    // )
    fifo_ram the_queue
    (
        .wr_data        (fifo_ram_din), 
        .wr_addr        (wr_addr[BVw-1  :   0]),
        .rd_addr        (rd_addr[BVw-1  :   0]),
        .wr_en          (wr_en),
        .rd_en          (rd_en),
        .clk            (clk),
        .rd_data        (fifo_ram_dout)
    );  


generate
    for(i=0;i<V;i=i+1) begin :loop0
        
        assign  wr_ptr_array[(i+1)*Bw- 1        :   i*Bw]   =       wr_ptr[i];
        assign  rd_ptr_array[(i+1)*Bw- 1        :   i*Bw]   =       rd_ptr[i];
        //assign    vc_nearly_full[i] = (depth[i] >= B-1);
        assign  vc_not_empty    [i] =   (depth[i] > 0);
    
    
        always @(posedge clk or posedge reset) begin
            if (reset) begin
                rd_ptr  [i] <= {Bw{1'b0}};
                wr_ptr  [i] <= {Bw{1'b0}};
                depth   [i] <= {DEPTHw{1'b0}};
            end
            else begin
                if (wr[i] ) wr_ptr[i] <= wr_ptr [i]+ 1'h1;
                if (rd[i] ) rd_ptr [i]<= rd_ptr [i]+ 1'h1;
                if (wr[i] & ~rd[i]) depth [i]<=
                //synthesis translate_off
                //synopsys  translate_off
                   #1
                //synopsys  translate_on
                //synthesis translate_on
                   depth[i] + 1'h1;
                else if (~wr[i] & rd[i]) depth [i]<=
                //synthesis translate_off
                //synopsys  translate_off
                   #1
                //synopsys  translate_on
                //synthesis translate_on
                   depth[i] - 1'h1;
            end//else
        end//always

        //synthesis translate_off
        //synopsys  translate_off
    
        always @(posedge clk) begin
            if(~reset)begin
                if (wr[i] && (depth[i] == B) && !rd[i])
                    $display("%t: ERROR: Attempt to write to full FIFO:FIFO size is %d. %m",$time,B);
                /* verilator lint_off WIDTH */
                if (rd[i] && (depth[i] == {DEPTHw{1'b0}} &&  SSA_EN !="YES"  ))
                    $display("%t: ERROR: Attempt to read an empty FIFO: %m",$time);
                if (rd[i] && !wr[i] && (depth[i] == {DEPTHw{1'b0}} &&  SSA_EN =="YES" ))
                    $display("%t: ERROR: Attempt to read an empty FIFO: %m",$time);
                /* verilator lint_on WIDTH */
          
            end//~reset      
        end//always

     
            // Asserting the Property b1 : Read and write pointers are incremented when r_en/w_en are set
            // Asserting the property b3 : Read and Write pointers are not incremented when the buffer is empty and full
            // Asserting the property b4 : Buffer can not be both full and empty at the same time
                            
            // Branch statements
            always@(posedge clk) begin
                //b1.1
                if (wr[i] && (!rd[i] && !(depth[i] == B) || rd[i])) begin
                    //$display ("new %d old %b ",wr_ptr[i],wr_ptr_check[i] );
                    wr_ptr_check[i] <= wr_ptr[i];
                    #1
                    // $display ("new %d old %b ",wr_ptr[i],wr_ptr_check[i] );
                    if ( wr_ptr[i]== wr_ptr_check[i] +1'b1 ) $display(" b1.1 succeeded");
                    else $display(" $error :b1.1 failed in %m at %t", $time);
                end
                //b1.2
                if (rd[i] && (!wr[i] && !(depth[i] == B) || wr[i])) begin
                    rd_ptr_check[i] <= rd_ptr[i];
                    #1
                    if ( rd_ptr[i]== rd_ptr_check[i]+ 1'b1 ) $display(" b1.2 succeeded");
                    else $display(" $error :b1.2 failed in %m at %t", $time);
                end
                //b3.1 trying to write to full buffer
                if (wr[i] && !rd[i] && (depth[i] == B) ) begin
                    wr_ptr_check[i] <= wr_ptr[i];
                    #1
                    if ( wr_ptr[i]== wr_ptr_check[i] ) $display(" b3.1 succeeded");
                    else $display(" $error :b3.1 failed in %m at %t", $time);
                end
                //b3.2 trying to read from empty buffer
                if (rd[i] && !wr[i] && (depth[i] == {DEPTHw{1'b0}})) begin
                    rd_ptr_check[i] <= rd_ptr[i];
                    #1
                    if ( rd_ptr[i]== rd_ptr_check[i] ) $display(" b3.2 succeeded");
                    else $display(" $error :b3.2 failed in %m at %t", $time);
                end
                //b4 buffer cannot be empty and full at the same time
                if (!((depth[i] == {DEPTHw{1'b0}}) && (depth[i] == B))) $display (" b4 succeeded");
                else $display(" $error :b4 failed in %m at %t", $time);
                

            end
            
            // Assert statements
            //b1.1
            // b1_1: assert property ( @(posedge clk) ( wr[i] && (!rd[i] && !(depth[i] == B) || rd[i]) ) |=>  ( wr_ptr[i] == $past(wr_ptr[i])+1 ));
            // //b1.2
            // b1_2: assert property ( @(posedge clk) (rd[i] && (!wr[i] && !(depth[i] == B) || wr[i])) |=>  ( rd_ptr[i] == $past(rd_ptr[i])+1 )); 
            // //b3.1
            // b3_1: assert property ( @(posedge clk) (wr[i] && !rd[i] && (depth[i] == B) ) |=>   ( rd_ptr[i] == $past(rd_ptr[i]) )); 
            //b3.2
            // b3_2: assert property ( @(posedge clk) (rd[i] && !wr[i] && (depth[i] == {DEPTHw{1'b0}})) |=>   ( rd_ptr[i] == $past(rd_ptr[i]) )) ; 
            // //b4
            // b4: assert property ( @(posedge clk) (!(depth[i] == {DEPTHw{1'b0}} && depth[i] == B))); 
 
    end//for
 
    
 
        always @(posedge clk) begin
            if (wr_en) begin      

                // Asserting the property b5 : Data that was read from the buffer was at some point in time written into the buffer
                // Asserting the property b6 : The same number of packets that were written in to the buffer can be read from the buffer

                // b5 : adding the header to monitoring list
                if (din[35]==1'b1) begin // Header found
                    //  $display ("Buffer in %b",din);
                    for(y=0;y<CL;y=y+1) begin :asserion_check_loop1
                        if (!b5_check_ptr[y]) begin
                            b5_check_buffer[y]<=din[8:0]; // Adding the packet header to check buffer
                            b5_check_ptr[y]<=1'b1; // check buffer pointer
                            b6_buffer_counter[y]<=b6_buffer_counter[y] + 1'b1; // Packet counter for entering packets
                            packet_count_flag_in<=1'b1; // Enabled to count payload packets and tails packets
                            age_ptr[y]=1'b1; //  Enabled to count the age of the packet inside the buffer
                            packet_age[y]=1'b0; // Resetting the packet age
                            // break;
                        end
                    end
                    
                end

                if (packet_count_flag_in) begin
                    b6_buffer_counter[y]<=b6_buffer_counter[y] + 1'b1; // Counting the payload and tail packets
                end

                if (din[34]==1'b1) begin
                    packet_count_flag_in<=1'b0; // If tail found, stop Counting packets
                end
            end

            if (rd_en) begin      

                // b5 : removing the header from the monitoring list
                if (dout[35]==1'b1) begin // Header found
                    // $display (" buffer out %b",dout[31:0]);
                    for(z=0;z<CL+1;z=z+1) begin :asserion_check_loop2
                        // $display ("buffer_values %b",b5_check_buffer[z]);
                        // branch statement
                        //b5
                        if (b5_check_ptr[z]==1'b1 && (b5_check_buffer[z])==dout[8:0] && z!=CL) begin // Compare with check buffer
                            $display("(Property b2) packet %b stayed in buffer for %d ticks at %m",b5_check_buffer[z],packet_age[z]);
                            $display(" b5 succeeded");
                            b5_check_ptr[z]<=1'b0; // reset check buffer pointer
                            b6_buffer_counter[z]<=b6_buffer_counter[z] - 1'b1; // Counting the packets for b6
                            packet_count_flag_out<=1'b1; // Enabled to count payload and tail packets
                            age_ptr[z]=1'b0; // resetting age pointer
                            //packet_age[z]=1'b0; // resetting age

                            // branch statement
                            //R6
                            if (packet_age[z] > Tmin) $display(" R6 succeeded");
                            else $display(" $error :R6 failed in %m at %t", $time);
                            
                            // assertion statements
                            //R6
                            assert (packet_age[z] > Tmin);
                            // break;
                        end
                        // assertion statements
                        //b5
                        assert (b5_check_ptr[z]==1'b1 && (b5_check_buffer[z])==dout[8:0] && z!=CL);

                        if (z==CL) $display(" $error :b5 failed in %m at %t", $time); // Packet not found in the check buffer
                    end
                    
                end
                if (packet_count_flag_out) begin
                    b6_buffer_counter[z]<=b6_buffer_counter[z] - 1'b1; // Counting payload and tail packets that are leaving buffer
                end
                if (dout[34]==1'b1) begin // tail packet found
                    packet_count_flag_out<=1'b0;
                    // branch statement
                    //b6
                    if (b6_buffer_counter[z]==1'b0) $display(" b6 succeeded");
                    else $display(" $error :b6 failed in %m at %t", $time);
                    // assertion statements
                    //b6
                    assert (b6_buffer_counter[z]==1'b0);
                end
            end
            // b2 implementation
            for(p=0;p<CL;p=p+1) begin :asserion_check_loop3
                if (age_ptr[p]==1'b1) begin
                    packet_age[p]=packet_age[p]+1'b1; // Counting the age of packets inside the buffer
                    
                    // branch statement
                    //R7
                    if (packet_age[p] < Tmax) $display(" R7 succeeded"); //assuming no fail in a1 ∧ a2 ∧ a3 ∧ b1 ∧ b2 ∧ b4 ∧ m1 ∧ r1 ∧ r2 ∧ r3
                    else $display(" $error :R7 failed in %m at %t", $time);
                    
                    // assertion statements
                    //R7
                    assert (packet_age[p] < Tmax);
                end
            end

            //b2 checks
            for(q=0;q<CL;q=q+1) begin :asserion_check_loop4
                // branch statement
                //b2
                if (age_ptr[q]==1'b1) begin
                    packet_age_check[q]<=packet_age[q]; // assign previous clock value to check buffer
                    #1
                    if ( packet_age[q] == packet_age_check[q] +1'b1 ) $display(" b2 succeeded");
                    else $display(" $error :b2 failed in %m at %t", $time);
                end
                // assertion statements
                //b2
                // assert property ( @(posedge clk) (age_ptr[q]==1'b1) |=>  ( packet_age[q] == $past(packet_age[q])+1 ));
            end

        end //Always

        // //b5 (PSL)
        assert property (wr_en |-> s_eventually din[8:0]==dout[8:0]);



    
    // end 
 
 endgenerate  
endmodule 

module one_hot_mux 
    (
        input [IN_WIDTH-1       :0] mux_in,
        output[OUT_WIDTH-1  :0] mux_out,
        input[SEL_WIDTH-1   :0] sel

    );
    
    parameter   IN_WIDTH      = 8;
    parameter   SEL_WIDTH =   4;
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

module one_hot_mux_2 
    (
        input [IN_WIDTH-1       :0] mux_in,
        output[OUT_WIDTH-1  :0] mux_out,
        input[SEL_WIDTH-1   :0] sel

    );
    
    parameter   IN_WIDTH      = 2;
    parameter   SEL_WIDTH =   2;
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
                // assert (!$onehot(sel) || sel!=1'b0 || (sel[2]==1'b1 && (mux_in[OUT_WIDTH*(2)+:OUT_WIDTH]==mux_out))==1);
                // assert (!$onehot(sel) || sel!=1'b0 || (sel[3]==1'b1 && (mux_in[OUT_WIDTH*(3)+:OUT_WIDTH]==mux_out))==1);
            // end
        // end
        

    end
    


endmodule



module fifo_ram     
    (
        input [DATA_WIDTH-1         :       0]  wr_data,        
        input [ADDR_WIDTH-1         :       0]      wr_addr,
        input [ADDR_WIDTH-1         :       0]      rd_addr,
        input                                               wr_en,
        input                                               rd_en,
        input                                           clk,
        output [DATA_WIDTH-1   :       0]      rd_data
    );  
    parameter DATA_WIDTH    = 34;
    parameter ADDR_WIDTH    = 4;
    parameter SSA_EN="NO" ;// "YES" , "NO"       
    
	reg [DATA_WIDTH-1:0] memory_rd_data; 
   // memory
	reg [DATA_WIDTH-1:0] queue [2**ADDR_WIDTH-1:0] /* synthesis ramstyle = "no_rw_check , M9K" */;
	always @(posedge clk ) begin
			if (wr_en)
				 queue[wr_addr] <= wr_data;
			if (rd_en)
				 memory_rd_data <=
//synthesis translate_off
//synopsys  translate_off
					  #1
//synopsys  translate_on
//synthesis translate_on   
					  queue[rd_addr];
	end
	
    generate 
    /* verilator lint_off WIDTH */
        assign rd_data =  memory_rd_data;

    endgenerate
endmodule

module one_hot_to_bin 
(
    input   [ONE_HOT_WIDTH-1        :   0] one_hot_code,
    output  [BIN_WIDTH-1            :   0]  bin_code

);


    
    parameter ONE_HOT_WIDTH =   2;
    parameter BIN_WIDTH     =  1;
    // parameter BIN_WIDTH     =  (ONE_HOT_WIDTH>1)? log2(ONE_HOT_WIDTH):1

localparam MUX_IN_WIDTH =   BIN_WIDTH* ONE_HOT_WIDTH;

wire [MUX_IN_WIDTH-1        :   0]  bin_temp ;

one_hot_mux_2  one_hot_to_bcd_mux //.IN_WIDTH   (MUX_IN_WIDTH),  .SEL_WIDTH  (ONE_HOT_WIDTH)
        (
            .mux_in     (bin_temp),
            .mux_out        (bin_code),
            .sel            (one_hot_code)
    
        );

genvar i;
generate 
    if(ONE_HOT_WIDTH>1)begin :if1
        for(i=0; i<ONE_HOT_WIDTH; i=i+1) begin :mux_in_gen_loop
            assign bin_temp[(i+1)*BIN_WIDTH-1 : i*BIN_WIDTH] =  i[BIN_WIDTH-1:0];
        end


        
     end else begin :els
        assign  bin_code = one_hot_code;
     
     end

endgenerate

endmodule
