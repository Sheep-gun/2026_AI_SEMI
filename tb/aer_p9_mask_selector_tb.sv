`timescale 1ns/1ps
module aer_p9_mask_selector_tb;
 logic[15:0]candidate;logic[3:0]last,grant;logic valid;integer l,m,errors;logic[3:0]expected;
 aer_gray_rank_mask_selector16 dut(.rank_candidate(candidate),.last_rank(last),.grant_valid(valid),.grant_rank(grant));
 function automatic[3:0]ref_winner(input logic[15:0]mask,input logic[3:0]p);
  integer o,a;logic found;begin ref_winner=0;found=0;for(o=1;o<=16;o=o+1)begin a=(p+o)&15;if(!found&&mask[a])begin ref_winner=a[3:0];found=1;end end end
 endfunction
 initial begin errors=0;candidate=0;last=0;for(l=0;l<16;l=l+1)for(m=0;m<65536;m=m+1)begin last=l[3:0];candidate=m[15:0];#1;expected=ref_winner(candidate,last);if(valid!==(m!=0))errors=errors+1;if(m!=0&&grant!==expected)errors=errors+1;end $display("P9_MASK_SELECTOR errors=%0d",errors);if(errors==0)$display("P9_MASK_SELECTOR_PASS");$finish;end
endmodule
