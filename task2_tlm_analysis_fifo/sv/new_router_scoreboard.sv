class new_router_scoreboard extends uvm_scoreboard;
`uvm_component_utils(new_router_scoreboard)

    uvm_tlm_analysis_fifo #(yapp_packet) yapp_fifo;
    uvm_tlm_analysis_fifo #(hbus_transaction) hbus_fifo;

    uvm_tlm_analysis_fifo #(channel_packet) C0_fifo;
    uvm_tlm_analysis_fifo #(channel_packet) C1_fifo;
    uvm_tlm_analysis_fifo #(channel_packet) C2_fifo;

    uvm_get_port #(yapp_packet     )    yapp_get;
    uvm_get_port #(hbus_transaction)    hbus_get;

    uvm_get_port #(channel_packet) C0_get;
    uvm_get_port #(channel_packet) C1_get;
    uvm_get_port #(channel_packet) C2_get;


    int packets_received, wrong_packets, matched_packets;
    int maxpktsize=63;
    int router_en=1;

    //***********************/
    int packets_counter;

    int packet_dropped_size;
    int packet_dropped_en;
    int packet_dropped_addr;
    //***********************/

    // `uvm_analysis_imp_decl(_yapp)
    // uvm_analysis_imp_yapp #(yapp_packet, new_router_scoreboard) yapp_in;

    // `uvm_analysis_imp_decl(_C0)
    // uvm_analysis_imp_C0 #(channel_packet, new_router_scoreboard) C0_in;


    // `uvm_analysis_imp_decl(_C1)
    // uvm_analysis_imp_C1  #(channel_packet, new_router_scoreboard)C1_in;


    // `uvm_analysis_imp_decl(_C2)
    // uvm_analysis_imp_C2  #(channel_packet, new_router_scoreboard)C2_in;

    // yapp_packet q0 [$];
    // yapp_packet q1 [$];
    // yapp_packet q2 [$];

    function new(string name, uvm_component parent);
        super.new(name, parent);

        yapp_fifo   = new("yapp_fifo", this );
        hbus_fifo   = new("hbus_fifo", this );

        C0_fifo     = new("C0_fifo",   this );
        C1_fifo     = new("C1_fifo",   this );
        C2_fifo     = new("C2_fifo",   this );

        yapp_get    = new("yapp_get", this);
        hbus_get    = new("hbus_get", this);
        
        C0_get      = new("C0_get", this);
        C1_get      = new("C1_get", this);
        C2_get      = new("C2_get", this);

    endfunction 

    function void connect_phase(uvm_phase phase);

        super.connect_phase(phase);
        yapp_get.connect(yapp_fifo.get_peek_export);
        hbus_get.connect(hbus_fifo.get_peek_export);

        C0_get.connect(C0_fifo.get_peek_export);
        C1_get.connect(C1_fifo.get_peek_export);
        C2_get.connect(C2_fifo.get_peek_export);
        
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

    // function void write_yapp(input yapp_packet packet);
    //     yapp_packet ypkt;
    //     $cast(ypkt, packet.clone());
    //     packets_received++;
    //     // case(ypkt.addr)
    //     //     2'b00: q0.push_back(ypkt);
    //     //     2'b01: q1.push_back(ypkt);
    //     //     2'b10: q2.push_back(ypkt);
    //     // endcase

    //     case(ypkt.addr)
    //         2'b00: q0.push_back(ypkt);
    //         2'b01: q1.push_back(ypkt);
    //         2'b10: q2.push_back(ypkt);
    //     endcase
    // endfunction

    // function void write_C0(input channel_packet cp);
    //     yapp_packet yp;
    //     if (q0.size() == 0) begin
    //         `uvm_error(get_type_name(), "No packets in C0 queue")
    //         wrong_packets++;
    //         return;
    //     end
    //     yp = q0.pop_front();
    //     if(!comp_equal (yp,cp)) begin 
    //         `uvm_error(get_type_name(), "packet Mismatch at channel 0")
    //         wrong_packets++;
    //     end 
    //     else begin 
    //         `uvm_info(get_type_name(), "packet Match at channel 0", UVM_LOW)  
    //         matched_packets++;       
    //     end 
    // endfunction


    // function void write_C1(input channel_packet cp);
    //     yapp_packet yp;
    //     if (q1.size() == 0) begin
    //         `uvm_error(get_type_name(), "No packets in C1 queue")
    //         wrong_packets++;
    //         return;
    //     end
    //     yp = q1.pop_front();
    //     if(!comp_equal (yp,cp)) begin 
    //         `uvm_error(get_type_name(), "packet Mismatch at channel 1")
    //         wrong_packets++;
    //     end 
    //     else begin 
    //         `uvm_info(get_type_name(), "packet Match at channel 1", UVM_LOW)    
    //         matched_packets++;    
    //     end 
    // endfunction


    // function void write_C2(input channel_packet cp);
    //     yapp_packet yp;
    //     if (q2.size() == 0) begin
    //         `uvm_error(get_type_name(), "No packets in C2 queue")
    //         wrong_packets++;
    //         return;
    //     end
    //     yp = q2.pop_front();
    //     if(!comp_equal (yp,cp)) begin 
    //         `uvm_error(get_type_name(), "packet Mismatch at channel 2")
    //         wrong_packets++;
    //     end 
    //     else begin 
    //         `uvm_info(get_type_name(), "packet Match at channel 2", UVM_LOW)
    //         matched_packets++; 
    //     end 
    // endfunction


    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        fork 
            hbus_monitor();
            check_packets();
        join_none 

    endtask

    task hbus_monitor();
        hbus_transaction h_b_tr;
        forever begin    
            hbus_get.get(h_b_tr);
        
            if(h_b_tr.hwr_rd == HBUS_WRITE) begin 

                if(h_b_tr.haddr== 16'h1000) begin
                    maxpktsize = h_b_tr.hdata;
                end 
                else if(h_b_tr.haddr== 16'h1001) begin
                    router_en  = h_b_tr.hdata;
                end
                else `uvm_info(get_type_name(), $sformatf("HBUS write to addr: %0h, data: %0h", h_b_tr.haddr, h_b_tr.hdata), UVM_HIGH)
            end 
        end 

    endtask

    task check_packets();
        yapp_packet ypkt;
        forever begin 
            yapp_get.get(ypkt);

            if(!(!router_en ||(ypkt.length  < maxpktsize ) || (ypkt.addr inside {0,1,2}))) begin 
                packet_dropped_en++;
                continue;
            end 
                if(router_en &&(ypkt.length < maxpktsize ) && (ypkt.addr inside {0,1,2}) ) begin 
                    channel_packet cp;
                    packets_received++;

                    case(ypkt.addr)
                        2'b00:
                            begin 
                                C0_get.get(cp);     
                            end
                        2'b01:
                            begin 
                                C1_get.get(cp);
                            end
                        2'b10:
                            begin 
                                C2_get.get(cp);
                            end
                    endcase
                    
                    if(!comp_equal (ypkt,cp)) begin 
                        `uvm_error(get_type_name(), "packet Mismatch at channel 1")
                        wrong_packets++;
                    end 
                    else begin
                        `uvm_info(get_type_name(), "packet Match", UVM_LOW)
                        matched_packets++;
                    end
                end 
        end     

    endtask

    function void check_phase(uvm_phase phase);
        super.check_phase(phase);
        
        // Check if all FIFOs are empty
        if (yapp_fifo.used() != 0) begin
            `uvm_error(get_type_name(), $sformatf("YAPP FIFO not empty: %0d packets remaining", yapp_fifo.used()))
        end
        
        if (C0_fifo.used() != 0) begin
            `uvm_error(get_type_name(), $sformatf("C0 FIFO not empty: %0d packets remaining", C0_fifo.used()))
        end
        
        if (C1_fifo.used() != 0) begin
            `uvm_error(get_type_name(), $sformatf("C1 FIFO not empty: %0d packets remaining", C1_fifo.used()))
        end
        
        if (C2_fifo.used() != 0) begin
            `uvm_error(get_type_name(), $sformatf("C2 FIFO not empty: %0d packets remaining", C2_fifo.used()))
        end
    endfunction

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info(get_type_name(), $sformatf("No of          packet received: %0d", packets_received), UVM_LOW)
        `uvm_info(get_type_name(), $sformatf("No of WRONG    packet received: %0d", wrong_packets), UVM_LOW)
        `uvm_info(get_type_name(), $sformatf("No of MATCHED  packet received: %0d", matched_packets), UVM_LOW)
    endfunction







     

endclass 