module global_sram_loader(
    //AHB
   output logic [31:0]                  ahb_if_haddr,
   output logic                        ahb_if_hwrite,
   output logic [31:0]                  ahb_if_hwdata,
   output logic [1:0]                   ahb_if_htrans,
   output logic [2:0]                   ahb_if_hsize,
   output logic                        ahb_if_hsel,
   output logic [2:0]                   ahb_if_hburst,
   output logic                        ahb_if_hreadyin,
   input  logic                        ahb_if_hready,
   input  logic [31:0]                  ahb_if_hrdata,
   input  logic [1:0]                   ahb_if_hresp,
   input clk
);
   logic [31:0] mem0 [2047:0];
   logic [31:0] mem1 [2047:0];
   logic [31:0] mem2 [2047:0];
   logic [31:0] mem3 [2047:0];
   logic [31:0] mem4 [2047:0];
   logic [31:0] mem5 [2047:0];
   logic [31:0] mem6 [2047:0];
   logic [31:0] mem7 [2047:0];

   logic [31:0] mem10 [2047:0];
   logic [31:0] mem11 [2047:0];
   logic [31:0] mem12 [2047:0];
   logic [31:0] mem13 [2047:0];
   logic [31:0] mem14 [2047:0];
   logic [31:0] mem15 [2047:0];
   logic [31:0] mem16 [2047:0];
   logic [31:0] mem17 [2047:0];

    assign ahb_if_hreadyin='0;
    logic [31:0]         queue_ahb_hwrite  [$] ;
    logic [31:0]         queue_ahb_haddr  [$] ;
    logic [31:0]         queue_ahb_hwdata  [$] ;
    logic [31:0]         queue_ahb_hrdata  [$] ;

    bit write;

    always @(posedge clk)
        if (queue_ahb_haddr.size())
            begin
               write=queue_ahb_hwrite.pop_front();
               if(write==1) begin
               //write
                  ahb_if_hwdata  <= '0;
                  ahb_if_haddr  <= queue_ahb_haddr.pop_front();
                  ahb_if_hwrite  <= 1'b1;
                  ahb_if_hsel  <= 1'b1;
                  ahb_if_htrans  <= 2'b10;
                  ahb_if_hsize   <= 3'b010;
                  ahb_if_hburst  <= 3'b000;
                  @(negedge clk);
                  while ((ahb_if_hready)== 1'b0) @(negedge clk);
                  @(posedge clk);
                  ahb_if_hwdata  <= queue_ahb_hwdata.pop_front();
                  ahb_if_haddr  <= '0;
                  ahb_if_hwrite  <='0;
                  ahb_if_hsel  <= '0;
                  ahb_if_htrans  <='0;
                  ahb_if_hsize   <='0;
                  ahb_if_hburst  <='0;
                  @(negedge clk);
                  while ((ahb_if_hready)== 1'b0) @(negedge clk);
                  /*
                  @(posedge clk);
                  ahb_if_hwdata  <= '0;
                  ahb_if_haddr  <= '0;
                  ahb_if_hwrite  <='0;
                  ahb_if_hsel  <= '0;
                  ahb_if_htrans  <='0;
                  ahb_if_hsize   <='0;
                  ahb_if_hburst  <='0;
                  */
               //read
               end else begin
                  ahb_if_hwdata  <= '0;
                  ahb_if_haddr  <= queue_ahb_haddr.pop_front();
                  ahb_if_hwrite  <= 1'b0;
                  ahb_if_hsel  <= 1'b1;
                  ahb_if_htrans  <= 2'b10;
                  ahb_if_hsize   <= 3'b010;
                  ahb_if_hburst  <= 3'b000;
                  @(negedge clk);
                  while ((ahb_if_hready)== 1'b0) @(negedge clk);
                  @(posedge clk);
                  ahb_if_hwdata  <= '0;
                  ahb_if_haddr  <= '0;
                  ahb_if_hwrite  <='0;
                  ahb_if_hsel  <= '0;
                  ahb_if_htrans  <='0;
                  ahb_if_hsize   <='0;
                  ahb_if_hburst  <='0;
                  @(negedge clk);
                  while ((ahb_if_hready)== 1'b0) @(negedge clk);
                  queue_ahb_hrdata.push_back(ahb_if_hrdata);
               end
            end
        else
            begin
                ahb_if_hwdata  <= '0;
                ahb_if_haddr  <= '0;
                ahb_if_hwrite  <='0;
                ahb_if_hsel  <= '0;
                ahb_if_htrans  <='0;
                ahb_if_hsize   <='0;
                ahb_if_hburst  <='0;
            end

   task begin_transfer;
        input [1:0] die_index;
        bit [31:0] offset;
        bit [31:0] addr;
        bit [31:0] data;
        bit [31:0] global_addr;
        case(die_index) 
            2'b00: offset=32'h01000000;
            2'b01: offset=32'h01200000;
            2'b10: offset=32'h01400000;
            2'b11: offset=32'h01600000;
        endcase
        global_addr=offset+addr;
        $display ("[%t] #########  START LOADING DIE %d ITCM THROUGH AHB   #########",$time, die_index);
        for(addr=32'h00010000;addr<32'h00020000;addr=addr+4) begin
            case (addr[15:13])
                3'b000:data=mem0[addr[12:2]];
                3'b001:data=mem1[addr[12:2]];
                3'b010:data=mem2[addr[12:2]];
                3'b011:data=mem3[addr[12:2]];
                3'b100:data=mem4[addr[12:2]];
                3'b101:data=mem5[addr[12:2]];
                3'b110:data=mem6[addr[12:2]];
                3'b111:data=mem7[addr[12:2]];
            endcase
            queue_ahb_hwrite.push_back(1'b1);
            queue_ahb_haddr.push_back(global_addr);
            queue_ahb_hwdata.push_back(data);
        end

        wait_until_empty();
        $display ("[%t] #########  DIE %d ITCM LOADING DONE    #########",$time, die_index);

        repeat(100) @(posedge clk);

        $display ("[%t] #########  START LOADING DIE %d DTCM THROUGH AHB   #########",$time, die_index);
        for(addr=32'h00050000;addr<32'h00060000;addr=addr+4) begin
            case (addr[15:13])
                3'b000:data=mem10[addr[12:2]];
                3'b001:data=mem11[addr[12:2]];
                3'b010:data=mem12[addr[12:2]];
                3'b011:data=mem13[addr[12:2]];
                3'b100:data=mem14[addr[12:2]];
                3'b101:data=mem15[addr[12:2]];
                3'b110:data=mem16[addr[12:2]];
                3'b111:data=mem17[addr[12:2]];
            endcase
            queue_ahb_hwrite.push_back(1'b1);
            queue_ahb_haddr.push_back(global_addr);
            queue_ahb_hwdata.push_back(data);
        end

        wait_until_empty();
        $display ("[%t] #########  DIE %d DTCM LOADING DONE    #########",$time, die_index);
   endtask

task ahb_write;
    input [1:0] die_index;
    input [31:0] address;
    input [31:0] data;
    bit [31:0] offset;
    bit [31:0] global_addr;
    case(die_index)
      2'b00: offset=32'h01000000;
      2'b01: offset=32'h01200000;
      2'b10: offset=32'h01400000;
      2'b11: offset=32'h01600000;
    endcase
    global_addr=offset+address;
    //$display ("die_index=%d, offset=0x%h, global_addr=0x%0h",die_index,offset,global_addr);
    queue_ahb_haddr.push_back(global_addr);
    queue_ahb_hwdata.push_back(data);
    queue_ahb_hwrite.push_back(1'b1);
    $display ("[%t] AHB WRDATA [0x%h] to Addr [0x%h]",$time,data,global_addr);
endtask

task ahb_read;
    input [1:0] die_index;
    input [31:0] address;
    output [31:0] data;
    bit [31:0] offset;
    bit [31:0] global_addr;
    case(die_index) 
      2'b00: offset=32'h01000000;
      2'b01: offset=32'h01200000;
      2'b10: offset=32'h01400000;
      2'b11: offset=32'h01600000;
    endcase
    global_addr=offset+address;
    queue_ahb_haddr.push_back(global_addr);
    queue_ahb_hwrite.push_back(1'b0);
    wait(queue_ahb_hrdata.size()!=0);
    data=queue_ahb_hrdata.pop_front();
    $display ("[%t] AHB RDDATA [0x%h] from Addr [0x%h]",$time,data,global_addr);
endtask

task ahb_write_all_lane;
    input [1:0] die_index;
    input [31:0] address;
    input [31:0] data;
    bit [31:0] offset;
    bit [31:0] global_addr;
    case(die_index) 
      2'b00: offset=32'h01000000;
      2'b01: offset=32'h01200000;
      2'b10: offset=32'h01400000;
      2'b11: offset=32'h01600000;
    endcase
    global_addr=offset+address;
    queue_ahb_haddr.push_back(global_addr);
    queue_ahb_hwdata.push_back(data);
    queue_ahb_hwrite.push_back(1'b1);
    queue_ahb_haddr.push_back(global_addr+4);
    queue_ahb_hwdata.push_back(data);
    queue_ahb_hwrite.push_back(1'b1);
    queue_ahb_haddr.push_back(global_addr+8);
    queue_ahb_hwdata.push_back(data);
    queue_ahb_hwrite.push_back(1'b1);
    queue_ahb_haddr.push_back(global_addr+12);
    queue_ahb_hwdata.push_back(data);
    queue_ahb_hwrite.push_back(1'b1);
    queue_ahb_haddr.push_back(global_addr+16);
    queue_ahb_hwdata.push_back(data);
    queue_ahb_hwrite.push_back(1'b1);
    queue_ahb_haddr.push_back(global_addr+20);
    queue_ahb_hwdata.push_back(data);
    queue_ahb_hwrite.push_back(1'b1);
    queue_ahb_haddr.push_back(global_addr+24);
    queue_ahb_hwdata.push_back(data);
    queue_ahb_hwrite.push_back(1'b1);
    queue_ahb_haddr.push_back(global_addr+28);
    queue_ahb_hwdata.push_back(data);
    queue_ahb_hwrite.push_back(1'b1);
    queue_ahb_haddr.push_back(global_addr+32);
    queue_ahb_hwdata.push_back(data);
    queue_ahb_hwrite.push_back(1'b1);
    $display ("[%t] AHB WRDATA [0x%h] to Addr from [0x%h] to [0x%h]",$time,data,global_addr,global_addr+32);
    wait_until_empty();
endtask

task wait_until_empty;

integer wait_timeout;

begin
  wait_timeout = 10_000_000;

  fork
    begin
      wait (
             // Initiators
             (queue_ahb_haddr.size  () == 0) &&
             (queue_ahb_hwdata.size   () == 0) );

    end

    begin
      @(posedge clk);
      while (wait_timeout > 0)
      begin
        wait_timeout = wait_timeout - 1;
        @(posedge clk);
      end
    end
  join_any

  if (wait_timeout <= 0)
  begin
    $display ("ERROR Timeout waiting for quiescence at time %t", $time);
    $display ("   queue_ahb_haddr.size  () = %d", queue_ahb_haddr.size  () );
    $display ("   queue_ahb_hwdata.size  () = %d", queue_ahb_hwdata.size  () );
    $finish();
  end

end
endtask

   task loadmem_00;
      input [1000*8-1:0] filename;
      begin
         $readmemb(filename, mem0);
      end
   endtask

   task loadmem_01;
      input [1000*8-1:0] filename;
      begin
         $readmemb(filename, mem1);
      end
   endtask

   task loadmem_02;
      input [1000*8-1:0] filename;
      begin
         $readmemb(filename, mem2);
      end
   endtask

   task loadmem_03;
      input [1000*8-1:0] filename;
      begin
         $readmemb(filename, mem3);
      end
   endtask

   task loadmem_04;
      input [1000*8-1:0] filename;
      begin
         $readmemb(filename, mem4);
      end
   endtask

   task loadmem_05;
      input [1000*8-1:0] filename;
      begin
         $readmemb(filename, mem5);
      end
   endtask

   task loadmem_06;
      input [1000*8-1:0] filename;
      begin
         $readmemb(filename, mem6);
      end
   endtask

   task loadmem_07;
      input [1000*8-1:0] filename;
      begin
         $readmemb(filename, mem7);
      end
   endtask

   task loadmem_10;
      input [1000*8-1:0] filename;
      begin
         $readmemb(filename, mem10);
      end
   endtask

   task loadmem_11;
      input [1000*8-1:0] filename;
      begin
         $readmemb(filename, mem11);
      end
   endtask

   task loadmem_12;
      input [1000*8-1:0] filename;
      begin
         $readmemb(filename, mem12);
      end
   endtask

   task loadmem_13;
      input [1000*8-1:0] filename;
      begin
         $readmemb(filename, mem13);
      end
   endtask

   task loadmem_14;
      input [1000*8-1:0] filename;
      begin
         $readmemb(filename, mem14);
      end
   endtask

   task loadmem_15;
      input [1000*8-1:0] filename;
      begin
         $readmemb(filename, mem15);
      end
   endtask

   task loadmem_16;
      input [1000*8-1:0] filename;
      begin
         $readmemb(filename, mem16);
      end
   endtask

   task loadmem_17;
      input [1000*8-1:0] filename;
      begin
         $readmemb(filename, mem17);
      end
   endtask


endmodule
