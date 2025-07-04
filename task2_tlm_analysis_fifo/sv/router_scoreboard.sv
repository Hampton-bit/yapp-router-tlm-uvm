class router_scoreboard extends uvm_scoreboard;
`uvm_component_utils(router_scoreboard)

    int packets_received, wrong_packets, matched_packets;

    `uvm_analysis_imp_decl(_yapp)
    uvm_analysis_imp_yapp #(yapp_packet, router_scoreboard) yapp_in;

    `uvm_analysis_imp_decl(_C0)
    uvm_analysis_imp_C0 #(channel_packet, router_scoreboard) C0_in;


    `uvm_analysis_imp_decl(_C1)
    uvm_analysis_imp_C1  #(channel_packet, router_scoreboard)C1_in;


    `uvm_analysis_imp_decl(_C2)
    uvm_analysis_imp_C2  #(channel_packet, router_scoreboard)C2_in;

    yapp_packet q0 [$];
    yapp_packet q1 [$];
    yapp_packet q2 [$];

    function new(string name, uvm_component parent);
        super.new(name, parent);
        yapp_in = new("yapp_in", this);
        C0_in   = new("C0_in"  , this);
        C1_in   = new("C1_in"  , this);
        C2_in   = new("C2_in"  , this);
    endfunction 

    function bit comp_equal (input yapp_packet yp, input channel_packet cp);
        // returns first mismatch only
        if (yp.addr != cp.addr) begin
          `uvm_error("PKT_COMPARE",$sformatf("Address mismatch YAPP %0d Chan %0d",yp.addr,cp.addr))
          return(0);
        end
        if (yp.length != cp.length) begin
          `uvm_error("PKT_COMPARE",$sformatf("Length mismatch YAPP %0d Chan %0d",yp.length,cp.length))
          return(0);
        end
        foreach (yp.payload [i])
          if (yp.payload[i] != cp.payload[i]) begin
            `uvm_error("PKT_COMPARE",$sformatf("Payload[%0d] mismatch YAPP %0d Chan %0d",i,yp.payload[i],cp.payload[i]))
            return(0);
          end
        if (yp.parity != cp.parity) begin
          `uvm_error("PKT_COMPARE",$sformatf("Parity mismatch YAPP %0d Chan %0d",yp.parity,cp.parity))
          return(0);
        end
        return(1);
     endfunction

    function void write_yapp(input yapp_packet packet);
        yapp_packet ypkt;
        $cast(ypkt, packet.clone());
        packets_received++;
        case(ypkt.addr)
            2'b00: q0.push_back(ypkt);
            2'b01: q1.push_back(ypkt);
            2'b10: q2.push_back(ypkt);
        endcase
    endfunction

    function void write_C0(input channel_packet cp);
        yapp_packet yp;
        if (q0.size() == 0) begin
            `uvm_error(get_type_name(), "No packets in C0 queue")
            wrong_packets++;
            return;
        end
        yp = q0.pop_front();
        if(!comp_equal (yp,cp)) begin 
            `uvm_error(get_type_name(), "packet Mismatch at channel 0")
            wrong_packets++;
        end 
        else begin 
            `uvm_info(get_type_name(), "packet Match at channel 0", UVM_LOW)  
            matched_packets++;       
        end 
    endfunction


    function void write_C1(input channel_packet cp);
        yapp_packet yp;
        if (q1.size() == 0) begin
            `uvm_error(get_type_name(), "No packets in C1 queue")
            wrong_packets++;
            return;
        end
        yp = q1.pop_front();
        if(!comp_equal (yp,cp)) begin 
            `uvm_error(get_type_name(), "packet Mismatch at channel 1")
            wrong_packets++;
        end 
        else begin 
            `uvm_info(get_type_name(), "packet Match at channel 1", UVM_LOW)    
            matched_packets++;    
        end 
    endfunction


    function void write_C2(input channel_packet cp);
        yapp_packet yp;
        if (q2.size() == 0) begin
            `uvm_error(get_type_name(), "No packets in C2 queue")
            wrong_packets++;
            return;
        end
        yp = q2.pop_front();
        if(!comp_equal (yp,cp)) begin 
            `uvm_error(get_type_name(), "packet Mismatch at channel 2")
            wrong_packets++;
        end 
        else begin 
            `uvm_info(get_type_name(), "packet Match at channel 2", UVM_LOW)
            matched_packets++; 
        end 
    endfunction

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info(get_type_name(), $sformatf("No of          packet received: %0d", packets_received), UVM_LOW)
        `uvm_info(get_type_name(), $sformatf("No of WRONG    packet received: %0d", wrong_packets), UVM_LOW)
        `uvm_info(get_type_name(), $sformatf("No of MATCHED  packet received: %0d", matched_packets), UVM_LOW)
    endfunction







     

endclass 