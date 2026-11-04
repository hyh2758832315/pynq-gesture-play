`timescale 1ns/1ps
// Replay captured left high16 PCM through unchanged production numeric/FSM RTL.
// Cadence is accelerated; ACK is immediate, so this does not test PS/game TTL.
module tb_human_replay;
    localparam integer NSAMPLES=1536000, NWINDOWS=NSAMPLES/977;
    reg clk=0;always #5 clk=~clk;
    reg rst_n=0,enable=0,configure=0,pcm_valid=0,input_fault=0,ack_valid=0;
    reg signed [15:0] pcm_s16=0;
    reg [31:0] config_epoch=1,soft_sum=15632,loud_sum=27356,quiet_sum=10747;
    reg [31:0] ack_epoch=0,ack_sequence=0;
    wire [2:0] state;wire [7:0] faults;
    wire ack_error,window_valid,event_pending;
    wire [63:0] sample_count,event_sample;
    wire [31:0] window_count,last_sum,event_sequence,event_epoch,event_window,event_age;
    wire [1:0] event_kind;
    reg [15:0] samples[0:NSAMPLES-1];reg [31:0] sums[0:NWINDOWS-1];
    integer checked=0,events=0,soft_events=0,loud_events=0,last_sequence=0;
    voice_volume_core dut (.*);
    always @(negedge clk) begin
        ack_valid=0;
        if(rst_n && enable && !configure) begin
            if(faults || ack_error) $fatal(1,"HUMAN_REPLAY_FAIL faults=%h ack=%b",faults,ack_error);
            if(window_valid) begin
                if(checked>=NWINDOWS || last_sum!==sums[checked]) $fatal(1,"HUMAN_REPLAY_FAIL sum window=%0d got=%0d expected=%0d",checked,last_sum,sums[checked]);
                checked=checked+1;
            end
            if(event_pending && event_sequence!=last_sequence) begin
                events=events+1;last_sequence=event_sequence;
                if(event_kind==1)soft_events=soft_events+1;
                if(event_kind==2)loud_events=loud_events+1;
                $display("HUMAN_EVENT sequence=%0d kind=%0d sample=%0d window=%0d",event_sequence,event_kind,event_sample,event_window);
                ack_epoch=event_epoch;ack_sequence=event_sequence;ack_valid=1;
            end
        end
    end
    initial begin
        $readmemh("human-left.mem",samples);$readmemh("human-sums.mem",sums);
        repeat(4)@(negedge clk);rst_n=1;enable=1;configure=1;
        @(negedge clk);configure=0;
        for(integer i=0;i<NSAMPLES;i=i+1) begin
            @(negedge clk);pcm_valid=1;pcm_s16=samples[i];
            @(negedge clk);pcm_valid=0;
            repeat(2)@(negedge clk);
        end
        repeat(5)@(negedge clk);
        if(checked!=NWINDOWS || sample_count!=NSAMPLES || loud_events<1) $fatal(1,"HUMAN_REPLAY_FAIL coverage windows=%0d samples=%0d loud=%0d",checked,sample_count,loud_events);
        $display("TEST_PASS human_replay samples=%0d windows=%0d events=%0d soft=%0d loud=%0d",sample_count,checked,events,soft_events,loud_events);$finish;
    end
    initial begin #100000000;$fatal(1,"HUMAN_REPLAY_WATCHDOG");end
endmodule
