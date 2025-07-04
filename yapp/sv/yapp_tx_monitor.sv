class yapp_tx_monitor extends uvm_monitor; //#(yapp_packet);
    `uvm_component_utils(yapp_tx_monitor)

            // Collected Data handle
    yapp_packet pkt;
  
    // Count packets collected
    int num_pkt_col;
    virtual yapp_if vif;
    uvm_analysis_port #(yapp_packet) yapp_out;

    function new( string name, uvm_component parent);
        super.new(name, parent);
        yapp_out= new("yapp_out", this);
    endfunction 

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction 


    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if(!uvm_config_db #(virtual interface yapp_if)::get(this, "", "vif",vif))
        `uvm_fatal(get_type_name(), "virtual interface getting failed in monitor")
    endfunction 

    virtual function void start_of_simulation_phase(uvm_phase phase);
        super.start_of_simulation_phase(phase);
        `uvm_info(get_type_name(), "[MONITOR]:Running Simulation" , UVM_HIGH)
    endfunction 

    // UVM run() phase
    task run_phase(uvm_phase phase);
    // Look for packets after reset
    @(posedge vif.reset)
    @(negedge vif.reset)
    `uvm_info(get_type_name(), "Detected Reset Done", UVM_MEDIUM)
    forever begin 
      // Create collected packet instance
      pkt = yapp_packet::type_id::create("pkt", this);

      // concurrent blocks for packet collection and transaction recording
      fork
        // collect packet
        vif.collect_packet(pkt.length, pkt.addr, pkt.payload, pkt.parity);
        // trigger transaction at start of packet
        @(posedge vif.monstart) void'(begin_tr(pkt, "Monitor_YAPP_Packet"));
      join

      pkt.parity_type = (pkt.parity == pkt.calc_parity()) ? GOOD_PARITY : BAD_PARITY;
      // End transaction recording
      end_tr(pkt);
      `uvm_info(get_type_name(), $sformatf("Packet Collected :\n%s", pkt.sprint()), UVM_LOW)
      yapp_out.write(pkt);
      num_pkt_col++;
    //   `uvm_info(get_type_name(), $sformatf("Packet is \n %s",pkt.sprint()), UVM_LOW)
    end
   endtask : run_phase

 
   // UVM report_phase
   function void report_phase(uvm_phase phase);
     `uvm_info(get_type_name(), $sformatf("Report: YAPP Monitor Collected %0d Packets", num_pkt_col), UVM_LOW)
   endfunction : report_phase


endclass