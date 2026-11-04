`timescale 1ns/1ps
// Digital-source characterization only: no claim about headset acoustic coupling.
module tb_volume_response;
    reg clk = 0;
    always #5 clk = ~clk;
    reg rst_n=0, enable=0, configure=0, pcm_valid=0, input_fault=0, ack_valid=0;
    reg signed [15:0] pcm_s16=0;
    reg [31:0] config_epoch=1, soft_sum=15632, loud_sum=27356, quiet_sum=10747;
    reg [31:0] ack_epoch=0, ack_sequence=0;
    wire [2:0] state;
    wire [7:0] faults;
    wire ack_error, window_valid, event_pending;
    wire [63:0] sample_count, event_sample;
    wire [31:0] window_count, last_sum, event_sequence, event_epoch, event_window, event_age;
    wire [1:0] event_kind;
    integer checks=0, events=0, previous_sequence=0;
    real phase=0.0;
    voice_volume_core dut (.*);

    task automatic sample(input integer value);
        @(negedge clk); pcm_valid=1; pcm_s16=value;
        @(negedge clk); pcm_valid=0;
        repeat (2) @(negedge clk);
        if (faults || ack_error) $fatal(1,"RESPONSE_FAIL faults=%h ack=%b",faults,ack_error);
        if (event_pending && event_sequence != previous_sequence) begin
            events=events+1; previous_sequence=event_sequence;
        end
    endtask
    task automatic tone(input integer windows, input integer amplitude, input real hz);
        for(integer i=0;i<windows*977;i=i+1) begin
            // Accelerated sample cadence; frequency labels use actual 100 MHz/2048 Fs.
            sample($rtoi(amplitude*$sin(phase)));
            phase=phase+6.283185307179586*hz/48828.125;
        end
    endtask
    task automatic square(input integer windows, input integer amplitude);
        for(integer i=0;i<windows*977;i=i+1) sample(i[0] ? amplitude : -amplitude);
    endtask
    task automatic ack;
        ack_epoch=event_epoch; ack_sequence=event_sequence; ack_valid=1;
        @(negedge clk); ack_valid=0;
        @(negedge clk);
        if(event_pending || ack_error) $fatal(1,"RESPONSE_FAIL ack");
    endtask
    task automatic fresh;
        @(negedge clk); enable=1; configure=1; config_epoch=config_epoch+1;
        @(negedge clk); configure=0;
        events=0; previous_sequence=0; phase=0.0;
        square(6,0);
        if(state!=1) $fatal(1,"RESPONSE_FAIL arm");
    endtask
    initial begin
        repeat(4) @(negedge clk); rst_n=1;
        fresh(); tone(5,12,640.0);
        if(events!=0 || last_sum>=soft_sum) $fatal(1,"RESPONSE_FAIL weak tone");
        $display("CASE weak_640Hz mean=%f events=%0d",real'(last_sum)/977,events); checks++;
        fresh(); tone(5,32,640.0);
        if(events!=1 || event_kind!=1) $fatal(1,"RESPONSE_FAIL soft");
        $display("CASE soft_640Hz mean=%f events=%0d kind=%0d",real'(last_sum)/977,events,event_kind); checks++;
        for(integer f=0;f<3;f=f+1) begin
            fresh(); tone(5,96,f==0 ? 100.0 : f==1 ? 640.0 : 3000.0);
            if(events!=1 || event_kind!=2 || last_sum<loud_sum) $fatal(1,"RESPONSE_FAIL loud frequency %0d",f);
            $display("CASE loud_frequency_index=%0d mean=%f events=%0d kind=%0d",f,real'(last_sum)/977,events,event_kind); checks++;
        end
        fresh(); square(1,60); square(3,0);
        if(events!=0 || state!=3) $fatal(1,"RESPONSE_FAIL short crossing characterization");
        $display("CASE single_20ms_loud_window events=%0d state=%0d",events,state); checks++;
        fresh(); square(3,60);
        if(events!=1 || event_kind!=2) $fatal(1,"RESPONSE_FAIL first event");
        ack(); square(10,13);
        if(state!=3 || last_sum<=quiet_sum || last_sum>=soft_sum) $fatal(1,"RESPONSE_FAIL noisy recovery");
        square(3,60);
        if(events!=1 || state!=3) $fatal(1,"RESPONSE_FAIL unexpected rearm");
        $display("CASE floor_above_quiet repeated_loud events=%0d state=%0d",events,state); checks++;
        square(7,0);
        if(state!=1) $fatal(1,"RESPONSE_FAIL quiet rearm");
        square(3,60);
        if(events!=2 || event_kind!=2) $fatal(1,"RESPONSE_FAIL event after rearm");
        $display("CASE quiet_restored repeated_loud events=%0d state=%0d",events,state); checks++;
        $display("TEST_PASS volume_response checks=%0d",checks); $finish;
    end
    initial begin #20000000; $fatal(1,"RESPONSE_WATCHDOG"); end
endmodule
