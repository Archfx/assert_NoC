module xy_mesh_routing 
(
    current_x,    // current router x address
    current_y,    // current router y address
    dest_x,        // destination x address
    dest_y,        // destination y address
    destport    // router output port
        
);
    
    parameter NX        =    4;
    parameter NY        =    3;
    parameter OUT_BIN =    0 ;   // 1: destination port is in binary format 0: onehot  

    // function integer log2;
    //    integer number=NX; 
    //   begin   
    //      log2_1=(number <=1) ? 1: 0;    
    //      while(2**log2_1<number) begin    
    //         log2_1=log2_1+1;    
    //      end        
    //   end   
    // endfunction // log2 
    
  

    localparam  P            =    5;    // router port number is always 5 in a mesh topology
    
    localparam  Xw            =    2,//log2(NX),
                Yw            =    1,//log2(NY),
                Pw            =    2,//log2(P),
                DSTw          =    (OUT_BIN)? Pw : P;

    
    
    input  [Xw-1        :0]    current_x;
    input  [Yw-1        :0]    current_y;
    input  [Xw-1        :0]    dest_x;
    input  [Yw-1        :0]    dest_y;
    output [DSTw-1            :0]    destport;

    
    

    localparam  LOCAL    =    (OUT_BIN==1)?    0    :  1 ,//5'b00001
                EAST     =    (OUT_BIN==1)?    1    :  2 ,//5'b00010 
                NORTH    =    (OUT_BIN==1)?    2    :  4 ,//5'b00100    
                WEST     =    (OUT_BIN==1)?    3    :  8 ,//5'b01000  
                SOUTH    =    (OUT_BIN==1)?    4    : 16 ;//5'b10000    
    
    
    reg [DSTw-1            :0]    destport_next;
    // reg [DSTw-1            :0]    destport_next_r3;
    
    
        
    assign    destport= destport_next;
    
    always@(*)begin
            destport_next    = LOCAL [DSTw-1    :0];
            if           (dest_x    > current_x)        destport_next    = EAST [DSTw-1    :0];
            else if      (dest_x    < current_x)        destport_next    = WEST [DSTw-1    :0];
            else begin
                if         (dest_y    > current_y)        destport_next    = SOUTH [DSTw-1:0];
                else if      (dest_y    < current_y)        destport_next    = NORTH [DSTw-1    :0];
            end
            // $display("Route mesh values dest port %b",destport);
            // $display("Route mesh values dest x %b , y %b",dest_x,dest_y);

                // Asserting the Property r1 : Route can issue at most one request 
                // Asserting the Property r2 : Route should issue a request whenever a data is valid
                // Asserting the Property r3 : Desired routing algorithm should be correctly implemented

                // Branch statements
                //r1
                if ($onehot0(destport)) $display (" r1 succeeded");
                else $display(" $error :r1 failed in %m at %t", $time);
                //r2
                if (dest_x<=1'b1 && dest_y<=1'b1) $display (" r2 succeeded");
                else $display(" $error :r2 failed in %m at %t", $time);//begin
                //     if (!$isunknown(dest_x) || !$isunknown(dest_y)) $display(" $error :r2 failed in %m at %t", $time);
                // end
                //r3
                if ((dest_x > current_x && destport_next==EAST) || (dest_x < current_x && destport_next==WEST) || (dest_y > current_y && destport_next==SOUTH) || (dest_y < current_y && destport_next==NORTH) || (destport_next==LOCAL)) $display (" r3 succeeded");
                else $display(" $error :r3 failed in %m at %t", $time);

                // Assert statments
                //r1
                assert ($onehot(destport) );
                
                //r2
                assert (dest_x<=2'b11 && dest_y<=1'b1);
                // r3
                assert ((dest_x > current_x && destport_next==EAST) || (dest_x < current_x && destport_next==WEST) || (dest_y > current_y && destport_next==SOUTH) || (dest_y < current_y && destport_next==NORTH) || (destport_next==LOCAL)); 


    end
    
    
endmodule
