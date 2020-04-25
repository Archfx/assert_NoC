#!/usr/bin/tclsh


transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/mor1k_mpsoc.v}
vlog -sv -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/testbench.v}
vlog -sv -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/mor1k_mpsoc_top.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/crossbar.v}
vlog -sv -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/arbiter.sv}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/altera_reset_synchronizer.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/mor1k.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/congestion_analyzer.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/mor1kx_cpu_cappuccino.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/credit_count.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/input_ports.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/mor1kx_fetch_cappuccino.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/mor1kx_decode_execute_cappuccino.v}
vlog -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/flit_buffer.sv}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/main_comp.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ni_crc32.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ni_vc_dma.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/jtag_uart_wb.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/mor1kx.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/altera_jtag_uart_wb.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/mor1kx_execute_alu.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/routing.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/mesh_torus_routting.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/mor1kx_rf_espresso.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/mor1kx_cache_lru.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/mor1kx_fetch_prontoespresso.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/clk_source.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/timer.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/comb_nonspec.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/mor1kx_execute_ctrl_cappuccino.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/mor1kx_lsu_cappuccino.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/wishbone_bus.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/mor1kx_wb_mux_espresso.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/mor1kx_ctrl_prontoespresso.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/mor1kx_pic.v}
vlog -sv -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/byte_enabled_generic_ram.sv}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/mor1kx_dcache.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/wrra.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ni_vc_wb_slave_regs.v}
vlog -sv -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/generic_ram.sv}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/mor1kx_ctrl_cappuccino.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/comb-spec1.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/noc.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/wb_bram_ctrl.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/fattree.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/canonical_credit_count.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/mor1kx_store_buffer.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/route_mesh.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/mor1kx_bus_if_wb32.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/mor1kx_cpu.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/router.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/mor1kx_fetch_espresso.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/mor1kx_simple_dpram_sclk.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/mor1kx_decode.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/altera_simulator_UART.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/mor1kx_bus_if_avalon.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/mor1kx_immu.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/mor1kx_fetch_tcm_prontoespresso.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/mor1kx_cpu_prontoespresso.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/debug.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/mesh_torus.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/mor1kx_branch_prediction.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/mor1kx_icache.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/mor1kx_ticktimer.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/header_flit.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/tree.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/class_table.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/mor1kx_wb_mux_cappuccino.v}
vlog -sv -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/wb_single_port_ram.sv}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/mor1kx_ctrl_espresso.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/comb_spec2.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/combined_vc_sw_alloc.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/mor1kx_cpu_espresso.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/inout_ports.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ss_allocator.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/mesh_torus_noc.v}
vlog -sv -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ni_master.sv}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/traffic_gen.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/mor1kx_dmmu.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/baseline.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/mor1kx_cfgrs.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/mor1kx_rf_cappuccino.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/mor1kx_true_dpram_sclk.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/mor1kx_lsu_espresso.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/route_torus.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/jtag_wb/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/jtag_wb/jtag_source_probe.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/jtag_wb/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/jtag_wb/vjtag.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/jtag_wb/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/jtag_wb/jtag_system_en.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/jtag_wb/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/lib/jtag_wb/vjtag_wb.v}
vlog -vlog01compat -work work +incdir+/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/tiles/ {/home/archfx/Documents/NoCem-MPSoC/mor1k_mpsoc/src_verilog/tiles/mor1k_tile.v}
	
vsim -t 1ps  -L rtl_work -L work -voptargs="+acc"  testbench

#add wave *
view structure
view signals
run -all
