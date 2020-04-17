
/**************************************************************************
**	WARNING: THIS IS AN AUTO-GENERATED FILE. CHANGES TO IT ARE LIKELY TO BE
**	OVERWRITTEN AND LOST. Rename this file if you wish to do any modification.
****************************************************************************/


/**********************************************************************
**	File: mor1k_tile.v
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

`timescale 1ns / 1ps
module mor1k_tile #(
 	parameter	CORE_ID=3,
	parameter	SW_LOC="/home/archfx/Documents/NoCem-MPSoC/trunk/mpsoc_work/MPSOC/mor1k_mpsoc/sw/tile3" ,
	parameter	cpu_OPTION_OPERAND_WIDTH=32 ,
	parameter	cpu_IRQ_NUM=32 ,
	parameter	cpu_OPTION_DCACHE_SNOOP="NONE" ,
	parameter	cpu_FEATURE_INSTRUCTIONCACHE="ENABLED" ,
	parameter	cpu_FEATURE_DATACACHE="ENABLED" ,
	parameter	cpu_FEATURE_IMMU="ENABLED" ,
	parameter	cpu_FEATURE_DMMU="ENABLED" ,
	parameter	ni_TOPOLOGY="MESH" ,
	parameter	ni_ROUTE_NAME="XY" ,
	parameter	ni_T1=2 ,
	parameter	ni_T2=2 ,
	parameter	ni_T3=1 ,
	parameter	ni_C=2 ,
	parameter	ni_V=2 ,
	parameter	ni_B=4 ,
	parameter	ni_Fpay=32 ,
	parameter	ni_DEBUG_EN=0 ,
	parameter	ni_RAw=16 ,
	parameter	ni_EAw=16 ,
	parameter	ram_Dw=32 ,
	parameter	ram_Aw=14 ,
	parameter	timer_PRESCALER_WIDTH=8
)(
	source_clk_in, 
	source_reset_in, 
	uart_RxD_din_sim, 
	uart_RxD_ready_sim, 
	uart_RxD_wr_sim, 
	cpu_cpu_en, 
	ni_credit_in, 
	ni_credit_out, 
	ni_current_e_addr, 
	ni_current_r_addr, 
	ni_flit_in, 
	ni_flit_in_wr, 
	ni_flit_out, 
	ni_flit_out_wr
);
  
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
   
 	localparam	uart_FPGA_VENDOR= "ALTERA";
	localparam	uart_SIM_BUFFER_SIZE=1000;
	localparam	uart_SIM_WAIT_COUNT=1000;

 
 	localparam	ni_MAX_TRANSACTION_WIDTH=13;
	localparam	ni_MAX_BURST_SIZE=16;
	localparam	ni_Dw=32;
	localparam	ni_S_Aw=8;
	localparam	ni_M_Aw=32;
	localparam	ni_TAGw=3;
	localparam	ni_SELw=4;
	localparam	ni_Fw=2+ni_V+ni_Fpay;
	localparam	ni_CRC_EN="NO";

 	localparam	ram_BYTE_WR_EN="YES";
	localparam	ram_FPGA_VENDOR="ALTERA";
	localparam	ram_JTAG_CONNECT="DISABLED";
	localparam	ram_JTAG_INDEX=CORE_ID;
	localparam	ram_TAGw=3;
	localparam	ram_SELw=ram_Dw/8;
	localparam	ram_CTIw=3;
	localparam	ram_BTEw=2;
	localparam	ram_BURST_MODE="ENABLED";
	localparam	ram_MEM_CONTENT_FILE_NAME="ram0";
	localparam	ram_INITIAL_EN="YES";
	localparam	ram_INIT_FILE_PATH=SW_LOC;

 	localparam	timer_CNTw=32     ;
	localparam	timer_Dw=32;
	localparam	timer_Aw=3;
	localparam	timer_TAGw=3;
	localparam	timer_SELw=4;

 	localparam	bus_M= 4;
	localparam	bus_S=4;
	localparam	bus_Dw=32;
	localparam	bus_Aw=32;
	localparam	bus_SELw=bus_Dw/8;
	localparam	bus_TAGw=3;
	localparam	bus_CTIw=3;
	localparam	bus_BTEw=2 ;

 
//Wishbone slave base address based on instance name
 	localparam 	uart_WB0_BASE_ADDR	=	32'h24000000;
 	localparam 	uart_WB0_END_ADDR	=	32'h24000007;
 	localparam 	ni_WB0_BASE_ADDR	=	32'h2e000000;
 	localparam 	ni_WB0_END_ADDR	=	32'h2e0000ff;
 	localparam 	ram_WB0_BASE_ADDR	=	32'h00000000;
 	localparam 	ram_WB0_END_ADDR	=	32'h00003fff;
 	localparam 	timer_WB0_BASE_ADDR	=	32'h25800000;
 	localparam 	timer_WB0_END_ADDR	=	32'h25800007;
 
 
//Wishbone slave base address based on module name. 
 	localparam 	jtag_uart0_WB0_BASE_ADDR	=	32'h24000000;
 	localparam 	jtag_uart0_WB0_END_ADDR	=	32'h24000007;
 	localparam 	ni_master0_WB0_BASE_ADDR	=	32'h2e000000;
 	localparam 	ni_master0_WB0_END_ADDR	=	32'h2e0000ff;
 	localparam 	single_port_ram0_WB0_BASE_ADDR	=	32'h00000000;
 	localparam 	single_port_ram0_WB0_END_ADDR	=	32'h00003fff;
 	localparam 	timer0_WB0_BASE_ADDR	=	32'h25800000;
 	localparam 	timer0_WB0_END_ADDR	=	32'h25800007;
 
 	input			source_clk_in;
 	input			source_reset_in;

 	input	 [ 7:0     ] uart_RxD_din_sim;
 	output			uart_RxD_ready_sim;
 	input			uart_RxD_wr_sim;

 	input			cpu_cpu_en;

 	input	 [ ni_V-1    :   0    ] ni_credit_in;
 	output	 [ ni_V-1    :   0    ] ni_credit_out;
 	input	 [ ni_EAw-1   :   0    ] ni_current_e_addr;
 	input	 [ ni_RAw-1   :   0    ] ni_current_r_addr;
 	input	 [ ni_Fw-1   :   0    ] ni_flit_in;
 	input			ni_flit_in_wr;
 	output	 [ ni_Fw-1   :   0    ] ni_flit_out;
 	output			ni_flit_out_wr;

  	wire			 source_socket_clk_0_clk_o;
 	wire			 source_socket_reset_0_reset_o;

  	wire			 uart_plug_clk_0_clk_i;
 	wire			 uart_plug_reset_0_reset_i;
 	wire			 uart_plug_wb_slave_0_ack_o;
 	wire			 uart_plug_wb_slave_0_adr_i;
 	wire	[ 2    :   0 ] uart_plug_wb_slave_0_cti_i;
 	wire			 uart_plug_wb_slave_0_cyc_i;
 	wire	[ 31       :   0 ] uart_plug_wb_slave_0_dat_i;
 	wire	[ 31      :   0 ] uart_plug_wb_slave_0_dat_o;
 	wire	[ 3    :   0 ] uart_plug_wb_slave_0_sel_i;
 	wire			 uart_plug_wb_slave_0_stb_i;
 	wire			 uart_plug_wb_slave_0_we_i;

  	wire			 cpu_plug_clk_0_clk_i;
 	wire			 cpu_plug_wb_master_1_ack_i;
 	wire	[ 31:0 ] cpu_plug_wb_master_1_adr_o;
 	wire	[ 1:0 ] cpu_plug_wb_master_1_bte_o;
 	wire	[ 2:0 ] cpu_plug_wb_master_1_cti_o;
 	wire			 cpu_plug_wb_master_1_cyc_o;
 	wire	[ 31:0 ] cpu_plug_wb_master_1_dat_i;
 	wire	[ 31:0 ] cpu_plug_wb_master_1_dat_o;
 	wire			 cpu_plug_wb_master_1_err_i;
 	wire			 cpu_plug_wb_master_1_rty_i;
 	wire	[ 3:0 ] cpu_plug_wb_master_1_sel_o;
 	wire			 cpu_plug_wb_master_1_stb_o;
 	wire			 cpu_plug_wb_master_1_we_o;
 	wire	[ 31:0 ] cpu_socket_interrupt_peripheral_array_int_i;
 	wire			 cpu_socket_interrupt_peripheral_31_int_i;
 	wire			 cpu_socket_interrupt_peripheral_30_int_i;
 	wire			 cpu_socket_interrupt_peripheral_29_int_i;
 	wire			 cpu_socket_interrupt_peripheral_28_int_i;
 	wire			 cpu_socket_interrupt_peripheral_27_int_i;
 	wire			 cpu_socket_interrupt_peripheral_26_int_i;
 	wire			 cpu_socket_interrupt_peripheral_25_int_i;
 	wire			 cpu_socket_interrupt_peripheral_24_int_i;
 	wire			 cpu_socket_interrupt_peripheral_23_int_i;
 	wire			 cpu_socket_interrupt_peripheral_22_int_i;
 	wire			 cpu_socket_interrupt_peripheral_21_int_i;
 	wire			 cpu_socket_interrupt_peripheral_20_int_i;
 	wire			 cpu_socket_interrupt_peripheral_19_int_i;
 	wire			 cpu_socket_interrupt_peripheral_18_int_i;
 	wire			 cpu_socket_interrupt_peripheral_17_int_i;
 	wire			 cpu_socket_interrupt_peripheral_16_int_i;
 	wire			 cpu_socket_interrupt_peripheral_15_int_i;
 	wire			 cpu_socket_interrupt_peripheral_14_int_i;
 	wire			 cpu_socket_interrupt_peripheral_13_int_i;
 	wire			 cpu_socket_interrupt_peripheral_12_int_i;
 	wire			 cpu_socket_interrupt_peripheral_11_int_i;
 	wire			 cpu_socket_interrupt_peripheral_10_int_i;
 	wire			 cpu_socket_interrupt_peripheral_9_int_i;
 	wire			 cpu_socket_interrupt_peripheral_8_int_i;
 	wire			 cpu_socket_interrupt_peripheral_7_int_i;
 	wire			 cpu_socket_interrupt_peripheral_6_int_i;
 	wire			 cpu_socket_interrupt_peripheral_5_int_i;
 	wire			 cpu_socket_interrupt_peripheral_4_int_i;
 	wire			 cpu_socket_interrupt_peripheral_3_int_i;
 	wire			 cpu_socket_interrupt_peripheral_2_int_i;
 	wire			 cpu_socket_interrupt_peripheral_1_int_i;
 	wire			 cpu_socket_interrupt_peripheral_0_int_i;
 	wire			 cpu_plug_wb_master_0_ack_i;
 	wire	[ 31:0 ] cpu_plug_wb_master_0_adr_o;
 	wire	[ 1:0 ] cpu_plug_wb_master_0_bte_o;
 	wire	[ 2:0 ] cpu_plug_wb_master_0_cti_o;
 	wire			 cpu_plug_wb_master_0_cyc_o;
 	wire	[ 31:0 ] cpu_plug_wb_master_0_dat_i;
 	wire	[ 31:0 ] cpu_plug_wb_master_0_dat_o;
 	wire			 cpu_plug_wb_master_0_err_i;
 	wire			 cpu_plug_wb_master_0_rty_i;
 	wire	[ 3:0 ] cpu_plug_wb_master_0_sel_o;
 	wire			 cpu_plug_wb_master_0_stb_o;
 	wire			 cpu_plug_wb_master_0_we_o;
 	wire			 cpu_plug_reset_0_reset_i;
 	wire	[ 31:0 ] cpu_plug_snoop_0_snoop_adr_i;
 	wire			 cpu_plug_snoop_0_snoop_en_i;

  	wire			 ni_plug_clk_0_clk_i;
 	wire			 ni_plug_interrupt_peripheral_0_int_o;
 	wire			 ni_plug_wb_master_1_ack_i;
 	wire	[ ni_M_Aw-1          :   0 ] ni_plug_wb_master_1_adr_o;
 	wire	[ ni_TAGw-1          :   0 ] ni_plug_wb_master_1_cti_o;
 	wire			 ni_plug_wb_master_1_cyc_o;
 	wire	[ ni_Dw-1            :   0 ] ni_plug_wb_master_1_dat_o;
 	wire	[ ni_SELw-1          :   0 ] ni_plug_wb_master_1_sel_o;
 	wire			 ni_plug_wb_master_1_stb_o;
 	wire			 ni_plug_wb_master_1_we_o;
 	wire			 ni_plug_wb_master_0_ack_i;
 	wire	[ ni_M_Aw-1          :   0 ] ni_plug_wb_master_0_adr_o;
 	wire	[ ni_TAGw-1          :   0 ] ni_plug_wb_master_0_cti_o;
 	wire			 ni_plug_wb_master_0_cyc_o;
 	wire	[ ni_Dw-1           :  0 ] ni_plug_wb_master_0_dat_i;
 	wire	[ ni_SELw-1          :   0 ] ni_plug_wb_master_0_sel_o;
 	wire			 ni_plug_wb_master_0_stb_o;
 	wire			 ni_plug_wb_master_0_we_o;
 	wire			 ni_plug_reset_0_reset_i;
 	wire			 ni_plug_wb_slave_0_ack_o;
 	wire	[ ni_S_Aw-1     :   0 ] ni_plug_wb_slave_0_adr_i;
 	wire	[ ni_TAGw-1     :   0 ] ni_plug_wb_slave_0_cti_i;
 	wire			 ni_plug_wb_slave_0_cyc_i;
 	wire	[ ni_Dw-1       :   0 ] ni_plug_wb_slave_0_dat_i;
 	wire	[ ni_Dw-1       :   0 ] ni_plug_wb_slave_0_dat_o;
 	wire	[ ni_SELw-1     :   0 ] ni_plug_wb_slave_0_sel_i;
 	wire			 ni_plug_wb_slave_0_stb_i;
 	wire			 ni_plug_wb_slave_0_we_i;

  	wire			 ram_plug_clk_0_clk_i;
 	wire			 ram_plug_reset_0_reset_i;
 	wire			 ram_plug_wb_slave_0_ack_o;
 	wire	[ ram_Aw-1       :   0 ] ram_plug_wb_slave_0_adr_i;
 	wire	[ ram_BTEw-1     :   0 ] ram_plug_wb_slave_0_bte_i;
 	wire	[ ram_CTIw-1     :   0 ] ram_plug_wb_slave_0_cti_i;
 	wire			 ram_plug_wb_slave_0_cyc_i;
 	wire	[ ram_Dw-1       :   0 ] ram_plug_wb_slave_0_dat_i;
 	wire	[ ram_Dw-1       :   0 ] ram_plug_wb_slave_0_dat_o;
 	wire			 ram_plug_wb_slave_0_err_o;
 	wire			 ram_plug_wb_slave_0_rty_o;
 	wire	[ ram_SELw-1     :   0 ] ram_plug_wb_slave_0_sel_i;
 	wire			 ram_plug_wb_slave_0_stb_i;
 	wire	[ ram_TAGw-1     :   0 ] ram_plug_wb_slave_0_tag_i;
 	wire			 ram_plug_wb_slave_0_we_i;

  	wire			 timer_plug_clk_0_clk_i;
 	wire			 timer_plug_interrupt_peripheral_0_int_o;
 	wire			 timer_plug_reset_0_reset_i;
 	wire			 timer_plug_wb_slave_0_ack_o;
 	wire	[ timer_Aw-1       :   0 ] timer_plug_wb_slave_0_adr_i;
 	wire			 timer_plug_wb_slave_0_cyc_i;
 	wire	[ timer_Dw-1       :   0 ] timer_plug_wb_slave_0_dat_i;
 	wire	[ timer_Dw-1       :   0 ] timer_plug_wb_slave_0_dat_o;
 	wire			 timer_plug_wb_slave_0_err_o;
 	wire			 timer_plug_wb_slave_0_rty_o;
 	wire	[ timer_SELw-1     :   0 ] timer_plug_wb_slave_0_sel_i;
 	wire			 timer_plug_wb_slave_0_stb_i;
 	wire	[ timer_TAGw-1     :   0 ] timer_plug_wb_slave_0_tag_i;
 	wire			 timer_plug_wb_slave_0_we_i;

  	wire			 bus_plug_clk_0_clk_i;
 	wire	[ bus_M-1        :   0 ] bus_socket_wb_master_array_ack_o;
 	wire			 bus_socket_wb_master_3_ack_o;
 	wire			 bus_socket_wb_master_2_ack_o;
 	wire			 bus_socket_wb_master_1_ack_o;
 	wire			 bus_socket_wb_master_0_ack_o;
 	wire	[ bus_Aw*bus_M-1      :   0 ] bus_socket_wb_master_array_adr_i;
 	wire	[ bus_Aw-1:0 ] bus_socket_wb_master_3_adr_i;
 	wire	[ bus_Aw-1:0 ] bus_socket_wb_master_2_adr_i;
 	wire	[ bus_Aw-1:0 ] bus_socket_wb_master_1_adr_i;
 	wire	[ bus_Aw-1:0 ] bus_socket_wb_master_0_adr_i;
 	wire	[ bus_BTEw*bus_M-1    :   0 ] bus_socket_wb_master_array_bte_i;
 	wire	[ bus_BTEw-1:0 ] bus_socket_wb_master_3_bte_i;
 	wire	[ bus_BTEw-1:0 ] bus_socket_wb_master_2_bte_i;
 	wire	[ bus_BTEw-1:0 ] bus_socket_wb_master_1_bte_i;
 	wire	[ bus_BTEw-1:0 ] bus_socket_wb_master_0_bte_i;
 	wire	[ bus_CTIw*bus_M-1    :   0 ] bus_socket_wb_master_array_cti_i;
 	wire	[ bus_CTIw-1:0 ] bus_socket_wb_master_3_cti_i;
 	wire	[ bus_CTIw-1:0 ] bus_socket_wb_master_2_cti_i;
 	wire	[ bus_CTIw-1:0 ] bus_socket_wb_master_1_cti_i;
 	wire	[ bus_CTIw-1:0 ] bus_socket_wb_master_0_cti_i;
 	wire	[ bus_M-1        :   0 ] bus_socket_wb_master_array_cyc_i;
 	wire			 bus_socket_wb_master_3_cyc_i;
 	wire			 bus_socket_wb_master_2_cyc_i;
 	wire			 bus_socket_wb_master_1_cyc_i;
 	wire			 bus_socket_wb_master_0_cyc_i;
 	wire	[ bus_Dw*bus_M-1      :   0 ] bus_socket_wb_master_array_dat_i;
 	wire	[ bus_Dw-1:0 ] bus_socket_wb_master_3_dat_i;
 	wire	[ bus_Dw-1:0 ] bus_socket_wb_master_2_dat_i;
 	wire	[ bus_Dw-1:0 ] bus_socket_wb_master_1_dat_i;
 	wire	[ bus_Dw-1:0 ] bus_socket_wb_master_0_dat_i;
 	wire	[ bus_Dw*bus_M-1      :   0 ] bus_socket_wb_master_array_dat_o;
 	wire	[ bus_Dw-1:0 ] bus_socket_wb_master_3_dat_o;
 	wire	[ bus_Dw-1:0 ] bus_socket_wb_master_2_dat_o;
 	wire	[ bus_Dw-1:0 ] bus_socket_wb_master_1_dat_o;
 	wire	[ bus_Dw-1:0 ] bus_socket_wb_master_0_dat_o;
 	wire	[ bus_M-1        :   0 ] bus_socket_wb_master_array_err_o;
 	wire			 bus_socket_wb_master_3_err_o;
 	wire			 bus_socket_wb_master_2_err_o;
 	wire			 bus_socket_wb_master_1_err_o;
 	wire			 bus_socket_wb_master_0_err_o;
 	wire	[ bus_Aw-1       :   0 ] bus_socket_wb_addr_map_0_grant_addr;
 	wire	[ bus_M-1        :   0 ] bus_socket_wb_master_array_rty_o;
 	wire			 bus_socket_wb_master_3_rty_o;
 	wire			 bus_socket_wb_master_2_rty_o;
 	wire			 bus_socket_wb_master_1_rty_o;
 	wire			 bus_socket_wb_master_0_rty_o;
 	wire	[ bus_SELw*bus_M-1    :   0 ] bus_socket_wb_master_array_sel_i;
 	wire	[ bus_SELw-1:0 ] bus_socket_wb_master_3_sel_i;
 	wire	[ bus_SELw-1:0 ] bus_socket_wb_master_2_sel_i;
 	wire	[ bus_SELw-1:0 ] bus_socket_wb_master_1_sel_i;
 	wire	[ bus_SELw-1:0 ] bus_socket_wb_master_0_sel_i;
 	wire	[ bus_M-1        :   0 ] bus_socket_wb_master_array_stb_i;
 	wire			 bus_socket_wb_master_3_stb_i;
 	wire			 bus_socket_wb_master_2_stb_i;
 	wire			 bus_socket_wb_master_1_stb_i;
 	wire			 bus_socket_wb_master_0_stb_i;
 	wire	[ bus_TAGw*bus_M-1    :   0 ] bus_socket_wb_master_array_tag_i;
 	wire	[ bus_TAGw-1:0 ] bus_socket_wb_master_3_tag_i;
 	wire	[ bus_TAGw-1:0 ] bus_socket_wb_master_2_tag_i;
 	wire	[ bus_TAGw-1:0 ] bus_socket_wb_master_1_tag_i;
 	wire	[ bus_TAGw-1:0 ] bus_socket_wb_master_0_tag_i;
 	wire	[ bus_M-1        :   0 ] bus_socket_wb_master_array_we_i;
 	wire			 bus_socket_wb_master_3_we_i;
 	wire			 bus_socket_wb_master_2_we_i;
 	wire			 bus_socket_wb_master_1_we_i;
 	wire			 bus_socket_wb_master_0_we_i;
 	wire			 bus_plug_reset_0_reset_i;
 	wire	[ bus_S-1        :   0 ] bus_socket_wb_slave_array_ack_i;
 	wire			 bus_socket_wb_slave_3_ack_i;
 	wire			 bus_socket_wb_slave_2_ack_i;
 	wire			 bus_socket_wb_slave_1_ack_i;
 	wire			 bus_socket_wb_slave_0_ack_i;
 	wire	[ bus_Aw*bus_S-1      :   0 ] bus_socket_wb_slave_array_adr_o;
 	wire	[ bus_Aw-1:0 ] bus_socket_wb_slave_3_adr_o;
 	wire	[ bus_Aw-1:0 ] bus_socket_wb_slave_2_adr_o;
 	wire	[ bus_Aw-1:0 ] bus_socket_wb_slave_1_adr_o;
 	wire	[ bus_Aw-1:0 ] bus_socket_wb_slave_0_adr_o;
 	wire	[ bus_BTEw*bus_S-1    :   0 ] bus_socket_wb_slave_array_bte_o;
 	wire	[ bus_BTEw-1:0 ] bus_socket_wb_slave_3_bte_o;
 	wire	[ bus_BTEw-1:0 ] bus_socket_wb_slave_2_bte_o;
 	wire	[ bus_BTEw-1:0 ] bus_socket_wb_slave_1_bte_o;
 	wire	[ bus_BTEw-1:0 ] bus_socket_wb_slave_0_bte_o;
 	wire	[ bus_CTIw*bus_S-1    :   0 ] bus_socket_wb_slave_array_cti_o;
 	wire	[ bus_CTIw-1:0 ] bus_socket_wb_slave_3_cti_o;
 	wire	[ bus_CTIw-1:0 ] bus_socket_wb_slave_2_cti_o;
 	wire	[ bus_CTIw-1:0 ] bus_socket_wb_slave_1_cti_o;
 	wire	[ bus_CTIw-1:0 ] bus_socket_wb_slave_0_cti_o;
 	wire	[ bus_S-1        :   0 ] bus_socket_wb_slave_array_cyc_o;
 	wire			 bus_socket_wb_slave_3_cyc_o;
 	wire			 bus_socket_wb_slave_2_cyc_o;
 	wire			 bus_socket_wb_slave_1_cyc_o;
 	wire			 bus_socket_wb_slave_0_cyc_o;
 	wire	[ bus_Dw*bus_S-1      :   0 ] bus_socket_wb_slave_array_dat_i;
 	wire	[ bus_Dw-1:0 ] bus_socket_wb_slave_3_dat_i;
 	wire	[ bus_Dw-1:0 ] bus_socket_wb_slave_2_dat_i;
 	wire	[ bus_Dw-1:0 ] bus_socket_wb_slave_1_dat_i;
 	wire	[ bus_Dw-1:0 ] bus_socket_wb_slave_0_dat_i;
 	wire	[ bus_Dw*bus_S-1      :   0 ] bus_socket_wb_slave_array_dat_o;
 	wire	[ bus_Dw-1:0 ] bus_socket_wb_slave_3_dat_o;
 	wire	[ bus_Dw-1:0 ] bus_socket_wb_slave_2_dat_o;
 	wire	[ bus_Dw-1:0 ] bus_socket_wb_slave_1_dat_o;
 	wire	[ bus_Dw-1:0 ] bus_socket_wb_slave_0_dat_o;
 	wire	[ bus_S-1        :   0 ] bus_socket_wb_slave_array_err_i;
 	wire			 bus_socket_wb_slave_3_err_i;
 	wire			 bus_socket_wb_slave_2_err_i;
 	wire			 bus_socket_wb_slave_1_err_i;
 	wire			 bus_socket_wb_slave_0_err_i;
 	wire	[ bus_S-1        :   0 ] bus_socket_wb_slave_array_rty_i;
 	wire			 bus_socket_wb_slave_3_rty_i;
 	wire			 bus_socket_wb_slave_2_rty_i;
 	wire			 bus_socket_wb_slave_1_rty_i;
 	wire			 bus_socket_wb_slave_0_rty_i;
 	wire	[ bus_SELw*bus_S-1    :   0 ] bus_socket_wb_slave_array_sel_o;
 	wire	[ bus_SELw-1:0 ] bus_socket_wb_slave_3_sel_o;
 	wire	[ bus_SELw-1:0 ] bus_socket_wb_slave_2_sel_o;
 	wire	[ bus_SELw-1:0 ] bus_socket_wb_slave_1_sel_o;
 	wire	[ bus_SELw-1:0 ] bus_socket_wb_slave_0_sel_o;
 	wire	[ bus_S-1        :   0 ] bus_socket_wb_addr_map_0_sel_one_hot;
 	wire	[ bus_S-1        :   0 ] bus_socket_wb_slave_array_stb_o;
 	wire			 bus_socket_wb_slave_3_stb_o;
 	wire			 bus_socket_wb_slave_2_stb_o;
 	wire			 bus_socket_wb_slave_1_stb_o;
 	wire			 bus_socket_wb_slave_0_stb_o;
 	wire	[ bus_TAGw*bus_S-1    :   0 ] bus_socket_wb_slave_array_tag_o;
 	wire	[ bus_TAGw-1:0 ] bus_socket_wb_slave_3_tag_o;
 	wire	[ bus_TAGw-1:0 ] bus_socket_wb_slave_2_tag_o;
 	wire	[ bus_TAGw-1:0 ] bus_socket_wb_slave_1_tag_o;
 	wire	[ bus_TAGw-1:0 ] bus_socket_wb_slave_0_tag_o;
 	wire	[ bus_S-1        :   0 ] bus_socket_wb_slave_array_we_o;
 	wire			 bus_socket_wb_slave_3_we_o;
 	wire			 bus_socket_wb_slave_2_we_o;
 	wire			 bus_socket_wb_slave_1_we_o;
 	wire			 bus_socket_wb_slave_0_we_o;
 	wire	[ bus_Aw-1    :   0 ] bus_socket_snoop_0_snoop_adr_o;
 	wire			 bus_socket_snoop_0_snoop_en_o;

 
//Take the default value for ports that defined by interfaces but did not assigned to any wires.
 	assign bus_socket_wb_master_0_tag_i = {bus_TAGw{1'b0}};
 	assign bus_socket_wb_master_1_tag_i = {bus_TAGw{1'b0}};
 	assign bus_socket_wb_master_2_bte_i = {bus_BTEw{1'b0}};
 	assign bus_socket_wb_master_2_dat_i = {bus_Dw{1'b0}};
 	assign bus_socket_wb_master_2_tag_i = {bus_TAGw{1'b0}};
 	assign bus_socket_wb_master_3_bte_i = {bus_BTEw{1'b0}};
 	assign bus_socket_wb_master_3_tag_i = {bus_TAGw{1'b0}};
 	assign bus_socket_wb_slave_1_err_i = 1'b0;
 	assign bus_socket_wb_slave_1_rty_i = 1'b0;
 	assign bus_socket_wb_slave_3_err_i = 1'b0;
 	assign bus_socket_wb_slave_3_rty_i = 1'b0;
 	assign cpu_socket_interrupt_peripheral_10_int_i = 1'b0;
 	assign cpu_socket_interrupt_peripheral_11_int_i = 1'b0;
 	assign cpu_socket_interrupt_peripheral_12_int_i = 1'b0;
 	assign cpu_socket_interrupt_peripheral_13_int_i = 1'b0;
 	assign cpu_socket_interrupt_peripheral_14_int_i = 1'b0;
 	assign cpu_socket_interrupt_peripheral_15_int_i = 1'b0;
 	assign cpu_socket_interrupt_peripheral_16_int_i = 1'b0;
 	assign cpu_socket_interrupt_peripheral_17_int_i = 1'b0;
 	assign cpu_socket_interrupt_peripheral_18_int_i = 1'b0;
 	assign cpu_socket_interrupt_peripheral_19_int_i = 1'b0;
 	assign cpu_socket_interrupt_peripheral_20_int_i = 1'b0;
 	assign cpu_socket_interrupt_peripheral_21_int_i = 1'b0;
 	assign cpu_socket_interrupt_peripheral_22_int_i = 1'b0;
 	assign cpu_socket_interrupt_peripheral_23_int_i = 1'b0;
 	assign cpu_socket_interrupt_peripheral_24_int_i = 1'b0;
 	assign cpu_socket_interrupt_peripheral_25_int_i = 1'b0;
 	assign cpu_socket_interrupt_peripheral_26_int_i = 1'b0;
 	assign cpu_socket_interrupt_peripheral_27_int_i = 1'b0;
 	assign cpu_socket_interrupt_peripheral_28_int_i = 1'b0;
 	assign cpu_socket_interrupt_peripheral_29_int_i = 1'b0;
 	assign cpu_socket_interrupt_peripheral_2_int_i = 1'b0;
 	assign cpu_socket_interrupt_peripheral_30_int_i = 1'b0;
 	assign cpu_socket_interrupt_peripheral_31_int_i = 1'b0;
 	assign cpu_socket_interrupt_peripheral_3_int_i = 1'b0;
 	assign cpu_socket_interrupt_peripheral_4_int_i = 1'b0;
 	assign cpu_socket_interrupt_peripheral_5_int_i = 1'b0;
 	assign cpu_socket_interrupt_peripheral_6_int_i = 1'b0;
 	assign cpu_socket_interrupt_peripheral_7_int_i = 1'b0;
 	assign cpu_socket_interrupt_peripheral_8_int_i = 1'b0;
 	assign cpu_socket_interrupt_peripheral_9_int_i = 1'b0;


 clk_source  source 	(
		.clk_in(source_clk_in),
		.clk_out(source_socket_clk_0_clk_o),
		.reset_in(source_reset_in),
		.reset_out(source_socket_reset_0_reset_o)
	);
 jtag_uart_wb #(
 		.FPGA_VENDOR(uart_FPGA_VENDOR),
		.SIM_BUFFER_SIZE(uart_SIM_BUFFER_SIZE),
		.SIM_WAIT_COUNT(uart_SIM_WAIT_COUNT)
	)  uart 	(
		.RxD_din_sim(uart_RxD_din_sim),
		.RxD_ready_sim(uart_RxD_ready_sim),
		.RxD_wr_sim(uart_RxD_wr_sim),
		.clk(uart_plug_clk_0_clk_i),
		.irq(),
		.reset(uart_plug_reset_0_reset_i),
		.s_ack_o(uart_plug_wb_slave_0_ack_o),
		.s_addr_i(uart_plug_wb_slave_0_adr_i),
		.s_cti_i(uart_plug_wb_slave_0_cti_i),
		.s_cyc_i(uart_plug_wb_slave_0_cyc_i),
		.s_dat_i(uart_plug_wb_slave_0_dat_i),
		.s_dat_o(uart_plug_wb_slave_0_dat_o),
		.s_sel_i(uart_plug_wb_slave_0_sel_i),
		.s_stb_i(uart_plug_wb_slave_0_stb_i),
		.s_we_i(uart_plug_wb_slave_0_we_i)
	);
 mor1k #(
 		.OPTION_OPERAND_WIDTH(cpu_OPTION_OPERAND_WIDTH),
		.IRQ_NUM(cpu_IRQ_NUM),
		.OPTION_DCACHE_SNOOP(cpu_OPTION_DCACHE_SNOOP),
		.FEATURE_INSTRUCTIONCACHE(cpu_FEATURE_INSTRUCTIONCACHE),
		.FEATURE_DATACACHE(cpu_FEATURE_DATACACHE),
		.FEATURE_IMMU(cpu_FEATURE_IMMU),
		.FEATURE_DMMU(cpu_FEATURE_DMMU)
	)  cpu 	(
		.clk(cpu_plug_clk_0_clk_i),
		.cpu_en(cpu_cpu_en),
		.dwbm_ack_i(cpu_plug_wb_master_1_ack_i),
		.dwbm_adr_o(cpu_plug_wb_master_1_adr_o),
		.dwbm_bte_o(cpu_plug_wb_master_1_bte_o),
		.dwbm_cti_o(cpu_plug_wb_master_1_cti_o),
		.dwbm_cyc_o(cpu_plug_wb_master_1_cyc_o),
		.dwbm_dat_i(cpu_plug_wb_master_1_dat_i),
		.dwbm_dat_o(cpu_plug_wb_master_1_dat_o),
		.dwbm_err_i(cpu_plug_wb_master_1_err_i),
		.dwbm_rty_i(cpu_plug_wb_master_1_rty_i),
		.dwbm_sel_o(cpu_plug_wb_master_1_sel_o),
		.dwbm_stb_o(cpu_plug_wb_master_1_stb_o),
		.dwbm_we_o(cpu_plug_wb_master_1_we_o),
		.irq_i(cpu_socket_interrupt_peripheral_array_int_i),
		.iwbm_ack_i(cpu_plug_wb_master_0_ack_i),
		.iwbm_adr_o(cpu_plug_wb_master_0_adr_o),
		.iwbm_bte_o(cpu_plug_wb_master_0_bte_o),
		.iwbm_cti_o(cpu_plug_wb_master_0_cti_o),
		.iwbm_cyc_o(cpu_plug_wb_master_0_cyc_o),
		.iwbm_dat_i(cpu_plug_wb_master_0_dat_i),
		.iwbm_dat_o(cpu_plug_wb_master_0_dat_o),
		.iwbm_err_i(cpu_plug_wb_master_0_err_i),
		.iwbm_rty_i(cpu_plug_wb_master_0_rty_i),
		.iwbm_sel_o(cpu_plug_wb_master_0_sel_o),
		.iwbm_stb_o(cpu_plug_wb_master_0_stb_o),
		.iwbm_we_o(cpu_plug_wb_master_0_we_o),
		.rst(cpu_plug_reset_0_reset_i),
		.snoop_adr_i(cpu_plug_snoop_0_snoop_adr_i),
		.snoop_en_i(cpu_plug_snoop_0_snoop_en_i)
	);
 ni_master #(
 		.TOPOLOGY(ni_TOPOLOGY),
		.ROUTE_NAME(ni_ROUTE_NAME),
		.T1(ni_T1),
		.T2(ni_T2),
		.T3(ni_T3),
		.C(ni_C),
		.V(ni_V),
		.B(ni_B),
		.Fpay(ni_Fpay),
		.MAX_TRANSACTION_WIDTH(ni_MAX_TRANSACTION_WIDTH),
		.MAX_BURST_SIZE(ni_MAX_BURST_SIZE),
		.DEBUG_EN(ni_DEBUG_EN),
		.Dw(ni_Dw),
		.S_Aw(ni_S_Aw),
		.M_Aw(ni_M_Aw),
		.TAGw(ni_TAGw),
		.SELw(ni_SELw),
		.CRC_EN(ni_CRC_EN)
	)  ni 	(
		.clk(ni_plug_clk_0_clk_i),
		.credit_in(ni_credit_in),
		.credit_out(ni_credit_out),
		.current_e_addr(ni_current_e_addr),
		.current_r_addr(ni_current_r_addr),
		.flit_in(ni_flit_in),
		.flit_in_wr(ni_flit_in_wr),
		.flit_out(ni_flit_out),
		.flit_out_wr(ni_flit_out_wr),
		.irq(ni_plug_interrupt_peripheral_0_int_o),
		.m_receive_ack_i(ni_plug_wb_master_1_ack_i),
		.m_receive_addr_o(ni_plug_wb_master_1_adr_o),
		.m_receive_cti_o(ni_plug_wb_master_1_cti_o),
		.m_receive_cyc_o(ni_plug_wb_master_1_cyc_o),
		.m_receive_dat_o(ni_plug_wb_master_1_dat_o),
		.m_receive_sel_o(ni_plug_wb_master_1_sel_o),
		.m_receive_stb_o(ni_plug_wb_master_1_stb_o),
		.m_receive_we_o(ni_plug_wb_master_1_we_o),
		.m_send_ack_i(ni_plug_wb_master_0_ack_i),
		.m_send_addr_o(ni_plug_wb_master_0_adr_o),
		.m_send_cti_o(ni_plug_wb_master_0_cti_o),
		.m_send_cyc_o(ni_plug_wb_master_0_cyc_o),
		.m_send_dat_i(ni_plug_wb_master_0_dat_i),
		.m_send_sel_o(ni_plug_wb_master_0_sel_o),
		.m_send_stb_o(ni_plug_wb_master_0_stb_o),
		.m_send_we_o(ni_plug_wb_master_0_we_o),
		.reset(ni_plug_reset_0_reset_i),
		.s_ack_o(ni_plug_wb_slave_0_ack_o),
		.s_addr_i(ni_plug_wb_slave_0_adr_i),
		.s_cti_i(ni_plug_wb_slave_0_cti_i),
		.s_cyc_i(ni_plug_wb_slave_0_cyc_i),
		.s_dat_i(ni_plug_wb_slave_0_dat_i),
		.s_dat_o(ni_plug_wb_slave_0_dat_o),
		.s_sel_i(ni_plug_wb_slave_0_sel_i),
		.s_stb_i(ni_plug_wb_slave_0_stb_i),
		.s_we_i(ni_plug_wb_slave_0_we_i)
	);
 wb_single_port_ram #(
 		.Dw(ram_Dw),
		.Aw(ram_Aw),
		.BYTE_WR_EN(ram_BYTE_WR_EN),
		.FPGA_VENDOR(ram_FPGA_VENDOR),
		.JTAG_CONNECT(ram_JTAG_CONNECT),
		.JTAG_INDEX(ram_JTAG_INDEX),
		.TAGw(ram_TAGw),
		.SELw(ram_SELw),
		.CTIw(ram_CTIw),
		.BTEw(ram_BTEw),
		.BURST_MODE(ram_BURST_MODE),
		.MEM_CONTENT_FILE_NAME(ram_MEM_CONTENT_FILE_NAME),
		.INITIAL_EN(ram_INITIAL_EN),
		.INIT_FILE_PATH(ram_INIT_FILE_PATH)
	)  ram 	(
		.clk(ram_plug_clk_0_clk_i),
		.reset(ram_plug_reset_0_reset_i),
		.sa_ack_o(ram_plug_wb_slave_0_ack_o),
		.sa_addr_i(ram_plug_wb_slave_0_adr_i),
		.sa_bte_i(ram_plug_wb_slave_0_bte_i),
		.sa_cti_i(ram_plug_wb_slave_0_cti_i),
		.sa_cyc_i(ram_plug_wb_slave_0_cyc_i),
		.sa_dat_i(ram_plug_wb_slave_0_dat_i),
		.sa_dat_o(ram_plug_wb_slave_0_dat_o),
		.sa_err_o(ram_plug_wb_slave_0_err_o),
		.sa_rty_o(ram_plug_wb_slave_0_rty_o),
		.sa_sel_i(ram_plug_wb_slave_0_sel_i),
		.sa_stb_i(ram_plug_wb_slave_0_stb_i),
		.sa_tag_i(ram_plug_wb_slave_0_tag_i),
		.sa_we_i(ram_plug_wb_slave_0_we_i)
	);
 timer #(
 		.CNTw(timer_CNTw),
		.Dw(timer_Dw),
		.Aw(timer_Aw),
		.TAGw(timer_TAGw),
		.SELw(timer_SELw),
		.PRESCALER_WIDTH(timer_PRESCALER_WIDTH)
	)  timer 	(
		.clk(timer_plug_clk_0_clk_i),
		.irq(timer_plug_interrupt_peripheral_0_int_o),
		.reset(timer_plug_reset_0_reset_i),
		.sa_ack_o(timer_plug_wb_slave_0_ack_o),
		.sa_addr_i(timer_plug_wb_slave_0_adr_i),
		.sa_cyc_i(timer_plug_wb_slave_0_cyc_i),
		.sa_dat_i(timer_plug_wb_slave_0_dat_i),
		.sa_dat_o(timer_plug_wb_slave_0_dat_o),
		.sa_err_o(timer_plug_wb_slave_0_err_o),
		.sa_rty_o(timer_plug_wb_slave_0_rty_o),
		.sa_sel_i(timer_plug_wb_slave_0_sel_i),
		.sa_stb_i(timer_plug_wb_slave_0_stb_i),
		.sa_tag_i(timer_plug_wb_slave_0_tag_i),
		.sa_we_i(timer_plug_wb_slave_0_we_i)
	);
 wishbone_bus #(
 		.M(bus_M),
		.S(bus_S),
		.Dw(bus_Dw),
		.Aw(bus_Aw),
		.SELw(bus_SELw),
		.TAGw(bus_TAGw),
		.CTIw(bus_CTIw),
		.BTEw(bus_BTEw)
	)  bus 	(
		.clk(bus_plug_clk_0_clk_i),
		.m_ack_o_all(bus_socket_wb_master_array_ack_o),
		.m_adr_i_all(bus_socket_wb_master_array_adr_i),
		.m_bte_i_all(bus_socket_wb_master_array_bte_i),
		.m_cti_i_all(bus_socket_wb_master_array_cti_i),
		.m_cyc_i_all(bus_socket_wb_master_array_cyc_i),
		.m_dat_i_all(bus_socket_wb_master_array_dat_i),
		.m_dat_o_all(bus_socket_wb_master_array_dat_o),
		.m_err_o_all(bus_socket_wb_master_array_err_o),
		.m_grant_addr(bus_socket_wb_addr_map_0_grant_addr),
		.m_rty_o_all(bus_socket_wb_master_array_rty_o),
		.m_sel_i_all(bus_socket_wb_master_array_sel_i),
		.m_stb_i_all(bus_socket_wb_master_array_stb_i),
		.m_tag_i_all(bus_socket_wb_master_array_tag_i),
		.m_we_i_all(bus_socket_wb_master_array_we_i),
		.reset(bus_plug_reset_0_reset_i),
		.s_ack_i_all(bus_socket_wb_slave_array_ack_i),
		.s_adr_o_all(bus_socket_wb_slave_array_adr_o),
		.s_bte_o_all(bus_socket_wb_slave_array_bte_o),
		.s_cti_o_all(bus_socket_wb_slave_array_cti_o),
		.s_cyc_o_all(bus_socket_wb_slave_array_cyc_o),
		.s_dat_i_all(bus_socket_wb_slave_array_dat_i),
		.s_dat_o_all(bus_socket_wb_slave_array_dat_o),
		.s_err_i_all(bus_socket_wb_slave_array_err_i),
		.s_rty_i_all(bus_socket_wb_slave_array_rty_i),
		.s_sel_o_all(bus_socket_wb_slave_array_sel_o),
		.s_sel_one_hot(bus_socket_wb_addr_map_0_sel_one_hot),
		.s_stb_o_all(bus_socket_wb_slave_array_stb_o),
		.s_tag_o_all(bus_socket_wb_slave_array_tag_o),
		.s_we_o_all(bus_socket_wb_slave_array_we_o),
		.snoop_adr_o(bus_socket_snoop_0_snoop_adr_o),
		.snoop_en_o(bus_socket_snoop_0_snoop_en_o)
	);
 

 
 	assign  uart_plug_clk_0_clk_i = source_socket_clk_0_clk_o;
 	assign  uart_plug_reset_0_reset_i = source_socket_reset_0_reset_o;
 	assign  bus_socket_wb_slave_3_ack_i  = uart_plug_wb_slave_0_ack_o;
 	assign  uart_plug_wb_slave_0_adr_i = bus_socket_wb_slave_3_adr_o;
 	assign  uart_plug_wb_slave_0_cti_i = bus_socket_wb_slave_3_cti_o[2    :   0];
 	assign  uart_plug_wb_slave_0_cyc_i = bus_socket_wb_slave_3_cyc_o;
 	assign  uart_plug_wb_slave_0_dat_i = bus_socket_wb_slave_3_dat_o[31       :   0];
 	assign  bus_socket_wb_slave_3_dat_i  = uart_plug_wb_slave_0_dat_o;
 	assign  uart_plug_wb_slave_0_sel_i = bus_socket_wb_slave_3_sel_o[3    :   0];
 	assign  uart_plug_wb_slave_0_stb_i = bus_socket_wb_slave_3_stb_o;
 	assign  uart_plug_wb_slave_0_we_i = bus_socket_wb_slave_3_we_o;

 
 	assign  cpu_plug_clk_0_clk_i = source_socket_clk_0_clk_o;
 	assign  cpu_plug_wb_master_1_ack_i = bus_socket_wb_master_1_ack_o;
 	assign  bus_socket_wb_master_1_adr_i  = cpu_plug_wb_master_1_adr_o;
 	assign  bus_socket_wb_master_1_bte_i  = cpu_plug_wb_master_1_bte_o;
 	assign  bus_socket_wb_master_1_cti_i  = cpu_plug_wb_master_1_cti_o;
 	assign  bus_socket_wb_master_1_cyc_i  = cpu_plug_wb_master_1_cyc_o;
 	assign  cpu_plug_wb_master_1_dat_i = bus_socket_wb_master_1_dat_o[31:0];
 	assign  bus_socket_wb_master_1_dat_i  = cpu_plug_wb_master_1_dat_o;
 	assign  cpu_plug_wb_master_1_err_i = bus_socket_wb_master_1_err_o;
 	assign  cpu_plug_wb_master_1_rty_i = bus_socket_wb_master_1_rty_o;
 	assign  bus_socket_wb_master_1_sel_i  = cpu_plug_wb_master_1_sel_o;
 	assign  bus_socket_wb_master_1_stb_i  = cpu_plug_wb_master_1_stb_o;
 	assign  bus_socket_wb_master_1_we_i  = cpu_plug_wb_master_1_we_o;
 	assign  cpu_plug_wb_master_0_ack_i = bus_socket_wb_master_0_ack_o;
 	assign  bus_socket_wb_master_0_adr_i  = cpu_plug_wb_master_0_adr_o;
 	assign  bus_socket_wb_master_0_bte_i  = cpu_plug_wb_master_0_bte_o;
 	assign  bus_socket_wb_master_0_cti_i  = cpu_plug_wb_master_0_cti_o;
 	assign  bus_socket_wb_master_0_cyc_i  = cpu_plug_wb_master_0_cyc_o;
 	assign  cpu_plug_wb_master_0_dat_i = bus_socket_wb_master_0_dat_o[31:0];
 	assign  bus_socket_wb_master_0_dat_i  = cpu_plug_wb_master_0_dat_o;
 	assign  cpu_plug_wb_master_0_err_i = bus_socket_wb_master_0_err_o;
 	assign  cpu_plug_wb_master_0_rty_i = bus_socket_wb_master_0_rty_o;
 	assign  bus_socket_wb_master_0_sel_i  = cpu_plug_wb_master_0_sel_o;
 	assign  bus_socket_wb_master_0_stb_i  = cpu_plug_wb_master_0_stb_o;
 	assign  bus_socket_wb_master_0_we_i  = cpu_plug_wb_master_0_we_o;
 	assign  cpu_plug_reset_0_reset_i = source_socket_reset_0_reset_o;
 	assign  cpu_plug_snoop_0_snoop_adr_i = bus_socket_snoop_0_snoop_adr_o[31:0];
 	assign  cpu_plug_snoop_0_snoop_en_i = bus_socket_snoop_0_snoop_en_o;

 
 	assign  ni_plug_clk_0_clk_i = source_socket_clk_0_clk_o;
 	assign  cpu_socket_interrupt_peripheral_0_int_i  = ni_plug_interrupt_peripheral_0_int_o;
 	assign  ni_plug_wb_master_1_ack_i = bus_socket_wb_master_3_ack_o;
 	assign  bus_socket_wb_master_3_adr_i  = ni_plug_wb_master_1_adr_o;
 	assign  bus_socket_wb_master_3_cti_i  = ni_plug_wb_master_1_cti_o;
 	assign  bus_socket_wb_master_3_cyc_i  = ni_plug_wb_master_1_cyc_o;
 	assign  bus_socket_wb_master_3_dat_i  = ni_plug_wb_master_1_dat_o;
 	assign  bus_socket_wb_master_3_sel_i  = ni_plug_wb_master_1_sel_o;
 	assign  bus_socket_wb_master_3_stb_i  = ni_plug_wb_master_1_stb_o;
 	assign  bus_socket_wb_master_3_we_i  = ni_plug_wb_master_1_we_o;
 	assign  ni_plug_wb_master_0_ack_i = bus_socket_wb_master_2_ack_o;
 	assign  bus_socket_wb_master_2_adr_i  = ni_plug_wb_master_0_adr_o;
 	assign  bus_socket_wb_master_2_cti_i  = ni_plug_wb_master_0_cti_o;
 	assign  bus_socket_wb_master_2_cyc_i  = ni_plug_wb_master_0_cyc_o;
 	assign  ni_plug_wb_master_0_dat_i = bus_socket_wb_master_2_dat_o[ni_Dw-1           :  0];
 	assign  bus_socket_wb_master_2_sel_i  = ni_plug_wb_master_0_sel_o;
 	assign  bus_socket_wb_master_2_stb_i  = ni_plug_wb_master_0_stb_o;
 	assign  bus_socket_wb_master_2_we_i  = ni_plug_wb_master_0_we_o;
 	assign  ni_plug_reset_0_reset_i = source_socket_reset_0_reset_o;
 	assign  bus_socket_wb_slave_1_ack_i  = ni_plug_wb_slave_0_ack_o;
 	assign  ni_plug_wb_slave_0_adr_i = bus_socket_wb_slave_1_adr_o[ni_S_Aw-1     :   0];
 	assign  ni_plug_wb_slave_0_cti_i = bus_socket_wb_slave_1_cti_o[ni_TAGw-1     :   0];
 	assign  ni_plug_wb_slave_0_cyc_i = bus_socket_wb_slave_1_cyc_o;
 	assign  ni_plug_wb_slave_0_dat_i = bus_socket_wb_slave_1_dat_o[ni_Dw-1       :   0];
 	assign  bus_socket_wb_slave_1_dat_i  = ni_plug_wb_slave_0_dat_o;
 	assign  ni_plug_wb_slave_0_sel_i = bus_socket_wb_slave_1_sel_o[ni_SELw-1     :   0];
 	assign  ni_plug_wb_slave_0_stb_i = bus_socket_wb_slave_1_stb_o;
 	assign  ni_plug_wb_slave_0_we_i = bus_socket_wb_slave_1_we_o;

 
 	assign  ram_plug_clk_0_clk_i = source_socket_clk_0_clk_o;
 	assign  ram_plug_reset_0_reset_i = source_socket_reset_0_reset_o;
 	assign  bus_socket_wb_slave_0_ack_i  = ram_plug_wb_slave_0_ack_o;
 	assign  ram_plug_wb_slave_0_adr_i = bus_socket_wb_slave_0_adr_o[ram_Aw-1       :   0];
 	assign  ram_plug_wb_slave_0_bte_i = bus_socket_wb_slave_0_bte_o[ram_BTEw-1     :   0];
 	assign  ram_plug_wb_slave_0_cti_i = bus_socket_wb_slave_0_cti_o[ram_CTIw-1     :   0];
 	assign  ram_plug_wb_slave_0_cyc_i = bus_socket_wb_slave_0_cyc_o;
 	assign  ram_plug_wb_slave_0_dat_i = bus_socket_wb_slave_0_dat_o[ram_Dw-1       :   0];
 	assign  bus_socket_wb_slave_0_dat_i  = ram_plug_wb_slave_0_dat_o;
 	assign  bus_socket_wb_slave_0_err_i  = ram_plug_wb_slave_0_err_o;
 	assign  bus_socket_wb_slave_0_rty_i  = ram_plug_wb_slave_0_rty_o;
 	assign  ram_plug_wb_slave_0_sel_i = bus_socket_wb_slave_0_sel_o[ram_SELw-1     :   0];
 	assign  ram_plug_wb_slave_0_stb_i = bus_socket_wb_slave_0_stb_o;
 	assign  ram_plug_wb_slave_0_tag_i = bus_socket_wb_slave_0_tag_o[ram_TAGw-1     :   0];
 	assign  ram_plug_wb_slave_0_we_i = bus_socket_wb_slave_0_we_o;

 
 	assign  timer_plug_clk_0_clk_i = source_socket_clk_0_clk_o;
 	assign  cpu_socket_interrupt_peripheral_1_int_i  = timer_plug_interrupt_peripheral_0_int_o;
 	assign  timer_plug_reset_0_reset_i = source_socket_reset_0_reset_o;
 	assign  bus_socket_wb_slave_2_ack_i  = timer_plug_wb_slave_0_ack_o;
 	assign  timer_plug_wb_slave_0_adr_i = bus_socket_wb_slave_2_adr_o[timer_Aw-1       :   0];
 	assign  timer_plug_wb_slave_0_cyc_i = bus_socket_wb_slave_2_cyc_o;
 	assign  timer_plug_wb_slave_0_dat_i = bus_socket_wb_slave_2_dat_o[timer_Dw-1       :   0];
 	assign  bus_socket_wb_slave_2_dat_i  = timer_plug_wb_slave_0_dat_o;
 	assign  bus_socket_wb_slave_2_err_i  = timer_plug_wb_slave_0_err_o;
 	assign  bus_socket_wb_slave_2_rty_i  = timer_plug_wb_slave_0_rty_o;
 	assign  timer_plug_wb_slave_0_sel_i = bus_socket_wb_slave_2_sel_o[timer_SELw-1     :   0];
 	assign  timer_plug_wb_slave_0_stb_i = bus_socket_wb_slave_2_stb_o;
 	assign  timer_plug_wb_slave_0_tag_i = bus_socket_wb_slave_2_tag_o[timer_TAGw-1     :   0];
 	assign  timer_plug_wb_slave_0_we_i = bus_socket_wb_slave_2_we_o;

 
 	assign  bus_plug_clk_0_clk_i = source_socket_clk_0_clk_o;
 	assign  bus_plug_reset_0_reset_i = source_socket_reset_0_reset_o;

 	assign cpu_socket_interrupt_peripheral_array_int_i = { cpu_socket_interrupt_peripheral_31_int_i ,cpu_socket_interrupt_peripheral_30_int_i ,cpu_socket_interrupt_peripheral_29_int_i ,cpu_socket_interrupt_peripheral_28_int_i ,cpu_socket_interrupt_peripheral_27_int_i ,cpu_socket_interrupt_peripheral_26_int_i ,cpu_socket_interrupt_peripheral_25_int_i ,cpu_socket_interrupt_peripheral_24_int_i ,cpu_socket_interrupt_peripheral_23_int_i ,cpu_socket_interrupt_peripheral_22_int_i ,cpu_socket_interrupt_peripheral_21_int_i ,cpu_socket_interrupt_peripheral_20_int_i ,cpu_socket_interrupt_peripheral_19_int_i ,cpu_socket_interrupt_peripheral_18_int_i ,cpu_socket_interrupt_peripheral_17_int_i ,cpu_socket_interrupt_peripheral_16_int_i ,cpu_socket_interrupt_peripheral_15_int_i ,cpu_socket_interrupt_peripheral_14_int_i ,cpu_socket_interrupt_peripheral_13_int_i ,cpu_socket_interrupt_peripheral_12_int_i ,cpu_socket_interrupt_peripheral_11_int_i ,cpu_socket_interrupt_peripheral_10_int_i ,cpu_socket_interrupt_peripheral_9_int_i ,cpu_socket_interrupt_peripheral_8_int_i ,cpu_socket_interrupt_peripheral_7_int_i ,cpu_socket_interrupt_peripheral_6_int_i ,cpu_socket_interrupt_peripheral_5_int_i ,cpu_socket_interrupt_peripheral_4_int_i ,cpu_socket_interrupt_peripheral_3_int_i ,cpu_socket_interrupt_peripheral_2_int_i ,cpu_socket_interrupt_peripheral_1_int_i ,cpu_socket_interrupt_peripheral_0_int_i };

 	assign { bus_socket_wb_master_3_ack_o ,bus_socket_wb_master_2_ack_o ,bus_socket_wb_master_1_ack_o ,bus_socket_wb_master_0_ack_o } = bus_socket_wb_master_array_ack_o;
 	assign bus_socket_wb_master_array_adr_i = { bus_socket_wb_master_3_adr_i ,bus_socket_wb_master_2_adr_i ,bus_socket_wb_master_1_adr_i ,bus_socket_wb_master_0_adr_i };
 	assign bus_socket_wb_master_array_bte_i = { bus_socket_wb_master_3_bte_i ,bus_socket_wb_master_2_bte_i ,bus_socket_wb_master_1_bte_i ,bus_socket_wb_master_0_bte_i };
 	assign bus_socket_wb_master_array_cti_i = { bus_socket_wb_master_3_cti_i ,bus_socket_wb_master_2_cti_i ,bus_socket_wb_master_1_cti_i ,bus_socket_wb_master_0_cti_i };
 	assign bus_socket_wb_master_array_cyc_i = { bus_socket_wb_master_3_cyc_i ,bus_socket_wb_master_2_cyc_i ,bus_socket_wb_master_1_cyc_i ,bus_socket_wb_master_0_cyc_i };
 	assign bus_socket_wb_master_array_dat_i = { bus_socket_wb_master_3_dat_i ,bus_socket_wb_master_2_dat_i ,bus_socket_wb_master_1_dat_i ,bus_socket_wb_master_0_dat_i };
 	assign { bus_socket_wb_master_3_dat_o ,bus_socket_wb_master_2_dat_o ,bus_socket_wb_master_1_dat_o ,bus_socket_wb_master_0_dat_o } = bus_socket_wb_master_array_dat_o;
 	assign { bus_socket_wb_master_3_err_o ,bus_socket_wb_master_2_err_o ,bus_socket_wb_master_1_err_o ,bus_socket_wb_master_0_err_o } = bus_socket_wb_master_array_err_o;
 	assign { bus_socket_wb_master_3_rty_o ,bus_socket_wb_master_2_rty_o ,bus_socket_wb_master_1_rty_o ,bus_socket_wb_master_0_rty_o } = bus_socket_wb_master_array_rty_o;
 	assign bus_socket_wb_master_array_sel_i = { bus_socket_wb_master_3_sel_i ,bus_socket_wb_master_2_sel_i ,bus_socket_wb_master_1_sel_i ,bus_socket_wb_master_0_sel_i };
 	assign bus_socket_wb_master_array_stb_i = { bus_socket_wb_master_3_stb_i ,bus_socket_wb_master_2_stb_i ,bus_socket_wb_master_1_stb_i ,bus_socket_wb_master_0_stb_i };
 	assign bus_socket_wb_master_array_tag_i = { bus_socket_wb_master_3_tag_i ,bus_socket_wb_master_2_tag_i ,bus_socket_wb_master_1_tag_i ,bus_socket_wb_master_0_tag_i };
 	assign bus_socket_wb_master_array_we_i = { bus_socket_wb_master_3_we_i ,bus_socket_wb_master_2_we_i ,bus_socket_wb_master_1_we_i ,bus_socket_wb_master_0_we_i };
 	assign bus_socket_wb_slave_array_ack_i = { bus_socket_wb_slave_3_ack_i ,bus_socket_wb_slave_2_ack_i ,bus_socket_wb_slave_1_ack_i ,bus_socket_wb_slave_0_ack_i };
 	assign { bus_socket_wb_slave_3_adr_o ,bus_socket_wb_slave_2_adr_o ,bus_socket_wb_slave_1_adr_o ,bus_socket_wb_slave_0_adr_o } = bus_socket_wb_slave_array_adr_o;
 	assign { bus_socket_wb_slave_3_bte_o ,bus_socket_wb_slave_2_bte_o ,bus_socket_wb_slave_1_bte_o ,bus_socket_wb_slave_0_bte_o } = bus_socket_wb_slave_array_bte_o;
 	assign { bus_socket_wb_slave_3_cti_o ,bus_socket_wb_slave_2_cti_o ,bus_socket_wb_slave_1_cti_o ,bus_socket_wb_slave_0_cti_o } = bus_socket_wb_slave_array_cti_o;
 	assign { bus_socket_wb_slave_3_cyc_o ,bus_socket_wb_slave_2_cyc_o ,bus_socket_wb_slave_1_cyc_o ,bus_socket_wb_slave_0_cyc_o } = bus_socket_wb_slave_array_cyc_o;
 	assign bus_socket_wb_slave_array_dat_i = { bus_socket_wb_slave_3_dat_i ,bus_socket_wb_slave_2_dat_i ,bus_socket_wb_slave_1_dat_i ,bus_socket_wb_slave_0_dat_i };
 	assign { bus_socket_wb_slave_3_dat_o ,bus_socket_wb_slave_2_dat_o ,bus_socket_wb_slave_1_dat_o ,bus_socket_wb_slave_0_dat_o } = bus_socket_wb_slave_array_dat_o;
 	assign bus_socket_wb_slave_array_err_i = { bus_socket_wb_slave_3_err_i ,bus_socket_wb_slave_2_err_i ,bus_socket_wb_slave_1_err_i ,bus_socket_wb_slave_0_err_i };
 	assign bus_socket_wb_slave_array_rty_i = { bus_socket_wb_slave_3_rty_i ,bus_socket_wb_slave_2_rty_i ,bus_socket_wb_slave_1_rty_i ,bus_socket_wb_slave_0_rty_i };
 	assign { bus_socket_wb_slave_3_sel_o ,bus_socket_wb_slave_2_sel_o ,bus_socket_wb_slave_1_sel_o ,bus_socket_wb_slave_0_sel_o } = bus_socket_wb_slave_array_sel_o;
 	assign { bus_socket_wb_slave_3_stb_o ,bus_socket_wb_slave_2_stb_o ,bus_socket_wb_slave_1_stb_o ,bus_socket_wb_slave_0_stb_o } = bus_socket_wb_slave_array_stb_o;
 	assign { bus_socket_wb_slave_3_tag_o ,bus_socket_wb_slave_2_tag_o ,bus_socket_wb_slave_1_tag_o ,bus_socket_wb_slave_0_tag_o } = bus_socket_wb_slave_array_tag_o;
 	assign { bus_socket_wb_slave_3_we_o ,bus_socket_wb_slave_2_we_o ,bus_socket_wb_slave_1_we_o ,bus_socket_wb_slave_0_we_o } = bus_socket_wb_slave_array_we_o;

 
//Wishbone slave address match
 /* uart wb_slave 0 */
 	assign bus_socket_wb_addr_map_0_sel_one_hot[3] = ((bus_socket_wb_addr_map_0_grant_addr >= uart_WB0_BASE_ADDR)   & (bus_socket_wb_addr_map_0_grant_addr <= uart_WB0_END_ADDR));
 /* ni wb_slave 0 */
 	assign bus_socket_wb_addr_map_0_sel_one_hot[1] = ((bus_socket_wb_addr_map_0_grant_addr >= ni_WB0_BASE_ADDR)   & (bus_socket_wb_addr_map_0_grant_addr <= ni_WB0_END_ADDR));
 /* ram wb_slave 0 */
 	assign bus_socket_wb_addr_map_0_sel_one_hot[0] = ((bus_socket_wb_addr_map_0_grant_addr >= ram_WB0_BASE_ADDR)   & (bus_socket_wb_addr_map_0_grant_addr <= ram_WB0_END_ADDR));
 /* timer wb_slave 0 */
 	assign bus_socket_wb_addr_map_0_sel_one_hot[2] = ((bus_socket_wb_addr_map_0_grant_addr >= timer_WB0_BASE_ADDR)   & (bus_socket_wb_addr_map_0_grant_addr <= timer_WB0_END_ADDR));
 endmodule

