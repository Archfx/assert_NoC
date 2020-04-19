
/**********************************************************************
**	File: testbench.v
**    
**	Copyright (C) 2014-2019  Alireza Monemi
**    
**	This file is part of ProNoC 1.9.1 
**
**	ProNoC ( stands for Prototype Network-on-chip)  is free software: 
**	you can redistribute it and/or modify it under the terms of the GNU
**	Lesser General Public License as published by the Free Software Foundation,
**	either version 2 of the License, or (at your option) any later version.
**
** 	ProNoC is distributed in the hope that it will be useful, but WITHOUT
** 	ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
** 	or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General
** 	Public License for more details.
**
** 	You should have received a copy of the GNU Lesser General Public
** 	License along with ProNoC. If not, see <http:**www.gnu.org/licenses/>.
******************************************************************************/ 


`timescale	 1ns/1ps

module testbench;

 
  	function integer log2;
  		input integer number; begin	
          	log2=0;	
          	while(2**log2<number) begin	
        		  	log2=log2+1;	
         		end	
        		end	
     	endfunction // log2 
     	
     	function   [15:0]i2s;   
          input   integer c;  integer i;  integer tmp; begin 
              tmp =0; 
              for (i=0; i<2; i=i+1) begin 
              tmp =  tmp +    (((c % 10)   + 48) << i*8); 
                  c       =   c/10; 
              end 
              i2s = tmp[15:0];
          end     
     endfunction //i2s
 


//SOC parameters
 
	 //Parameter setting for mor1k_tile  located in tile: 0 
	 localparam mor1k_tile_0_cpu_FEATURE_DATACACHE="ENABLED";
	 localparam mor1k_tile_0_cpu_FEATURE_DMMU="ENABLED";
	 localparam mor1k_tile_0_cpu_FEATURE_IMMU="ENABLED";
	 localparam mor1k_tile_0_cpu_FEATURE_INSTRUCTIONCACHE="ENABLED";
	 localparam mor1k_tile_0_cpu_IRQ_NUM=32;
	 localparam mor1k_tile_0_cpu_OPTION_DCACHE_SNOOP="NONE";
	 localparam mor1k_tile_0_cpu_OPTION_OPERAND_WIDTH=32;
	 localparam mor1k_tile_0_ram_Aw=14;
	 localparam mor1k_tile_0_ram_Dw=32;
	 localparam mor1k_tile_0_timer_PRESCALER_WIDTH=8;
 
	 //Parameter setting for mor1k_tile  located in tile: 1 
	 localparam mor1k_tile_1_cpu_FEATURE_DATACACHE="ENABLED";
	 localparam mor1k_tile_1_cpu_FEATURE_DMMU="ENABLED";
	 localparam mor1k_tile_1_cpu_FEATURE_IMMU="ENABLED";
	 localparam mor1k_tile_1_cpu_FEATURE_INSTRUCTIONCACHE="ENABLED";
	 localparam mor1k_tile_1_cpu_IRQ_NUM=32;
	 localparam mor1k_tile_1_cpu_OPTION_DCACHE_SNOOP="NONE";
	 localparam mor1k_tile_1_cpu_OPTION_OPERAND_WIDTH=32;
	 localparam mor1k_tile_1_ram_Aw=14;
	 localparam mor1k_tile_1_ram_Dw=32;
	 localparam mor1k_tile_1_timer_PRESCALER_WIDTH=8;
 
	 //Parameter setting for mor1k_tile  located in tile: 2 
	 localparam mor1k_tile_2_cpu_FEATURE_DATACACHE="ENABLED";
	 localparam mor1k_tile_2_cpu_FEATURE_DMMU="ENABLED";
	 localparam mor1k_tile_2_cpu_FEATURE_IMMU="ENABLED";
	 localparam mor1k_tile_2_cpu_FEATURE_INSTRUCTIONCACHE="ENABLED";
	 localparam mor1k_tile_2_cpu_IRQ_NUM=32;
	 localparam mor1k_tile_2_cpu_OPTION_DCACHE_SNOOP="NONE";
	 localparam mor1k_tile_2_cpu_OPTION_OPERAND_WIDTH=32;
	 localparam mor1k_tile_2_ram_Aw=14;
	 localparam mor1k_tile_2_ram_Dw=32;
	 localparam mor1k_tile_2_timer_PRESCALER_WIDTH=8;
 
	 //Parameter setting for mor1k_tile  located in tile: 3 
	 localparam mor1k_tile_3_cpu_FEATURE_DATACACHE="ENABLED";
	 localparam mor1k_tile_3_cpu_FEATURE_DMMU="ENABLED";
	 localparam mor1k_tile_3_cpu_FEATURE_IMMU="ENABLED";
	 localparam mor1k_tile_3_cpu_FEATURE_INSTRUCTIONCACHE="ENABLED";
	 localparam mor1k_tile_3_cpu_IRQ_NUM=32;
	 localparam mor1k_tile_3_cpu_OPTION_DCACHE_SNOOP="NONE";
	 localparam mor1k_tile_3_cpu_OPTION_OPERAND_WIDTH=32;
	 localparam mor1k_tile_3_ram_Aw=14;
	 localparam mor1k_tile_3_ram_Dw=32;
	 localparam mor1k_tile_3_timer_PRESCALER_WIDTH=8;
 


// mor1k_mpsoc.v IO definition 
  reg    clk;
  reg    processors_en;
  reg    reset;



	mor1k_mpsoc uut (
		.clk(clk),
		.processors_en(processors_en),
		.reset(reset)
	);

//clock defination
initial begin 
	forever begin 
	#5 clk=0;

	#5 clk=1;

	end	
end

assert property (@(posedge clk) (!processors_en & !reset));

initial begin 
	// reset mor1k_mpsoc module at the start up
	reset=1;
	
	processors_en=1;

	
	// deasert the reset after 200 ns
	#200
	reset=0;
  


	// write your testbench here




end

endmodule
