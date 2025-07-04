class router_module_env extends uvm_env;
    `uvm_component_utils(router_module_env)

    router_scoreboard r_scb;
    router_reference  r_ref;
    uvm_analysis_export #(yapp_packet) ref_yapp_exp;
    uvm_analysis_export #(hbus_transaction) ref_hbus_exp;

    uvm_analysis_export #(channel_packet) scb_C0_exp;
    uvm_analysis_export #(channel_packet) scb_C1_exp;
    uvm_analysis_export #(channel_packet) scb_C2_exp;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        ref_yapp_exp=new("ref_yapp_exp", this);
        ref_hbus_exp=new("ref_hbus_exp", this);

        scb_C0_exp=new("scb_C0_exp", this);
        scb_C1_exp=new("scb_C1_exp", this);
        scb_C2_exp=new("scb_C2_exp", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        r_scb     = router_scoreboard::type_id::create("r_scb",     this);
        r_ref     = router_reference::type_id::create("r_ref",      this);
    endfunction 

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        r_ref.valid_yapp_packets.connect(r_scb.yapp_in);

        ref_yapp_exp.connect(r_ref.yapp_in);
        ref_hbus_exp.connect(r_ref.hbus_in);

        scb_C0_exp.connect(r_scb.C0_in);
        scb_C1_exp.connect(r_scb.C1_in);
        scb_C2_exp.connect(r_scb.C2_in);

    endfunction


endclass 