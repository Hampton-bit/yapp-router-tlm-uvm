class router_reference extends uvm_component;
    `uvm_component_utils(router_reference)

    `uvm_analysis_imp_decl(_yapp)
    uvm_analysis_imp_yapp #(yapp_packet,router_reference) yapp_in;

    `uvm_analysis_imp_decl(_hbus)
    uvm_analysis_imp_hbus #(hbus_transaction ,router_reference) hbus_in;

    uvm_analysis_port #(yapp_packet) valid_yapp_packets;

    int maxpktsize;
    int router_en;

    int packets_counter;

    int packet_dropped_size;
    int packet_dropped_en;
    int packet_dropped_addr;


    function new(string name, uvm_component parent);
        super.new(name, parent);
        yapp_in            = new("yapp_in",            this);
        hbus_in            = new("hbus_in",            this);
        valid_yapp_packets = new("valid_yapp_packets", this);
    endfunction 


    function void write_yapp(yapp_packet ypkt);
        
        if(router_en && (packets_counter < maxpktsize) && (ypkt.addr inside {0,1,2}) ) begin 
            valid_yapp_packets.write(ypkt);
        end 

        if(!router_en) begin 
            packet_dropped_en++;
            `uvm_error(get_type_name(), "Router disabled: packet dropped in reference model")
        end 

        if(! (packets_counter < maxpktsize)) begin 
            packet_dropped_size++;
            `uvm_error(get_type_name(), "Invalid packet size: packet dropped in reference model")
        end

        if(!(ypkt.addr inside {0,1,2}) ) begin 
            packet_dropped_addr++;
            `uvm_error(get_type_name(), "Invalid Addr: packet dropped in reference model")
        end 

    endfunction

    function void write_hbus(hbus_transaction h_b_tr);
        if(h_b_tr.haddr== 16'h1000) begin
            maxpktsize = h_b_tr.hdata;
        end 
        if(h_b_tr.haddr== 16'h1001) begin
            router_en  = h_b_tr.hdata;
        end
    endfunction


endclass 