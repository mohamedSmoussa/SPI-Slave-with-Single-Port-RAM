module Single_Port_RAM (din,rx_valid,clk,rst_n,dout,tx_valid);
parameter MEM_DEPTH = 256;
parameter ADDR_SIZE = 8 ;
input [9:0] din;
input rx_valid,clk,rst_n ;
output reg [7:0] dout ;
output reg tx_valid;
reg [7:0] mem [MEM_DEPTH-1:0]; // memory
reg [ADDR_SIZE-1:0] wr_Addr,rd_Addr; //Separated two addresses for write and read operations
reg [3:0] tx_valid_counter;   // counter to deassert tx_valid after 8 cycles [0 to 7]
always @(posedge clk) begin
    if(~rst_n) begin 
        dout<=0;
        wr_Addr<=0;
        rd_Addr<=0;
        tx_valid<=0;
        tx_valid_counter<=0;
    end 
    else if (tx_valid_counter==7 && tx_valid) begin // Check if 8 clock cycles have been reached to deassert tx_valid.
         tx_valid_counter<=0;
         tx_valid<=0;
    end
    else if (tx_valid) tx_valid_counter<=tx_valid_counter+1;
    else if(rx_valid) begin 
    case(din[9:8])
    2'b00:  wr_Addr<=din[7:0];
    2'b01:  mem[wr_Addr]<=din[7:0];
    2'b10:  rd_Addr<=din[7:0];
    2'b11: begin /// forced to  wait rx_data after 10 clk   
           dout<=mem[rd_Addr]; /// tx_data 
           tx_valid<=1;
           end 
    endcase
    end 
end
endmodule

