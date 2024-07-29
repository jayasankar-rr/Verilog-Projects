`timescale 1ns/1ps

module master (
  input pclk,preset,transfer,read_write,pready,
  output reg pwrite,penable,
  output psel1,psel2,
  input [7:0] apb_write_data,prdata,
  input [8:0] apb_write_paddr,apb_read_paddr,
  output reg [7:0] apb_read_data,pwdata,
  output reg [8:0] paddr,
  output perror

);
  
  reg [1:0] state=0, next_state=0;
  
  reg invalid_setup_error,
      setup_error,
      invalid_read_paddr,
      invalid_write_paddr,
      invalid_write_data ;
  
  localparam IDLE=2'b00,
             SETUP=2'b01,
             ENABLE=2'b10;
  
  always @(posedge pclk) begin
    
    if(preset) 
      state <= IDLE;
    
    else
        state<=next_state;
    
  end
  
  always @(*) begin
    
    if(preset)
    next_state<=IDLE;
    
    else begin
      
      pwrite<= (read_write) ? 1'b0 : 1'b1;
     
    case(state)
      
      IDLE: begin
        
        penable<=1'b0;
        
        if(transfer) 
          next_state<=SETUP;
        else
          next_state<=IDLE;
        
      end
      
      SETUP: begin
        
        penable<=1'b0;
        
        if(transfer && !perror) begin
          
          if(read_write)begin
            paddr<=apb_read_paddr;
          end
          
          else begin
            
            paddr<=apb_write_paddr;
            pwdata<=apb_write_data;
            
          end
          next_state<=ENABLE;
        end
          
         else begin
           next_state<=IDLE;
         end
        
      end
      
      ENABLE: begin
        
        if(transfer && !perror ) begin
          
          if (psel1 || psel2) begin
               penable<=1'b1;
            if (pready) begin
              
              if(read_write) begin
                 
                apb_read_data<=prdata;
                next_state<=SETUP;
                
              end
              
              else begin
               
                next_state<=SETUP;
              end
            end
              else
              next_state<=ENABLE;
              
             // end of predy
            
          end
           
          end // end of transfer and perrpr
        
        else
          next_state<=IDLE;
        
        end // end of enable
      
      default : next_state<=IDLE;
      
    endcase
      
    end /////// end of 1st else
    
  end  ///  end of always
  
  assign {psel1,psel2} = ((state != IDLE) ? (paddr[8]) ? {1'b1,1'b0} : {1'b1,1'b0} :2'b00);
  
  always @(*) begin
    
    if(preset) begin
      
      setup_error<=0;
      invalid_read_paddr<=0;
      invalid_write_paddr<=0;
      invalid_write_data<=0;
      
    end
    
    else begin
      
      if(state == IDLE && next_state == ENABLE)
        setup_error<=1;
      
      else
        setup_error<=0;
      
      if(apb_write_data == 8'bxxxxxxxx && !read_write && (state==SETUP || state== ENABLE))
              invalid_write_data<=1;
      else
        invalid_write_data<=0;
      
      if(apb_write_paddr == 9'bxxxxxxxxx && !read_write && (state==SETUP || state== ENABLE))
              invalid_write_paddr<=1;
      else
        invalid_write_paddr<=0;
      
      if(apb_read_paddr == 9'bxxxxxxxxx && read_write && (state==SETUP || state== ENABLE))
              invalid_read_paddr<=1;
      else
        invalid_read_paddr<=0;
      
      if(state == SETUP) begin
        
        if(pwrite) begin
          
          if(apb_write_data == pwdata && apb_write_paddr == paddr)
            setup_error=0;
          
          else 
            setup_error=1;
          
        end
        
        else begin
          
          if(apb_read_paddr == paddr)
            setup_error=0;
          
          else
            setup_error=1;
          
        end
        
      end
      
      else 
        setup_error=0;
      
      
      
    end  // end of 1st else
    
    invalid_setup_error = setup_error ||  invalid_read_paddr || invalid_write_data || invalid_write_paddr  ;
    
    
  end             ///end of always block
  
  assign perror = invalid_setup_error;
  
  
endmodule
  

/*



`timescale 1ns/1ps

module master_tb();

  // Define parameters
  reg pclk;
  reg preset;
  reg transfer;
  reg read_write;
  reg pready;
  reg [7:0] apb_write_data;
  reg [8:0] apb_write_paddr;
  reg [8:0] apb_read_paddr;
  
  wire [7:0] apb_read_data;
  wire [8:0] paddr;
  wire perror;
  wire pwrite;
  wire psel1;
  wire psel2;
  wire penable;

  // Instantiate the master module
  master dut (
    .pclk(pclk),
    .preset(preset),
    .transfer(transfer),
    .read_write(read_write),
    .pready(pready),
    .apb_write_data(apb_write_data),
    .prdata(apb_read_data),
    .apb_write_paddr(apb_write_paddr),
    .apb_read_paddr(apb_read_paddr),
    .apb_read_data(apb_read_data),
    .pwdata(pwdata),
    .paddr(paddr),
    .perror(perror),
    .pwrite(pwrite),
    .psel1(psel1),
    .psel2(psel2),
    .penable(penable)
  );

  // Clock generation
  always begin
    #5 pclk = ~pclk;  // Toggle clock every 5 time units
  end

  // Stimulus generation
  initial begin
    // Initialize inputs
    pclk = 0;
    preset = 1;
    transfer = 0;
    read_write = 0;
    pready = 0;
    apb_write_data = 8'b0;
    apb_write_paddr = 9'b0;
    apb_read_paddr = 9'b0;

    // Apply reset
 #10   preset=1'b0;
    transfer = 1;  // Assuming a transfer is initiated
    
     read_write = 0;  // Example: write operation
     apb_write_data = 8'b10101010;
     apb_write_paddr = 9'b001100110;
    #60 pready = 1;  // Indicate data is ready

    // Add more stimulus as needed

    #100 $finish;  // End simulation after 100 time units
  end

  // Dump waveforms
  initial begin
    $dumpfile("master_tb.vcd");
    $dumpvars(0, master_tb);
    #20 $display("Starting simulation...");
  end

endmodule

*/