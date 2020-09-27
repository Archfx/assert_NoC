#!/usr/bin/tclsh


transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work
vlog -sv -work work +incdir+/home/archfx/Documents/AssertNoc/assert_NoC/TB/ {/home/archfx/Documents/AssertNoc/assert_NoC/TB/flit_tb.v}
vlog -sv -work work +incdir+/home/archfx/Documents/AssertNoc/assert_NoC/Concolic/src/ {/home/archfx/Documents/AssertNoc/assert_NoC/Concolic/src/flit.sv}

	
vsim -t 1ps  -L rtl_work -L work -voptargs="+acc" tb_flit_buffer
# testbench


add wave *
view structure
view signals
run -all
