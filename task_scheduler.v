module task_scheduler (
    input  wire        clk,
    input  wire        rst,
    input  wire [7:0]  new_task,
    input  wire        task_valid,
    output wire [7:0]  completed_task,
    output wire        task_done,
    output wire        full
);
    reg [1:0] state, next_state;
    localparam IDLE = 2'b00, FETCH = 2'b01, EXEC = 2'b10; // FSM states
    reg [7:0] queued_task;
    reg start;
    wire done;
    wire [7:0] task_out;
    wire empty;

    // Added a 'ready' flag to delay start until after reset and first valid cycle
    reg ready;

    // Start signal for executor
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            ready <= 0;
        end else begin
            state <= next_state;
            ready <= 1; // Ready after one cycle
        end
    end
	
    // FSM next state logic
    always @(*) begin
        case (state)
            IDLE:  next_state = (ready && !empty) ? FETCH : IDLE;
            FETCH: next_state = EXEC;
            EXEC:  next_state = done ? IDLE : EXEC;
            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk) begin
        if (state == FETCH)
            queued_task <= task_out;
    end

    always @(posedge clk) begin
        start <= (state == FETCH);
    end

    assign completed_task = queued_task;
    assign task_done = (state == EXEC) && done;

    task_queue queue (
        .clk(clk),
        .rst(rst),
        .push(task_valid),
        .pop(state == FETCH),
        .task_in(new_task),
        .task_out(task_out),
        .empty(empty),
        .full(full)
    );

    task_executor exec (
        .clk(clk),
        .rst(rst),
        .start(start),
        .task_in(queued_task),
        .done(done)
    );
endmodule
