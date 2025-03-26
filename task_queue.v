module task_queue #(
    parameter DEPTH = 8,                 // Number of tasks the queue can hold
    parameter PTR_WIDTH = 3             // Log2(DEPTH); width of head/tail pointers
)(
    input  wire        clk,
    input  wire        rst,
    input  wire        push,            // Enqueue control
    input  wire        pop,             // Dequeue control
    input  wire [7:0]  task_in,         // Task to enqueue
    output wire [7:0]  task_out,        // Task to dequeue
    output wire        empty,           // Queue is empty
    output wire        full             // Queue is full
);

    reg [7:0] mem [0:DEPTH-1];          // FIFO memory array
    reg [PTR_WIDTH-1:0] head = 0;       // Points to current task to dequeue
    reg [PTR_WIDTH-1:0] tail = 0;       // Points to next write location
    reg [PTR_WIDTH:0] count = 0;        // Number of valid elements in queue

    assign empty = (count == 0);        // No items to dequeue
    assign full  = (count == DEPTH);    // No room to enqueue
    assign task_out = mem[head];        // Always output the current front

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            head  <= 0;
            tail  <= 0;
            count <= 0;
        end else begin
            if (push && !full) begin     // Enqueue task if space available
                mem[tail] <= task_in;
                tail <= tail + 1;
                count <= count + 1;
            end
            if (pop && !empty) begin     // Dequeue task if queue not empty
                head <= head + 1;
                count <= count - 1;
            end
        end
    end

endmodule
