`timescale 1ns/1ps

// Encoded-pointer mask-method round-robin selector.  This is a structural
// alternative to the grouped tail/group search used by P9-GRR.  It is kept as
// a selector-level experiment until synthesis proves that the 4-to-16 mask
// generation is cheaper.
module aer_gray_rank_mask_selector16(
    input logic [15:0] rank_candidate,
    input logic [3:0] last_rank,
    output logic grant_valid,
    output logic [3:0] grant_rank
);
    logic [15:0] higher_mask,higher_request,priority_request;
    logic [3:0] group_valid,selected_group_request;
    logic [2:0] group_pick,lane_pick;

    function automatic [2:0] fp4(input logic[3:0]request);
        logic[1:0]index;
        begin
            if(request[0])index=0;else if(request[1])index=1;
            else if(request[2])index=2;else index=3;
            fp4={|request,index};
        end
    endfunction

    always_comb begin
        case(last_rank)
            4'd0:higher_mask=16'hfffe;4'd1:higher_mask=16'hfffc;
            4'd2:higher_mask=16'hfff8;4'd3:higher_mask=16'hfff0;
            4'd4:higher_mask=16'hffe0;4'd5:higher_mask=16'hffc0;
            4'd6:higher_mask=16'hff80;4'd7:higher_mask=16'hff00;
            4'd8:higher_mask=16'hfe00;4'd9:higher_mask=16'hfc00;
            4'd10:higher_mask=16'hf800;4'd11:higher_mask=16'hf000;
            4'd12:higher_mask=16'he000;4'd13:higher_mask=16'hc000;
            4'd14:higher_mask=16'h8000;default:higher_mask=16'h0000;
        endcase
        higher_request=rank_candidate&higher_mask;
        priority_request=(|higher_request)?higher_request:rank_candidate;
        group_valid[0]=|priority_request[3:0];
        group_valid[1]=|priority_request[7:4];
        group_valid[2]=|priority_request[11:8];
        group_valid[3]=|priority_request[15:12];
        group_pick=fp4(group_valid);
        case(group_pick[1:0])
            0:selected_group_request=priority_request[3:0];
            1:selected_group_request=priority_request[7:4];
            2:selected_group_request=priority_request[11:8];
            default:selected_group_request=priority_request[15:12];
        endcase
        lane_pick=fp4(selected_group_request);
        grant_valid=|rank_candidate;
        grant_rank={group_pick[1:0],lane_pick[1:0]};
    end
endmodule
