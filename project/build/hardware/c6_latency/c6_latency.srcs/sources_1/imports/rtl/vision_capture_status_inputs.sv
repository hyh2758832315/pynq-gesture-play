module vision_capture_status_inputs (
    input wire [143:0] frame_context,
    input wire [1:0] source_fault_status,
    input wire capture_fault,
    output wire [31:0] capture_epoch,
    output wire [2:0] fault_causes
);
    assign capture_epoch = frame_context[143:112];
    assign fault_causes = {capture_fault, source_fault_status};
endmodule