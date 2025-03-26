`timescale 1ps/1ps
module tb_task_scheduler;

    reg clk = 0;
    reg rst = 1;
    reg [7:0] new_task;
    reg task_valid;
    wire [7:0] completed_task;
    wire task_done;
    wire full;
	reg [7:0] ref_push [0:7]; // Expected sequence
    reg [7:0] ref_pop [0:7];
    integer push_index = 0, pop_index = 0, i;

    // Instantiate DUT
    task_scheduler dut (
        .clk(clk),
        .rst(rst),
        .new_task(new_task),
        .task_valid(task_valid),
        .completed_task(completed_task),
        .task_done(task_done),
        .full(full)
    );

	initial begin
	    $dumpfile("task_scheduler.vcd");
        $dumpvars(0, tb_task_scheduler);
	end

	always #5 clk = ~clk;

    initial begin
	    // Initialize expected tasks
		for (i = 0; i < 5; i = i + 1) 
			ref_push[i] = i + 1;  // 8'h01 to 8'h05

        clk = 0;
        rst = 1;
        new_task = 0;
        task_valid = 0;

        #10 rst = 0;
		
        // Feed tasks
        for (push_index = 0; push_index < 5; push_index = push_index + 1) begin
            @(posedge clk);
            new_task = ref_push[push_index];
            task_valid = 1;
            @(posedge clk);
            task_valid = 0;
        end
    end
	
    // Compare output task to expected reference
    always @(posedge clk) begin
        if (task_done) begin
            $display("TB sees task_done=1 at time %t", $time);
            $display("Completed: %02x, Expected: %02x", completed_task, ref_push[pop_index]);
            if (completed_task !== ref_push[pop_index]) begin
                $display("ERROR: Task mismatch!");
                $finish;
            end
            pop_index = pop_index + 1;
            if (pop_index == 4) begin
                $display("All tasks completed correctly!");
                $finish;
            end
        end
    end

endmodule
