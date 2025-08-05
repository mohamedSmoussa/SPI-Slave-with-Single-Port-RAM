module SPI (MOSI,SS_n,clk,rst_n,tx_data,tx_valid,rx_data,rx_valid,MISO);
// Declaration of FSM states
parameter IDLE =0;
parameter CHK_CMD=1;
parameter WRITE =2;
parameter READ_ADD =3 ;
parameter READ_DATA =4;
(*fsm_encoding="gray"*)reg [2:0] ns,cs;
reg rd_data; //// wire control read state IF 1 (DATA) IF 0 (ADD)
input MOSI,SS_n,tx_valid,clk,rst_n;
input [7:0] tx_data;
output reg rx_valid;
output  MISO;
output reg [9:0] rx_data;
reg [3:0] clk_count; // Controls the number of clock cycles needed for rx_data and MISO 
/////// state memory  //////
always @(posedge clk) begin
    if(~rst_n) begin 
        cs<=IDLE;
    end 
    else cs<=ns;
end

//////////// Next State Logic ////////////
always @(*) begin
    case(cs)
    IDLE:begin  if(!SS_n) ns=CHK_CMD;
                 else ns=IDLE;
    end
    CHK_CMD: begin
        if(SS_n) ns=IDLE;
        else if(!MOSI) ns=WRITE;
        else if(MOSI)  begin
          if(!rd_data)
          ns=READ_ADD;
          else ns=READ_DATA;
        end
    end 
    WRITE:begin if(SS_n) ns=IDLE;
           else ns=WRITE;
    end
    READ_ADD:begin if(SS_n) ns=IDLE;
                   else begin
                     ns=READ_ADD;
                   end 
    end
    READ_DATA:begin if(SS_n) ns=IDLE;
                    else begin
                      ns=READ_DATA;
                    end   
    end
    endcase
end

////////////// Output Logic /////////////////
always @(posedge clk) begin
     if(!rst_n) begin
       rx_data<=0;
       rx_valid<=0;
       clk_count<=0;
       rd_data<=0;
     end
    else begin
     if(~SS_n) begin
     rx_valid<=0;
     if(cs==WRITE || cs==READ_ADD) begin
        rx_data<={rx_data[8:0],MOSI}; /// Serial to parllel Conversion (insert before checking)
        if(clk_count==9) begin
        rx_valid<=1;  // After 10 clock cycles rx_valid should be asserted to communicate with RAM
        clk_count<=0;
        if(cs==READ_ADD) rd_data<=1;//rd_data must be high to trigger next transition to the READ_DATA state
        end 
        else begin
         clk_count<=clk_count+1;
        end
    end 
    else if (cs==READ_DATA) begin
        if (!tx_valid) begin  //if true Send rx_data (with dummy bits) and assert rx_valid to receive tx_valid and tx_data (10 clk)
          rx_data<={rx_data[8:0],MOSI}; /// Serial to parllel Conversion
            if(clk_count==9) begin
            rx_valid<=1;  // After 10 clock cycles rx_valid should be asserted to communicate with RAM
            clk_count<=0;
         end
        else clk_count<=clk_count+1;
        end 
        else  
        begin /// if tx_valid HIGH 
        if(clk_count>7) begin // When clock count reaches 8 reset it to zero in the next cycle
          clk_count<=0;
          rd_data<=0;
        end
        else  clk_count<=clk_count+1; 
        end
    end
    end
    else rx_valid<=0;
    end 
      end
      assign MISO=(tx_valid&&cs==READ_DATA)?tx_data[8-clk_count]:0;    
     //Due to the fetch cycle between RAM and SPI, tx_valid is asserted one cycle after rx_valid goes high
     // tx_data[8 - clk_count] ensures transmission of tx7 to tx0, and stops when tx_valid goes low
endmodule //SPI