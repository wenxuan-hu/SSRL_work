//  ******************************************************
//  Author            : Wenxuan Hu
//  Last modified     : 2022-11-04 09:12
//  Email             : huwe0427@uw.edu
//  Filename          : axi_interface.sv
//  Description       :
//    Copyright [2021] <Copyright Wenxuan Hu>
//  ******************************************************

interface axi_interface(input clk,rst);
    axi_aw_interface aw_if(clk,rst);
    axi_w_interface w_if(clk,rst);
    axi_b_interface b_if(clk,rst);
    axi_ar_interface ar_if(clk,rst);
    axi_r_interface r_if(clk,rst);
endinterface

interface axi_aw_interface(input clk,rst);
    //axi aw channel
	logic valid;
	logic ready;
	logic first;
	logic last;
	logic [31:0] addr;
	logic [1:0] burst;
	logic [7:0] len;
	logic [2:0] size;
	logic  lock;
	logic [2:0] prot;
	logic [3:0] cache;
	logic [3:0] qos;
	logic [7:0]id;
    clocking axi_master @(posedge clk);
        default input #500ps output #500ps;
        input ready;
        output valid,first,last,addr,burst,len,size,id;
        output lock,prot,cache,qos;
    endclocking
endinterface

interface axi_w_interface(input clk,rst);
    //axi w channel
	logic valid;
	logic ready;
	logic first;
	logic last;
	logic [255:0] data;
	logic [31:0] strb;
	logic id;
    clocking axi_master @(posedge clk);
        default input #500ps output #500ps;
        input ready;
        output valid,first,last,data,strb,id;
    endclocking
endinterface

interface axi_b_interface(input clk,rst);
    //axi b channel
	logic valid;
	logic ready;
	logic first;
	logic last;
	logic [1:0] resp;
	logic [7:0] id;
    clocking axi_master @(posedge clk);
        default input #500ps output #500ps;
        output ready;
        input valid,first,last,resp,id;
    endclocking
endinterface
	
interface axi_ar_interface(input clk,rst);
    //axi ar channel
	logic valid;
	logic ready;
	logic first;
	logic last;
	logic [31:0] addr;
	logic [1:0] burst;
	logic [7:0] len;
	logic [3:0] size;
	logic [1:0] lock;
	logic [2:0] prot;
	logic [3:0] cache;
	logic [3:0] qos;
	logic id;
    clocking axi_master @(posedge clk);
        default input #0.1 output #0.1;
        input ready;
        output valid,first,last,addr,burst,len,size,id;
        output lock,prot,cache,qos;
    endclocking

endinterface
	
interface axi_r_interface(input clk,rst);
    //axi r channel
	logic valid;
	logic ready;
	logic first;
	logic last;
	logic [1:0] resp;
	logic [255:0] data;
	logic id;
    clocking axi_master @(posedge clk);
        default input #500ps output #500ps;
        output ready;
        input valid,first,last,data,resp,id;
    endclocking
endinterface
