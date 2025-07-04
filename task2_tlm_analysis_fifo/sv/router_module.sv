package router_module;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

        
    // Import required packages first
    import yapp_pkg::*;      // For yapp_packet
    import channel_pkg::*;   // For channel_packet  
    import hbus_pkg::*;      // For hbus_transaction
    
    
    //`include "router_scoreboard.sv"
    `include "new_router_scoreboard.sv"
    `include "router_reference.sv"
    `include "router_module_env.sv"
endpackage