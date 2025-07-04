class base_mcseq extends uvm_sequence; 
    `uvm_object_utils(base_mcseq)
 
        function new(string name="base_mcseq");
            super.new(name);
        endfunction 
        virtual task pre_body();
            if(starting_phase!=null) begin 
                starting_phase.raise_objection(this, get_type_name());
            end 
        endtask 

        virtual task post_body();
            if(starting_phase!=null) begin 
                starting_phase.drop_objection(this, get_type_name());
            end 
        endtask 

    endclass 



class router_simple_mcseq extends base_mcseq; 
`uvm_object_utils(router_simple_mcseq)
`uvm_declare_p_sequencer(router_mcsequencer)
    function new(string name="router_simple_mcseq");
        super.new(name);
    endfunction 
    hbus_small_packet_seq       h_b_small;
    hbus_read_max_pkt_seq       h_b_read_max_packet;
    yapp_012_seq                yapp_seq_012;
    hbus_set_default_regs_seq   h_b_small_63;
    six_yapp_seq                seq_random_6;
    //hbus_read_max_pkt_seq h_b_read_max_packet;
    virtual task body();
        `uvm_do_on(h_b_small,           p_sequencer.hbus_seqr)
        `uvm_do_on(h_b_read_max_packet, p_sequencer.hbus_seqr)
        repeat(2) begin 
            `uvm_do_on(yapp_seq_012,        p_sequencer.yapp_seqr)
        end 

        `uvm_do_on(h_b_small_63,        p_sequencer.hbus_seqr)
        `uvm_do_on(h_b_read_max_packet, p_sequencer.hbus_seqr)
        `uvm_do_on(seq_random_6,        p_sequencer.yapp_seqr)

    endtask
endclass 


