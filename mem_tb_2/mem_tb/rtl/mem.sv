module mem (
  input wire clk, rst_n, enb, rd_wr,
  input wire [addrWidth -1:0] addr,
  input wire [dataWidth -1:0] data_in,
  output wire [dataWidth -1:0] data_out
);

  parameter int DEPTH = 2**addrWidth;

  reg [dataWidth -1: 0] mem_block ['h200];
  reg [dataWidth -1: 0] outData;

  always @(posedge clk or negedge rst_n) begin
    outData <= 'hZ;

    if (rst_n == 0) begin
      foreach (mem_block[i]) mem_block[i] <= 'ha;
    end 

    else begin
      if (rd_wr) begin
        if (enb) begin
          outData <= mem_block[addr]; 
        end
        else begin
          mem_block[addr] <= mem_block[addr];
        end
      end

      else begin
        if (enb) mem_block[addr] <= data_in;
        else mem_block[addr] <= mem_block[addr];
      end
    end

  end

  assign data_out =  outData;

endmodule