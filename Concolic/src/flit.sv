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
    parameter CL        =   4;
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
    reg   [DEPTHw*V-1             :   0] depth ;//   [V-1            :0];

    
    assign fifo_ram_din ={din[Fw-1 :   Fw-2],din[Fpay-1        :   15],6'b111111,din[8:0]};

    // assign fifo_ram_din =din[35]? {din[Fw-1 :   Fw-2],din[Fpay-1        :   15],6'b111111,din[8:0]} : {din[Fw-1 :   Fw-2],din[Fpay-1        :   0]};
    assign dout = {fifo_ram_dout[Fpay+1:Fpay],{V{1'bX}},fifo_ram_dout[Fpay-1        :   0]};    
    assign  wr  =   (wr_en)?  vc_num_wr : {V{1'b0}};
    assign  rd  =   (rd_en)?  vc_num_rd : ssa_rd;


    
    // Assertion variables

    reg pkt_count_flag_in;//=1'b0;
    reg pkt_count_flag_out;//=1'b0;
    // reg packet_count_flag_out=1'b0;
    integer x,y,z,p,q;

    reg [15*CL     :   0]       packet_age         ;//  [CL-1          :0]; // Counting packet age
    reg [15 *CL    :   0]       packet_age_check    ;// [CL-1         :0]; // Counting packet age
    reg [CL-1     :   0]     age_ptr              =4'b0000;
    reg [8*CL   :   0]          b5_check_buffer   ;//   [(CL)-1          :0]; // Buffer table
    reg    [(CL)-1     :   0]                   b5_check_ptr         ;//={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
    reg [4     :   0]        b6_buffer_counter ;//   [CL-1         :0]; // Packet counter
    reg [1   :   0]          b5_wr_addr = 0;
    reg [1   :   0]          b5_rd_addr = 0;

    // reg [RAM_DATA_WIDTH-1:0] b5_check_buffer [2**BVw-1:0];

    wire [5:0] dou;
    wire dou35 ;
    assign dou = dout[14:9];
    assign dou35 =dout[35];


// genvar i;


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



    reg [Bw*V- 1      :   0] rd_ptr;// [V-1          :0];
    reg [Bw*V- 1      :   0] wr_ptr;// [V-1          :0];

    
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
    
    
    reg [Bw*V- 1      :   0] rd_ptr_check ;//[V-1          :0];
    reg [Bw*V- 1      :   0] wr_ptr_check ;// [V-1          :0];

    
    // one_hot_mux  wr_ptr_mux
    // (
    //     .mux_in         (wr_ptr_array),
    //     .mux_out            (vc_wr_addr),
    //     .sel                (vc_num_wr)
    // );

    parameter   IN_WIDTH_0      = 8;
    parameter   SEL_WIDTH_0 =   4;
    parameter   OUT_WIDTH_0 = IN_WIDTH_0/SEL_WIDTH_0;

    wire [IN_WIDTH_0-1    :0] mask_0;
    wire [IN_WIDTH_0-1    :0] masked_mux_in_0;
    wire [SEL_WIDTH_0*OUT_WIDTH_0-1:0]    mux_out_gen_0 ;//[OUT_WIDTH_0-1:0]; 
    
    // genvar e,w;
    // // integer x;
    // //first selector masking (one_hot_mux  wr_ptr_mux)
    // generate    // first_mask = {sel[0],sel[0],sel[0],....,sel[n],sel[n],sel[n]}
    //     for(e=0; e<SEL_WIDTH_0; e=e+1) begin //: mask_loop
    //         assign mask_0[(e+1)*OUT_WIDTH_0-1 : (e)*OUT_WIDTH_0]  =   {OUT_WIDTH_0{vc_num_wr[e]} };
    //     end
        
    //     assign masked_mux_in_0    = wr_ptr_array & mask_0;
        
    //     for(e=0; e<OUT_WIDTH_0; e=e+1) begin //: lp1
    //         for(w=0; w<SEL_WIDTH_0; w=w+1) begin //: lp2
    //             assign mux_out_gen_0 [e][w]   =   masked_mux_in_0[e+OUT_WIDTH_0*w];
    //         end
    //         assign vc_wr_addr[e] = | mux_out_gen_0 [e];
    //     end

    // endgenerate

    assign mask_0[(0+1)*OUT_WIDTH_0-1 : (0)*OUT_WIDTH_0]  =   {OUT_WIDTH_0{vc_num_wr[0]} };
    assign mask_0[(1+1)*OUT_WIDTH_0-1 : (1)*OUT_WIDTH_0]  =   {OUT_WIDTH_0{vc_num_wr[1]} };
    assign mask_0[(2+1)*OUT_WIDTH_0-1 : (2)*OUT_WIDTH_0]  =   {OUT_WIDTH_0{vc_num_wr[2]} };
    assign mask_0[(3+1)*OUT_WIDTH_0-1 : (3)*OUT_WIDTH_0]  =   {OUT_WIDTH_0{vc_num_wr[3]} };

    assign masked_mux_in_0    = wr_ptr_array & mask_0;

    assign mux_out_gen_0 [0]   =   masked_mux_in_0[0+OUT_WIDTH_0*0];
    assign mux_out_gen_0 [1]   =   masked_mux_in_0[0+OUT_WIDTH_0*1];
    assign mux_out_gen_0 [2]   =   masked_mux_in_0[0+OUT_WIDTH_0*2];
    assign mux_out_gen_0 [3]   =   masked_mux_in_0[0+OUT_WIDTH_0*3];
    assign mux_out_gen_0 [4]   =   masked_mux_in_0[1+OUT_WIDTH_0*0];
    assign mux_out_gen_0 [5]   =   masked_mux_in_0[1+OUT_WIDTH_0*1];
    assign mux_out_gen_0 [6]   =   masked_mux_in_0[1+OUT_WIDTH_0*2];
    assign mux_out_gen_0 [7]   =   masked_mux_in_0[1+OUT_WIDTH_0*3];
    
    assign vc_wr_addr[0] = | mux_out_gen_0 [0*SEL_WIDTH_0+:SEL_WIDTH_0];
    assign vc_wr_addr[1] = | mux_out_gen_0 [1*SEL_WIDTH_0+:SEL_WIDTH_0];

    
        
    
    // one_hot_mux rd_ptr_mux
    // (
    //     .mux_in         (rd_ptr_array),
    //     .mux_out            (vc_rd_addr),
    //     .sel                (vc_num_rd)
    // );

  
    
    parameter   IN_WIDTH_1      = 8;
    parameter   SEL_WIDTH_1 =   4;
    parameter   OUT_WIDTH_1 = IN_WIDTH_1/SEL_WIDTH_1;

    wire [IN_WIDTH_1-1    :0] mask_1;
    wire [IN_WIDTH_1-1    :0] masked_mux_in_1;
    wire [SEL_WIDTH_1*OUT_WIDTH_1-1:0]    mux_out_gen_1;// [OUT_WIDTH_1-1:0]; 
    
    // genvar m,n;
    // integer x;
    //first selector masking
    // generate    // first_mask = {sel[0],sel[0],sel[0],....,sel[n],sel[n],sel[n]}
    //     for(m=0; m<SEL_WIDTH_1; m=m+1) begin // : mask_loop
    //         assign mask_1[(m+1)*OUT_WIDTH_1-1 : (m)*OUT_WIDTH_1]  =   {OUT_WIDTH_1{vc_num_rd[m]} };
    //     end
        
    //     assign masked_mux_in_1    = rd_ptr_array & mask_1;
        
    //     for(m=0; m<OUT_WIDTH_1; m=m+1) begin // : lp1
    //         for(n=0; n<SEL_WIDTH_1; n=n+1) begin //: lp2
    //             assign mux_out_gen_1 [m][n]   =   masked_mux_in_1[m+OUT_WIDTH_1*n];
    //         end
    //         assign vc_rd_addr[m] = | mux_out_gen_1 [m];
    //     end
    // endgenerate

    assign mask_1[(0+1)*OUT_WIDTH_1-1 : (0)*OUT_WIDTH_1]  =   {OUT_WIDTH_1{vc_num_wr[0]} };
    assign mask_1[(1+1)*OUT_WIDTH_1-1 : (1)*OUT_WIDTH_1]  =   {OUT_WIDTH_1{vc_num_wr[1]} };
    assign mask_1[(2+1)*OUT_WIDTH_1-1 : (2)*OUT_WIDTH_1]  =   {OUT_WIDTH_1{vc_num_wr[2]} };
    assign mask_1[(3+1)*OUT_WIDTH_1-1 : (3)*OUT_WIDTH_1]  =   {OUT_WIDTH_1{vc_num_wr[3]} };

    assign masked_mux_in_1    = rd_ptr_array & mask_1;

    assign mux_out_gen_1 [0]   =   masked_mux_in_1[0+OUT_WIDTH_1*0];
    assign mux_out_gen_1 [1]   =   masked_mux_in_1[0+OUT_WIDTH_1*1];
    assign mux_out_gen_1 [2]   =   masked_mux_in_1[0+OUT_WIDTH_1*2];
    assign mux_out_gen_1 [3]   =   masked_mux_in_1[0+OUT_WIDTH_1*3];
    assign mux_out_gen_1 [4]   =   masked_mux_in_1[1+OUT_WIDTH_1*0];
    assign mux_out_gen_1 [5]   =   masked_mux_in_1[1+OUT_WIDTH_1*1];
    assign mux_out_gen_1 [6]   =   masked_mux_in_1[1+OUT_WIDTH_1*2];
    assign mux_out_gen_1 [7]   =   masked_mux_in_1[1+OUT_WIDTH_1*3];
    
    assign vc_wr_addr[0] = | mux_out_gen_1 [0*SEL_WIDTH_1+:SEL_WIDTH_1];
    assign vc_wr_addr[1] = | mux_out_gen_1 [1*SEL_WIDTH_1+:SEL_WIDTH_1];


    
    
    
     
    // #(
    // .ONE_HOT_WIDTH  (V)
    // 
    // )
    // one_hot_to_bin wr_vc_start_addr
    // (
    // .one_hot_code   (vc_num_wr),
    // .bin_code       (wr_select_addr)

    // );
    
    parameter ONE_HOT_WIDTH_0 =   2;
    parameter BIN_WIDTH_0     =  1;
    // parameter BIN_WIDTH     =  (ONE_HOT_WIDTH>1)? log2(ONE_HOT_WIDTH):1

    localparam MUX_IN_WIDTH_0 =   BIN_WIDTH_0* ONE_HOT_WIDTH_0;

    wire [MUX_IN_WIDTH_0-1        :   0]  bin_temp_0 ;

// one_hot_mux_2  one_hot_to_bcd_mux //.IN_WIDTH   (MUX_IN_WIDTH),  .SEL_WIDTH  (ONE_HOT_WIDTH)
//         (
//             .mux_in     (bin_temp),
//             .mux_out        (bin_code),
//             .sel            (one_hot_code)
    
//         );

    parameter   IN_WIDTH_2      = 2;
    parameter   SEL_WIDTH_2 =   2;
    parameter   OUT_WIDTH_2 = IN_WIDTH_2/SEL_WIDTH_2;

    wire [IN_WIDTH_2-1    :0] mask_2;
    wire [IN_WIDTH_2-1    :0] masked_mux_in_2;
    wire [SEL_WIDTH_2*OUT_WIDTH_2-1:0]    mux_out_gen_2;// [OUT_WIDTH_2-1:0]; 
    
    // genvar a,b;
    // integer x;
    //first selector masking
    // generate    // first_mask = {sel[0],sel[0],sel[0],....,sel[n],sel[n],sel[n]}
    //     for(a=0; a<SEL_WIDTH_2; a=a+1) begin //: mask_loop
    //         assign mask_2[(a+1)*OUT_WIDTH_2-1 : (a)*OUT_WIDTH_2]  =   {OUT_WIDTH_2{vc_num_wr[a]} };
    //     end
        
    //     assign masked_mux_in_2    = bin_temp_0 & mask_2;
        
    //     for(a=0; a<OUT_WIDTH_2; a=a+1) begin //: lp1
    //         for(b=0; b<SEL_WIDTH_2; b=b+1) begin //: lp2
    //             assign mux_out_gen_2 [a][b]   =   masked_mux_in_2[a+OUT_WIDTH_2*b];
    //         end
    //         assign vc_num_wr[a] = | mux_out_gen_2 [a];
    //     end
    // endgenerate

    assign mask_2[(0+1)*OUT_WIDTH_2-1 : (0)*OUT_WIDTH_2]  =   {OUT_WIDTH_2{vc_num_wr[0]} };
    assign mask_2[(1+1)*OUT_WIDTH_2-1 : (1)*OUT_WIDTH_2]  =   {OUT_WIDTH_2{vc_num_wr[1]} };
    
    assign masked_mux_in_2    = bin_temp_0 & mask_2;

    assign mux_out_gen_2 [0]   =   masked_mux_in_2[0+OUT_WIDTH_2*0];
    assign mux_out_gen_2 [1]   =   masked_mux_in_2[0+OUT_WIDTH_2*1];
        
    assign vc_wr_addr[0] = | mux_out_gen_2 [0*SEL_WIDTH_2+:SEL_WIDTH_2];



    genvar c;
    generate 
        if(ONE_HOT_WIDTH_0>1)begin //:if1
            // for(c=0; c<ONE_HOT_WIDTH_0; c=c+1) begin //:mux_in_gen_loop
            //     assign bin_temp_0[(c+1)*BIN_WIDTH_0-1 : c*BIN_WIDTH_0] =  c[BIN_WIDTH_0-1:0];
               
            // end
            

            
            assign bin_temp_0[(0+1)*BIN_WIDTH_0-1 : 0*BIN_WIDTH_0] =  0;
            assign bin_temp_0[(1+1)*BIN_WIDTH_0-1 : 1*BIN_WIDTH_0] =  1;
            
            // assign bin_temp[(i+1)*BIN_WIDTH-1 : i*BIN_WIDTH] =  i[BIN_WIDTH-1:0];


            
        end else begin //:els
            assign  wr_select_addr = vc_num_wr;
        
        end

    endgenerate

    
     
    // #(
    // .ONE_HOT_WIDTH  (V)
    // 
    // )
    // one_hot_to_bin rd_vc_start_addr
    // (
    // .one_hot_code   (vc_num_rd),
    // .bin_code       (rd_select_addr)

    // );

    parameter ONE_HOT_WIDTH_1 =   2;
    parameter BIN_WIDTH_1     =  1;
        // parameter BIN_WIDTH     =  (ONE_HOT_WIDTH>1)? log2(ONE_HOT_WIDTH):1

    localparam MUX_IN_WIDTH_1 =   BIN_WIDTH_1* ONE_HOT_WIDTH_1;

    wire [MUX_IN_WIDTH_1-1        :   0]  bin_temp_1 ;

    // one_hot_mux_2  one_hot_to_bcd_mux //.IN_WIDTH   (MUX_IN_WIDTH),  .SEL_WIDTH  (ONE_HOT_WIDTH)
    //         (
    //             .mux_in     (bin_temp),
    //             .mux_out        (bin_code),
    //             .sel            (one_hot_code)
        
    //         );

    parameter   IN_WIDTH_3      = 2;
    parameter   SEL_WIDTH_3 =   2;
    parameter   OUT_WIDTH_3 = IN_WIDTH_3/SEL_WIDTH_3;

    wire [IN_WIDTH_3-1    :0] mask_3;
    wire [IN_WIDTH_3-1    :0] masked_mux_in_3;
    wire [SEL_WIDTH_3*OUT_WIDTH_3-1:0]    mux_out_gen_3;// [OUT_WIDTH_3-1:0]; 
    
    // genvar f,s;
    // // integer x;
    // //first selector masking
    // generate    // first_mask = {sel[0],sel[0],sel[0],....,sel[n],sel[n],sel[n]}
    //     for(f=0; f<SEL_WIDTH_3; f=f+1) begin //: mask_loop
    //         assign mask_3[(f+1)*OUT_WIDTH_3-1 : (f)*OUT_WIDTH_3]  =   {OUT_WIDTH_3{vc_num_rd[f]} };
    //     end
        
    //     assign masked_mux_in_3    = bin_temp_1 & mask_3;
        
    //     for(f=0; f<OUT_WIDTH_3; f=f+1) begin //: lp1
    //         for(s=0; s<SEL_WIDTH_3; s=s+1) begin //: lp2
    //             assign mux_out_gen_3 [f][s]   =   masked_mux_in_3[f+OUT_WIDTH_3*s];
    //         end
    //         assign rd_select_addr[f] = | mux_out_gen_3 [f];
    //     end
    // endgenerate

    assign mask_3[(0+1)*OUT_WIDTH_3-1 : (0)*OUT_WIDTH_3]  =   {OUT_WIDTH_3{vc_num_wr[0]} };
    assign mask_3[(1+1)*OUT_WIDTH_3-1 : (1)*OUT_WIDTH_3]  =   {OUT_WIDTH_3{vc_num_wr[1]} };
 
    assign masked_mux_in_3    = bin_temp_1 & mask_3;

    assign mux_out_gen_3 [0]   =   masked_mux_in_3[0+OUT_WIDTH_3*0];
    assign mux_out_gen_3 [1]   =   masked_mux_in_3[0+OUT_WIDTH_3*1];
    
    assign vc_wr_addr[0] = | mux_out_gen_3 [0*OUT_WIDTH_3+:SEL_WIDTH_3];

    genvar d;
    generate 
        if(ONE_HOT_WIDTH_1>1)begin :if1
            // for(d=0; d<ONE_HOT_WIDTH_1; d=d+1) begin //:mux_in_gen_loop
            //     assign bin_temp_1[(d+1)*BIN_WIDTH_1-1 : d*BIN_WIDTH_1] =  d[BIN_WIDTH_1-1:0];
            // end
            assign bin_temp_1[(0+1)*BIN_WIDTH_1-1 : 0*BIN_WIDTH_1] =  0;
            assign bin_temp_1[(1+1)*BIN_WIDTH_1-1 : 1*BIN_WIDTH_1] =  1;

        end else begin :els
            assign  rd_select_addr = vc_num_rd;
        
        end

    endgenerate

    // fifo_ram   
    //  #(
    //     .DATA_WIDTH (RAM_DATA_WIDTH),
    //     .ADDR_WIDTH (BVw ),
    //     .SSA_EN(SSA_EN)       
    // )
    // fifo_ram the_queue
    // (
    //     .wr_data        (fifo_ram_din), 
    //     .wr_addr        (wr_addr[BVw-1  :   0]),
    //     .rd_addr        (rd_addr[BVw-1  :   0]),
    //     .wr_en          (wr_en),
    //     .rd_en          (rd_en),
    //     .clk            (clk),
    //     .rd_data        (fifo_ram_dout)
    // );  
    
    // module fifo_ram     
    // (
    //     input [DATA_WIDTH-1         :       0]  wr_data,        
    //     input [ADDR_WIDTH-1         :       0]      wr_addr,
    //     input [ADDR_WIDTH-1         :       0]      rd_addr,
    //     input                                               wr_en,
    //     input                                               rd_en,
    //     input                                           clk,
    //     output [DATA_WIDTH-1   :       0]      rd_data
    // );  
    parameter DATA_WIDTH    = 34;
    parameter ADDR_WIDTH    = 4;
    // parameter SSA_EN="NO" ;// "YES" , "NO"       
    
	reg [DATA_WIDTH-1:0] memory_rd_data; 
   // memory/
	reg [DATA_WIDTH*(2**ADDR_WIDTH)-1:0] queue ;//[2**ADDR_WIDTH-1:0] /* synthesis ramstyle = "no_rw_check , M9K" */;
	always @(posedge clk ) begin
			if (wr_en)
				 queue[DATA_WIDTH*(wr_addr[BVw-1  :   0])+:DATA_WIDTH] <= fifo_ram_din;
			if (rd_en)
				 memory_rd_data <=
//synthesis translate_off
//synopsys  translate_off
					  #1
//synopsys  translate_on
//synthesis translate_on   
					  queue[DATA_WIDTH*(rd_addr[BVw-1  :   0])+:DATA_WIDTH];
	end
	// assert property (  (wr_data[14:9]==6'b111111));
    // assert property ( (memory_rd_data[14:9]==6'b111111));

    generate 
    /* verilator lint_off WIDTH */
        assign fifo_ram_dout =  memory_rd_data;

    endgenerate



//end fifo


// generate
//     for(i=0;i<V;i=i+1) begin :loop0
        
//         assign  wr_ptr_array[(i+1)*Bw- 1        :   i*Bw]   =       wr_ptr[i];
//         assign  rd_ptr_array[(i+1)*Bw- 1        :   i*Bw]   =       rd_ptr[i];
//         //assign    vc_nearly_full[i] = (depth[i] >= B-1);
//         assign  vc_not_empty    [i] =   (depth[i] > 0);
    
    
//         always @(posedge clk or posedge reset) begin
//             if (reset) begin
//                 rd_ptr  [i] <= {Bw{1'b0}};
//                 wr_ptr  [i] <= {Bw{1'b0}};
//                 depth   [i] <= {DEPTHw{1'b0}};
//             end
//             else begin
//                 if (wr[i] && depth[i] != B) wr_ptr[i] <= wr_ptr [i]+ 1'h1;
//                 if (rd[i] && (depth[i] != {DEPTHw{1'b0}})) rd_ptr [i]<= rd_ptr [i]+ 1'h1;
//                 if (wr[i] & ~rd[i]) depth [i]<=
//                 //synthesis translate_off
//                 //synopsys  translate_off
//                    #1
//                 //synopsys  translate_on
//                 //synthesis translate_on
//                    depth[i] + 1'h1;
//                 else if (~wr[i] & rd[i]) depth [i]<=
//                 //synthesis translate_off
//                 //synopsys  translate_off
//                    #1
//                 //synopsys  translate_on
//                 //synthesis translate_on
//                    depth[i] - 1'h1;
//             end//else
//         end//always

//         //synthesis translate_off
//         //synopsys  translate_off
    
//         always @(posedge clk) begin
//             if(~reset)begin
//                 if (wr[i] && (depth[i] == B) && !rd[i])
//                     $display("%t: ERROR: Attempt to write to full FIFO:FIFO size is %d. %m",$time,B);
//                 /* verilator lint_off WIDTH */
//                 if (rd[i] && (depth[i] == {DEPTHw{1'b0}} &&  SSA_EN !="YES"  ))
//                     $display("%t: ERROR: Attempt to read an empty FIFO: %m",$time);
//                 if (rd[i] && !wr[i] && (depth[i] == {DEPTHw{1'b0}} &&  SSA_EN =="YES" ))
//                     $display("%t: ERROR: Attempt to read an empty FIFO: %m",$time);
//                 /* verilator lint_on WIDTH */
          
//             end//~reset      
//         end//always

     
//             // Asserting the Property b1 : Read and write pointers are incremented when r_en/w_en are set
//             // Asserting the property b3 : Read and Write pointers are not incremented when the buffer is empty and full
//             // Asserting the property b4 : Buffer can not be both full and empty at the same time
                            
//         // Branch statements
//         always@(posedge clk) begin
//             //b1.1
//             if (wr[i] && depth[i] != B && !reset) begin
//                 wr_ptr_check[i] <= wr_ptr[i];
//             end  
//             //b1.2
//             if (rd[i] && (depth[i] != {DEPTHw{1'b0}}) && !reset) begin
//                 rd_ptr_check[i] <= rd_ptr[i];
//             end
//             //b3.1 trying to write to full buffer
//             if (wr[i] & ~rd[i] && (depth[i] == B) && !reset) begin
//                 wr_ptr_check[i] <= wr_ptr[i];
//             end
//             //b3.2 trying to read from empty buffer
//             if (rd[i] && !wr[i] && (depth[i] == {DEPTHw{1'b0}}) && !reset) begin
//                 rd_ptr_check[i] <= rd_ptr[i];
//             end
//         end            
            
//     end//for
// endgenerate

    assign  wr_ptr_array[(0+1)*Bw- 1        :   0*Bw]   =       wr_ptr[Bw*0+:Bw];
    assign  rd_ptr_array[(0+1)*Bw- 1        :   0*Bw]   =       rd_ptr[Bw*0+:Bw];
    //assign    vc_nearly_full[0] = (depth[DEPTHw*0+:DEPTHw] >= B-1);
    assign  vc_not_empty    [0] =   (depth[DEPTHw*0+:DEPTHw] > 0);


    always @(posedge clk or posedge reset) begin
        if (reset) begin
            rd_ptr  [0] <= {Bw{1'b0}};
            wr_ptr  [0] <= {Bw{1'b0}};
            depth   [V*0+:DEPTHw] <= {DEPTHw{1'b0}};
        end
        else begin
            if (wr[0] && depth[DEPTHw*0+:DEPTHw] != B) wr_ptr[Bw*0+:Bw] <= wr_ptr [0]+ 1'h1;
            if (rd[0] && (depth[DEPTHw*0+:DEPTHw] != {DEPTHw{1'b0}})) rd_ptr [0]<= rd_ptr [0]+ 1'h1;
            if (wr[0] & ~rd[0]) depth [V*0+:DEPTHw]<=
            //synthesis translate_off
            //synopsys  translate_off
                #1
            //synopsys  translate_on
            //synthesis translate_on
                depth[DEPTHw*0+:DEPTHw] + 1'h1;
            else if (~wr[0] & rd[0]) depth [0]<=
            //synthesis translate_off
            //synopsys  translate_off
                #1
            //synopsys  translate_on
            //synthesis translate_on
                depth[DEPTHw*0+:DEPTHw] - 1'h1;
        end//else
    end//always

    //synthesis translate_off
    //synopsys  translate_off

    always @(posedge clk) begin
        if(~reset)begin
            if (wr[0] && (depth[DEPTHw*0+:DEPTHw] == B) && !rd[0])
                $display("%t: ERROR: Attempt to write to full FIFO:FIFO size is %d. %m",$time,B);
            /* verilator lint_off WIDTH */
            if (rd[0] && (depth[DEPTHw*0+:DEPTHw] == {DEPTHw{1'b0}} &&  SSA_EN !="YES"  ))
                $display("%t: ERROR: Attempt to read an empty FIFO: %m",$time);
            if (rd[0] && !wr[0] && (depth[DEPTHw*0+:DEPTHw] == {DEPTHw{1'b0}} &&  SSA_EN =="YES" ))
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
        if (wr[0] && depth[DEPTHw*0+:DEPTHw] != B && !reset) begin
            wr_ptr_check[0] <= wr_ptr[Bw*0+:Bw];
        end  
        //b1.2
        if (rd[0] && (depth[DEPTHw*0+:DEPTHw] != {DEPTHw{1'b0}}) && !reset) begin
            rd_ptr_check[0] <= rd_ptr[Bw*0+:Bw];
        end
        //b3.1 trying to write to full buffer
        if (wr[0] & ~rd[0] && (depth[DEPTHw*0+:DEPTHw] == B) && !reset) begin
            wr_ptr_check[0] <= wr_ptr[Bw*0+:Bw];
        end
        //b3.2 trying to read from empty buffer
        if (rd[0] && !wr[0] && (depth[DEPTHw*0+:DEPTHw] == {DEPTHw{1'b0}}) && !reset) begin
            rd_ptr_check[0] <= rd_ptr[Bw*0+:Bw];
        end
    end  

    assign  wr_ptr_array[(1+1)*Bw- 1        :   1*Bw]   =       wr_ptr[Bw*1+:Bw];
    assign  rd_ptr_array[(1+1)*Bw- 1        :   1*Bw]   =       rd_ptr[Bw*1+:Bw];
    //assign    vc_nearly_full[1] = (depth[DEPTHw*1+:DEPTHw] >= B-1);
    assign  vc_not_empty    [1] =   (depth[DEPTHw*1+:DEPTHw] > 0);


    always @(posedge clk or posedge reset) begin
        if (reset) begin
            rd_ptr  [1] <= {Bw{1'b0}};
            wr_ptr  [1] <= {Bw{1'b0}};
            depth   [1] <= {DEPTHw{1'b0}};
        end
        else begin
            if (wr[1] && depth[DEPTHw*1+:DEPTHw] != B) wr_ptr[Bw*1+:Bw] <= wr_ptr [1]+ 1'h1;
            if (rd[1] && (depth[DEPTHw*1+:DEPTHw] != {DEPTHw{1'b0}})) rd_ptr [1]<= rd_ptr [1]+ 1'h1;
            if (wr[1] & ~rd[1]) depth [1]<=
            //synthesis translate_off
            //synopsys  translate_off
                #1
            //synopsys  translate_on
            //synthesis translate_on
                depth[DEPTHw*1+:DEPTHw] + 1'h1;
            else if (~wr[1] & rd[1]) depth [1]<=
            //synthesis translate_off
            //synopsys  translate_off
                #1
            //synopsys  translate_on
            //synthesis translate_on
                depth[DEPTHw*1+:DEPTHw] - 1'h1;
        end//else
    end//always

    //synthesis translate_off
    //synopsys  translate_off

    always @(posedge clk) begin
        if(~reset)begin
            if (wr[1] && (depth[DEPTHw*1+:DEPTHw] == B) && !rd[1])
                $display("%t: ERROR: Attempt to write to full FIFO:FIFO size is %d. %m",$time,B);
            /* verilator lint_off WIDTH */
            if (rd[1] && (depth[DEPTHw*1+:DEPTHw] == {DEPTHw{1'b0}} &&  SSA_EN !="YES"  ))
                $display("%t: ERROR: Attempt to read an empty FIFO: %m",$time);
            if (rd[1] && !wr[1] && (depth[DEPTHw*1+:DEPTHw] == {DEPTHw{1'b0}} &&  SSA_EN =="YES" ))
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
        if (wr[1] && depth[DEPTHw*1+:DEPTHw] != B && !reset) begin
            wr_ptr_check[Bw*1+:Bw] <= wr_ptr[Bw*1+:Bw];
        end  
        //b1.2
        if (rd[1] && (depth[DEPTHw*1+:DEPTHw] != {DEPTHw{1'b0}}) && !reset) begin
            rd_ptr_check[Bw*1+:Bw] <= rd_ptr[Bw*1+:Bw];
        end
        //b3.1 trying to write to full buffer
        if (wr[1] & ~rd[1] && (depth[DEPTHw*1+:DEPTHw] == B) && !reset) begin
            wr_ptr_check[Bw*1+:Bw] <= wr_ptr[Bw*1+:Bw];
        end
        //b3.2 trying to read from empty buffer
        if (rd[1] && !wr[1] && (depth[DEPTHw*1+:DEPTHw] == {DEPTHw{1'b0}}) && !reset) begin
            rd_ptr_check[Bw*1+:Bw] <= rd_ptr[Bw*1+:Bw];
        end
    end           
        
            
        


    always@(posedge clk) begin 
        //b6 counter enable
        if (din[35]) begin
            pkt_count_flag_in<=1'b1;
        end
        if (din[34]) begin
            pkt_count_flag_in<=1'b0;
        end
        if (pkt_count_flag_in) begin
            if(wr_en) b6_buffer_counter<=b6_buffer_counter+1'b1;
        end
        if (dout[35]) begin
            pkt_count_flag_out<=1'b1;
        end
        if (dout[34]) begin
            pkt_count_flag_out<=1'b0;
        end
        if (pkt_count_flag_out) begin
            if(rd_en) b6_buffer_counter<=b6_buffer_counter-1'b1;
        end
    end

    //b4
    assert property ( @(posedge clk) (!(depth[DEPTHw*0+:DEPTHw] == {DEPTHw{1'b0}} && depth[DEPTHw*0+:DEPTHw] == B))); 
    assert property ( @(posedge clk) (!(depth[DEPTHw*1+:DEPTHw] == {DEPTHw{1'b0}} && depth[DEPTHw*1+:DEPTHw] == B))); 
    //b1
    assert property ((wr[0] && !reset && (!rd[0] && depth[DEPTHw*0+:DEPTHw] != B)) |=> (wr_ptr[Bw*0+:Bw]== (wr_ptr_check[0] +1'h1 )));
    assert property ((wr[1] && !reset && (!rd[1] && depth[DEPTHw*1+:DEPTHw] != B)) |=> (wr_ptr[Bw*1+:Bw]== (wr_ptr_check[Bw*1+:Bw] +1'h1 )));
    assert property ((rd[0] && !reset && (!wr[0] && depth[DEPTHw*0+:DEPTHw] != {DEPTHw{1'b0}})) |=> (rd_ptr[Bw*0+:Bw]== (rd_ptr_check[0] +1'h1 )));
    assert property ((rd[1] && !reset && (!wr[1] && depth[DEPTHw*1+:DEPTHw] != {DEPTHw{1'b0}})) |=> (rd_ptr[Bw*1+:Bw]== (rd_ptr_check[Bw*1+:Bw] +1'h1 )));
    //b3
    assert property ((wr[0] & ~rd[0] && !reset  && (depth[DEPTHw*0+:DEPTHw] == B)) |=> (wr_ptr[Bw*0+:Bw]== wr_ptr_check[0]));
    assert property ((wr[1] & ~rd[1] && !reset  && (depth[DEPTHw*1+:DEPTHw] == B)) |=> (wr_ptr[Bw*1+:Bw]== wr_ptr_check[Bw*1+:Bw]));
    assert property ((~wr[0] & rd[0] && depth[DEPTHw*0+:DEPTHw] == {DEPTHw{1'b0}} && !reset) |=> (rd_ptr[Bw*0+:Bw]== rd_ptr_check[0]));
    assert property ((~wr[1] & rd[1] && depth[DEPTHw*1+:DEPTHw] == {DEPTHw{1'b0}} && !reset) |=> (rd_ptr[Bw*1+:Bw]== rd_ptr_check[Bw*1+:Bw]));
    //b2
    assert property (age_ptr[0] |=> (packet_age[15*0+:15]== (packet_age_check[15*0+:15] +1'h1 )));
    assert property (age_ptr[1] |=> (packet_age[15*1+:15]== (packet_age_check[15*1+:15] +1'h1 )));
    assert property (age_ptr[2] |=> (packet_age[15*2+:15]== (packet_age_check[15*2+:15] +1'h1 )));
    assert property (age_ptr[3] |=> (packet_age[15*3+:15]== (packet_age_check[15*3+:15] +1'h1 )));
   
    b6
    assert property (dout[34] |-> b6_buffer_counter==1'b0);
    b5
    assert property ( (dout[35]) |-> ( 
                        (packet_age_check[8*0+:8]==dout[8:0])
                    ||  (packet_age_check[8*1+:8]==dout[8:0])
                    ||  (packet_age_check[8*2+:8]==dout[8:0])
                    ||  (packet_age_check[8*3+:8]==dout[8:0])
                    // ||  (packet_age_check[8*4+:8]==dout[8:0])
                    // ||  (packet_age_check[8*5+:8]==dout[8:0])
                    // ||  (packet_age_check[8*6+:8]==dout[8:0])
                    // ||  (packet_age_check[8*7+:8]==dout[8:0])
                                                        ));
    // assert property ( (fifo_ram_dout[Fpay+1])  |-> (fifo_ram_dout[14:9]==6'b111111));

    //R6
    assert property ( (age_ptr[0])|=> (packet_age[15*0+:15] > Tmin));
    assert property ( (age_ptr[0])|=> (packet_age[15*0+:15] > Tmin));
    assert property ( (age_ptr[0])|=> (packet_age[15*0+:15] > Tmin));
    assert property ( (age_ptr[0])|=> (packet_age[15*0+:15] > Tmin));


    //R7
    assert property (age_ptr[0] |=> (packet_age[15*0+:15] < Tmax));
    assert property (age_ptr[1] |=> (packet_age[15*1+:15] < Tmax));
    assert property (age_ptr[2] |=> (packet_age[15*2+:15] < Tmax));
    assert property (age_ptr[3] |=> (packet_age[15*3+:15] < Tmax));





    always @(posedge clk) begin
        if (wr_en) begin      
            // Asserting the property b5 : Data that was read from the buffer was at some point in time written into the buffer
            // Asserting the property b6 : The same number of packets that were written in to the buffer can be read from the buffer

            // b5 : adding the header to monitoring list
            // b5_check_buffer[wr_addr]=din;
            if (din[35]==1'b1) begin // Header found
                b5_check_buffer[b5_wr_addr]<=din[8:0];
                // din[15:9]<=6'b111111;
                age_ptr[b5_wr_addr]<=1'b1;
                packet_age[b5_wr_addr]<=1'b0;
                b5_wr_addr<=b5_wr_addr+ 1'b1;   
            end
        end

        if (rd_en) begin      
            // b5 : removing the header from the monitoring list
            if (dout[35]==1'b1) begin // Header found
                if (b5_check_buffer[b5_rd_addr]==dout[8:0]) begin
                    $display("b5 done");
                    if (packet_age[b5_rd_addr] > Tmin) $display(" R6 succeeded");
                    else $display(" $error :R6 failed in %m at %t", $time);
                    b5_check_buffer[b5_rd_addr]<=9'b0;
                    age_ptr[b5_rd_addr]<=1'b0; // resetting age pointer
                    packet_age[b5_rd_addr]<=1'b0;
                    b5_rd_addr<=b5_rd_addr+1'b1;
                end
                

                // $display (" buffer out %b",dout[31:0]);
                // for(z=0;z<CL;z=z+1) begin :asserion_check_loop2
                //     // $display ("buffer_values %b",b5_check_buffer[z]);
                //     // branch statement
                //     // b5
                //     if (b5_check_ptr[z]==1'b1 && (b5_check_buffer[z])==dout[8:0] && rd_flag ) begin // Compare with check buffer
                //         // $display("(Property b2) packet %b stayed in buffer for %d ticks at %m",b5_check_buffer[z],packet_age[z]);
                //         b5_check_buffer[z]<=9'b0;
                //         b5_check_ptr[z]<=1'b0; // reset check buffer pointer
                //         age_ptr[z]=1'b0; // resetting age pointer
                //         rd_flag <= 1'b0; 
                //         packet_age[z]=1'b0; // resetting age

                //         // branch statement
                //         //R6
                //         if (packet_age[z] > Tmin) $display(" R6 succeeded");
                //         else $display(" $error :R6 failed in %m at %t", $time);
                        
                //         // assertion statements
                //         //R6
                //          // assert (packet_age[z] > Tmin);
                //     end    
                //      // Packet not found in the check buffer
                // end
            end
            // else rd_flag <= 1'b0;
            // if (packet_count_flag_out) begin
            //     b6_buffer_counter[z]<=b6_buffer_counter[z] - 1'b1; // Counting payload and tail packets that are leaving buffer
            // end
            // if (dout[34]==1'b1 && packet_count_flag_out) begin // tail packet found
            //     packet_count_flag_out<=1'b0;
            //     // branch statement
            //     //b6
            //     // if (b6_buffer_counter[z]==1'b0) $display(" b6 succeeded");
            //     // else $display(" $error :b6 failed in %m at %t", $time);
            //     // assertion statements
            //     //b6
            // end
        end
        // b2 implementation
        // for(p=0;p<CL;p=p+1) begin
        //     if (age_ptr[p]==1'b1) begin
        //         packet_age[p]<=packet_age[p]+1'b1; // Counting the age of packets inside the buffer
        //         if (!packet_age[p] < Tmax) begin
        //             packet_age[p]<=16'b0;
        //         end
                
        //         // branch statement
        //         //R7
        //         // if (packet_age[p] < Tmax) $display(" R7 succeeded"); //assuming no fail in a1 ∧ a2 ∧ a3 ∧ b1 ∧ b2 ∧ b4 ∧ m1 ∧ r1 ∧ r2 ∧ r3
        //         // else $display(" $error :R7 failed in %m at %t", $time);
                

        //     end
        // end

        if (age_ptr[0]==1'b1) begin
            packet_age[15*0+:15]<=packet_age[15*0+:15]+1'b1; // Counting the age of packets inside the buffer
            if (!packet_age[15*0+:15] < Tmax) begin
                packet_age[15*0+:15]<=16'b0;
            end                          
        end
        if (age_ptr[1]==1'b1) begin
            packet_age[15*1+:15]<=packet_age[15*1+:15]+1'b1; // Counting the age of packets inside the buffer
            if (!packet_age[15*1+:15] < Tmax) begin
                packet_age[15*1+:15]<=16'b0;
            end                          
        end
        if (age_ptr[2]==1'b1) begin
            packet_age[15*2+:15]<=packet_age[15*2+:15]+1'b1; // Counting the age of packets inside the buffer
            if (!packet_age[15*2+:15] < Tmax) begin
                packet_age[15*2+:15]<=16'b0;
            end                          
        end
        if (age_ptr[3]==1'b1) begin
            packet_age[15*3+:15]<=packet_age[15*3+:15]+1'b1; // Counting the age of packets inside the buffer
            if (!packet_age[15*3+:15] < Tmax) begin
                packet_age[15*3+:15]<=16'b0;
            end                          
        end
        // if (age_ptr[4]==1'b1) begin
        //     packet_age[4]<=packet_age[4]+1'b1; // Counting the age of packets inside the buffer
        //     if (!packet_age[4] < Tmax) begin
        //         packet_age[4]<=16'b0;
        //     end                          
        // end
        // if (age_ptr[5]==1'b1) begin
        //     packet_age[5]<=packet_age[5]+1'b1; // Counting the age of packets inside the buffer
        //     if (!packet_age[5] < Tmax) begin
        //         packet_age[5]<=16'b0;
        //     end                          
        // end
        // if (age_ptr[6]==1'b1) begin
        //     packet_age[6]<=packet_age[6]+1'b1; // Counting the age of packets inside the buffer
        //     if (!packet_age[6] < Tmax) begin
        //         packet_age[6]<=16'b0;
        //     end                          
        // end
        // if (age_ptr[7]==1'b1) begin
        //     packet_age[7]<=packet_age[7]+1'b1; // Counting the age of packets inside the buffer
        //     if (!packet_age[7] < Tmax) begin
        //         packet_age[7]<=16'b0;
        //     end                          
        // end
        // if (age_ptr[8]==1'b1) begin
        //     packet_age[8]<=packet_age[8]+1'b1; // Counting the age of packets inside the buffer
        //     if (!packet_age[8] < Tmax) begin
        //         packet_age[8]<=16'b0;
        //     end                          
        // end
        // if (age_ptr[9]==1'b1) begin
        //     packet_age[9]<=packet_age[9]+1'b1; // Counting the age of packets inside the buffer
        //     if (!packet_age[9] < Tmax) begin
        //         packet_age[9]<=16'b0;
        //     end                          
        // end


        

        //b2 checks
        // for(q=0;q<CL;q=q+1) begin :asserion_check_loop4
        //     // branch statement check
        //     //b2
        //     if (age_ptr[q]==1'b1) begin
        //         packet_age_check[q]<=packet_age[q]; // assign previous clock value to check buffer
        //     end
        // end

        if (age_ptr[0]==1'b1) begin
            packet_age_check[15*0+:15]<=packet_age[15*0+:15]; // assign previous clock value to check buffer
        end
        if (age_ptr[1]==1'b1) begin
            packet_age_check[15*1+:15]<=packet_age[15*1+:15]; // assign previous clock value to check buffer
        end
        if (age_ptr[2]==1'b1) begin
            packet_age_check[15*2+:15]<=packet_age[15*2+:15]; // assign previous clock value to check buffer
        end
        if (age_ptr[3]==1'b1) begin
            packet_age_check[15*3+:15]<=packet_age[15*3+:15]; // assign previous clock value to check buffer
        end
        // if (age_ptr[4]==1'b1) begin
        //     packet_age_check[4]<=packet_age[4]; // assign previous clock value to check buffer
        // end
        // if (age_ptr[5]==1'b1) begin
        //     packet_age_check[5]<=packet_age[5]; // assign previous clock value to check buffer
        // end
        // if (age_ptr[6]==1'b1) begin
        //     packet_age_check[6]<=packet_age[6]; // assign previous clock value to check buffer
        // end
        // if (age_ptr[7]==1'b1) begin
        //     packet_age_check[7]<=packet_age[7]; // assign previous clock value to check buffer
        // end
        // if (age_ptr[8]==1'b1) begin
        //     packet_age_check[8]<=packet_age[8]; // assign previous clock value to check buffer
        // end
        // if (age_ptr[9]==1'b1) begin
        //     packet_age_check[9]<=packet_age[9]; // assign previous clock value to check buffer
        // end

    end //Always
    // assertion statements
    //b5
    // assert property ( (dout[35]==1'b1) |-> ( 
    //                 (b5_check_ptr[0] && (packet_age_check[8*0+:8]==dout[8:0]))
    //                 || (b5_check_ptr[1] && (packet_age_check[8*1+:8]==dout[8:0]))
    //                 || (b5_check_ptr[2] && (packet_age_check[8*2+:8]==dout[8:0]))
    //                 || (b5_check_ptr[3] && (packet_age_check[8*3+:8]==dout[8:0]))
    //                 || (b5_check_ptr[4]&& (packet_age_check[8*4+:8]==dout[8:0]))
    //                 || (b5_check_ptr[5] && (packet_age_check[8*5+:8]==dout[8:0]))
    //                 || (b5_check_ptr[6] && (packet_age_check[8*6+:8]==dout[8:0]))
    //                 || (b5_check_ptr[7] && (packet_age_check[8*7+:8]==dout[8:0]))
   
    //b5
    // assert property ((din[35]==1'b1)|-> s_eventually (dout[8:0]==(packet_age_check[8*0+:8] || dout[8:0]==packet_age_check[8*1+:8] || dout[8:0]==packet_age_check[8*2+:8] || dout[8:0]==packet_age_check[8*3+:8])));
    // assert property ((dout[35]==1'b1) |-> (dout[8:0]==(packet_age_check[8*0+:8] || dout[8:0]==packet_age_check[8*1+:8] || dout[8:0]==packet_age_check[8*2+:8] || dout[8:0]==packet_age_check[8*3+:8])));

   

endmodule 

// module one_hot_mux 
//     (
//         input [IN_WIDTH-1       :0] mux_in,
//         output[OUT_WIDTH-1  :0] mux_out,
//         input[SEL_WIDTH-1   :0] sel

//     );
    
//     parameter   IN_WIDTH      = 8;
//     parameter   SEL_WIDTH =   4;
//     parameter   OUT_WIDTH = IN_WIDTH/SEL_WIDTH;

//     wire [IN_WIDTH-1    :0] mask;
//     wire [IN_WIDTH-1    :0] masked_mux_in;
//     wire [SEL_WIDTH-1:0]    mux_out_gen [OUT_WIDTH-1:0]; 
    
//     genvar i,j;
//     integer x;
//     //first selector masking
//     generate    // first_mask = {sel[0],sel[0],sel[0],....,sel[n],sel[n],sel[n]}
//         for(i=0; i<SEL_WIDTH; i=i+1) begin : mask_loop
//             assign mask[(i+1)*OUT_WIDTH-1 : (i)*OUT_WIDTH]  =   {OUT_WIDTH{sel[i]} };
//         end
        
//         assign masked_mux_in    = mux_in & mask;
        
//         for(i=0; i<OUT_WIDTH; i=i+1) begin : lp1
//             for(j=0; j<SEL_WIDTH; j=j+1) begin : lp2
//                 assign mux_out_gen [i][j]   =   masked_mux_in[i+OUT_WIDTH*j];
//             end
//             assign mux_out[i] = | mux_out_gen [i];
//         end
//     endgenerate

// endmodule

// module one_hot_mux_2 
//     (
//         input [IN_WIDTH-1       :0] mux_in,
//         output[OUT_WIDTH-1  :0] mux_out,
//         input[SEL_WIDTH-1   :0] sel

//     );
    
//     parameter   IN_WIDTH      = 2;
//     parameter   SEL_WIDTH =   2;
//     parameter   OUT_WIDTH = IN_WIDTH/SEL_WIDTH;

//     wire [IN_WIDTH-1    :0] mask;
//     wire [IN_WIDTH-1    :0] masked_mux_in;
//     wire [SEL_WIDTH-1:0]    mux_out_gen [OUT_WIDTH-1:0]; 
    
//     genvar i,j;
//     integer x;
//     //first selector masking
//     generate    // first_mask = {sel[0],sel[0],sel[0],....,sel[n],sel[n],sel[n]}
//         for(i=0; i<SEL_WIDTH; i=i+1) begin : mask_loop
//             assign mask[(i+1)*OUT_WIDTH-1 : (i)*OUT_WIDTH]  =   {OUT_WIDTH{sel[i]} };
//         end
        
//         assign masked_mux_in    = mux_in & mask;
        
//         for(i=0; i<OUT_WIDTH; i=i+1) begin : lp1
//             for(j=0; j<SEL_WIDTH; j=j+1) begin : lp2
//                 assign mux_out_gen [i][j]   =   masked_mux_in[i+OUT_WIDTH*j];
//             end
//             assign mux_out[i] = | mux_out_gen [i];
//         end
//     endgenerate


    // Asserting the Property m1 : During multiplexing output data shlould be equal to input data
    
    // always @ * begin
    //     // $display("in %b sel %b out %b", mux_in,sel, mux_out);
    //     
    //     // if (sel!=1'b0 && $onehot(sel)) begin
    //         // for(x=0;x<SEL_WIDTH;x=x+1) begin :asserion_check_loop0
    //             // Branch statement
    //             //m1
    //             // if (sel[x]==1) begin
    //             //     if (mux_in[OUT_WIDTH*(x)+:OUT_WIDTH]==mux_out) $display(" m1 succeeded");  
    //             //     else $display(" $error :m1 failed in %m at %t", $time);          
    //             // end
    //             // Assert statement
    //             //m1
    //             assert (!$onehot(sel) || sel!=1'b0 || (sel[0]==1'b1 && (mux_in[OUT_WIDTH*(0)+:OUT_WIDTH]==mux_out))==1);
    //             assert (!$onehot(sel) || sel!=1'b0 || (sel[1]==1'b1 && (mux_in[OUT_WIDTH*(1)+:OUT_WIDTH]==mux_out))==1);
    //             // assert (!$onehot(sel) || sel!=1'b0 || (sel[2]==1'b1 && (mux_in[OUT_WIDTH*(2)+:OUT_WIDTH]==mux_out))==1);
    //             // assert (!$onehot(sel) || sel!=1'b0 || (sel[3]==1'b1 && (mux_in[OUT_WIDTH*(3)+:OUT_WIDTH]==mux_out))==1);
    //         // end
    //     // end
    //     

    // end
    


// endmodule



// module fifo_ram     
//     (
//         input [DATA_WIDTH-1         :       0]  wr_data,        
//         input [ADDR_WIDTH-1         :       0]      wr_addr,
//         input [ADDR_WIDTH-1         :       0]      rd_addr,
//         input                                               wr_en,
//         input                                               rd_en,
//         input                                           clk,
//         output [DATA_WIDTH-1   :       0]      rd_data
//     );  
//     parameter DATA_WIDTH    = 34;
//     parameter ADDR_WIDTH    = 4;
//     parameter SSA_EN="NO" ;// "YES" , "NO"       
    
// 	reg [DATA_WIDTH-1:0] memory_rd_data; 
//    // memory
// 	reg [DATA_WIDTH-1:0] queue [2**ADDR_WIDTH-1:0] /* synthesis ramstyle = "no_rw_check , M9K" */;
// 	always @(posedge clk ) begin
// 			if (wr_en)
// 				 queue[wr_addr] <= wr_data;
// 			if (rd_en)
// 				 memory_rd_data <=
// //synthesis translate_off
// //synopsys  translate_off
// 					  #1
// //synopsys  translate_on
// //synthesis translate_on   
// 					  queue[rd_addr];
// 	end
// 	// assert property (  (wr_data[14:9]==6'b111111));
//     // assert property ( (memory_rd_data[14:9]==6'b111111));

//     generate 
//     /* verilator lint_off WIDTH */
//         assign rd_data =  memory_rd_data;

//     endgenerate
// endmodule

// module one_hot_to_bin 
// (
//     input   [ONE_HOT_WIDTH-1        :   0] one_hot_code,
//     output  [BIN_WIDTH-1            :   0]  bin_code

// );


    
//     parameter ONE_HOT_WIDTH =   2;
//     parameter BIN_WIDTH     =  1;
//     // parameter BIN_WIDTH     =  (ONE_HOT_WIDTH>1)? log2(ONE_HOT_WIDTH):1

// localparam MUX_IN_WIDTH =   BIN_WIDTH* ONE_HOT_WIDTH;

// wire [MUX_IN_WIDTH-1        :   0]  bin_temp ;

// one_hot_mux_2  one_hot_to_bcd_mux //.IN_WIDTH   (MUX_IN_WIDTH),  .SEL_WIDTH  (ONE_HOT_WIDTH)
//         (
//             .mux_in     (bin_temp),
//             .mux_out        (bin_code),
//             .sel            (one_hot_code)
    
//         );

// genvar i;
// generate 
//     if(ONE_HOT_WIDTH>1)begin :if1
//         for(i=0; i<ONE_HOT_WIDTH; i=i+1) begin :mux_in_gen_loop
//              assign bin_temp[(i+1)*BIN_WIDTH-1 : i*BIN_WIDTH] =  i[BIN_WIDTH-1:0];
//         end


        
//      end else begin :els
//         assign  bin_code = one_hot_code;
     
//      end

// endgenerate

// endmodule
