module SPI_Wrapper_Tb ();
reg MOSI,SS_n,clk,rst_n;
reg [7:0] addr;
reg [7:0] data;
wire MISO;
SPI_Wrapper TEST(MOSI,SS_n,clk,rst_n,MISO);
initial begin
    clk=0;
    forever begin
        #1 clk=~clk;
    end
end
integer i;
initial begin
    {rst_n,SS_n,MOSI,addr,data}=0;
    @(negedge clk); //// to deassert all output signals
    rst_n=1;
    repeat(2000) begin  
    SS_n=0;
    MOSI=0;
    repeat(2) @(negedge clk);  /// to reach WRITE state ( 1 for CHK_CMD and 1 for WRITE )
    repeat(2) @(negedge clk);  /// to make rx_data[9:8] = 2'b00
    for(i=0;i<8;i=i+1) begin
        MOSI=$random;
        addr[7-i]=MOSI;  /// to store addr
        @(negedge clk); 
    end
    SS_n=1; /// to end Comm
    @(negedge clk); /// to fetch from RAM and SPI 
    SS_n=0;/// to start Comm 
    MOSI=0;  
    repeat(2) @(negedge clk);  /// to reach WRITE state ( 1 for CHK_CMD and 1 for WRITE )
    MOSI=0; @(negedge clk) ;  // rx_data[9]=0
    MOSI=1; @(negedge clk) ;  // rx_data[8]=1
    for(i=0;i<8;i=i+1) begin
    MOSI=$random;
    data[7-i]=MOSI;
    @(negedge clk);
    end
    SS_n=1; // to end comm 
    @(negedge clk);
    SS_n=0; // to start comm
    MOSI=1; // towards READ add
    repeat(2) @(negedge clk); // to reach READ_ADD
    @(negedge clk) // rx_data[9]=1;
    MOSI=0; @(negedge clk); // rx_data[8]=0; // 10 
    for(i=0;i<8;i=i+1) begin
      MOSI=addr[7-i];
      @(negedge clk); // make rd_add = ff
    end
     SS_n=1;
    @(negedge clk); // fetch memory 
     SS_n=0;
     MOSI=1; repeat(2) @(negedge clk); //reach  read data
     repeat(2) @(negedge clk); // rx_data[9:8]=2'b11
     repeat(8) begin
     MOSI=$random;  // dumy inputs 
     @(negedge clk);
     end 
     @(negedge clk) // to fetch from memory 
     for(i=0;i<8;i=i+1) begin // to convert tx_data to serial MISO 
         if(MISO!=data[7-i]) begin
        $display("Error In SPI Master Slave");
        $stop;
        end
         @(negedge clk);
     end 
     SS_n=1; // to end comm 
     @(negedge clk);
    end ///  tx_valid should be converted to zero 
     $stop;
end
endmodule //SPI_Wrapper_Tb