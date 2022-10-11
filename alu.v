module alu (overflow,alu_out,zero,src_a,src_b,opcode,clk,reset) ;
//input output declartion
output reg overflow,zero ;
output reg[3:0]alu_out ;
input signed[3:0] src_a,src_b;
input[2:0]opcode ;
input clk, reset;
reg signed[4:0] tmp; //to solve the overflow problem

always@(*)begin
          case(opcode)
              3'b000:  //no operation
                  begin
                      tmp = 4'd0;
                  end
              3'b001:  //and   
                  begin
                      tmp = src_a&src_b;
                  end
              3'b010: //or        
                  begin
                      tmp = src_a|src_b;
                  end
              3'b011: //pass
                  begin
                      tmp = src_a;
                  end
              3'b100: //+
                  begin
                   tmp = src_a+src_b;
                  end
              3'b101: //-
                  begin
                   tmp = src_a-src_b;                   
                  end
              3'b110: //shift right
                  begin	     
                      tmp = {1'b0, src_a} >> src_b;
                  end
              3'b111: //shift left
                  begin
                      tmp = {1'b0, src_a} << src_b;
                  end   
              default: tmp = 0;

       endcase   
end 

always@(posedge clk or posedge reset)begin
if(reset)
	alu_out <= 0;
else
	alu_out <= tmp[3:0];
end


always@(posedge clk or posedge reset)begin//overflow
if(reset)
	overflow <= 0;
else if(((tmp > 7) || (tmp < -8))&&((opcode == 3'b100) || (opcode == 3'b101)))
	overflow <= 1;
else
	overflow <= 0;
end



always@(posedge clk or posedge reset)begin
if(reset)
	zero <= 0;
else if(tmp == 0)
	zero <= 1;
else
	zero <= 0;
end
endmodule

