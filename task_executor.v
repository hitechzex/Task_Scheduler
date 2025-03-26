module task_executor (
    input  wire        clk,
    input  wire        rst,
    input  wire        start, // Begin task execution
    input  wire [7:0]  task_in,
    output reg         done,
    output reg [7:0]   task_out
    //output reg         running
);
    reg [2:0] counter;   // Delay counter - simulating real-time handling that is not immediate and takes time 
	reg       running;   // Execution in progress

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            done     <= 0;
            task_out <= 0;
            counter  <= 0;
            running  <= 0;
        end else begin
            if (start && !running) begin
                $display("EXECUTOR started task: %0h at time %0t", task_in, $time);
                task_out <= task_in;
                counter  <= 3'd5;
                done     <= 0;
                running  <= 1;
            end else if (running) begin
                if (counter == 0) begin
                    done    <= 1;
                    running <= 0;
                    $display("EXECUTOR done with task: %0h at time %0t", task_out, $time);
                end else begin
                    counter <= counter - 1;
                end
            end else begin
                done <= 0;
            end
        end
    end
endmodule
