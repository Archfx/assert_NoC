
/**************************************************************************
**	WARNING: THIS IS AN AUTO-GENERATED FILE. CHANGES TO IT ARE LIKELY TO BE
**	OVERWRITTEN AND LOST. Rename this file if you wish to do any modification.
****************************************************************************/


/**********************************************************************
**	File: mor1k_mpsoc_top.v
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
module mor1k_mpsoc_top (
 	clk,
	reset ,
	processors_en
);
 
//SOC parameters
 
	 //Parameter setting for mor1k_tile  located in tile: 0 
 
	 //Parameter setting for mor1k_tile  located in tile: 1 
 
	 //Parameter setting for mor1k_tile  located in tile: 2 
 
	 //Parameter setting for mor1k_tile  located in tile: 3 
 
 
//IO
	input	clk,reset;
 	 input processors_en; 
// Allow software to remote reset/enable the cpu via jtag

	wire jtag_cpu_en, jtag_system_reset;

	jtag_system_en jtag_en (
		.cpu_en(jtag_cpu_en),
		.system_reset(jtag_system_reset)
	
	);
	
	wire reset_ored_jtag = reset | jtag_system_reset;
	wire processors_en_anded_jtag = processors_en & jtag_cpu_en;
	
	mor1k_mpsoc the_mor1k_mpsoc (
		
		.clk(clk) ,
		.reset(reset_ored_jtag) ,
		.processors_en(processors_en_anded_jtag)
	
	
	);

endmodule


