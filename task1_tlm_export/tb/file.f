// 64 bit option for AWS labs
-64

-uvmhome /home/cc/mnt/XCELIUM2309/tools/methodology/UVM/CDNS-1.1d

+UVM_VERBOSITY=UVM_LOW

//+UVM_TESTNAME=short_packet_test
-timescale 1ns/1ps
+UVM_TESTNAME=test_mcseq
//+UVM_TESTNAME=set_config_test

//+UVM_TR_RECORD \
//+UVM_LOG_RECORD \
//+define+UVM_ENABLE_TRANSACTION_RECORDING \

//-debug_opts verisium_interactive


// include directories
//*** add incdir include directories here
-incdir ../../yapp/sv
-incdir ../../channel/sv
-incdir ../../hbus/sv
-incdir ../../clock_and_reset/sv
//-incdir ../../task3_scb2/sv
-incdir ../../task1_tlm_export/sv

// compile files
//*** add compile files here
../../yapp/sv/yapp_pkg.sv
../sv/router_module.sv

../../channel/sv/channel_pkg.sv
../../hbus/sv/hbus_pkg.sv
../../clock_and_reset/sv/clock_and_reset_pkg.sv

tb_top.sv
hw_top.sv
../../yapp/sv/yapp_if.sv

../../channel/sv/channel_if.sv
../../hbus/sv/hbus_if.sv
../../clock_and_reset/sv/clock_and_reset_if.sv

clkgen.sv
../../router_rtl/yapp_router.sv

///router module package containing scoreboard, reference model and sub-env



+define+UVM_NO_DEPRECATED