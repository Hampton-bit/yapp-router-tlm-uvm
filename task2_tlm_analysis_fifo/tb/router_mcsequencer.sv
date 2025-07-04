class router_mcsequencer extends uvm_sequencer;
`uvm_component_utils(router_mcsequencer)
    function new(string name="router_mcsequencer", uvm_component parent);
        super.new(name, parent);
    endfunction 

    yapp_tx_sequencer yapp_seqr;
    hbus_master_sequencer hbus_seqr;

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // yapp_seqr=new("yapp_seqr", this);
        // hbus_seqr=new("hbus_seqr", this);
    endfunction 

endclass 