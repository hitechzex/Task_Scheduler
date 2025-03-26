# Task_Scheduler
This project implements a simple reactive task scheduler in Verilog that processes tasks. It models a basic embedded or hardware-assisted task execution mechanism with FIFO buffering and execution delay for simulating real-time handling that is not immediate and takes time.

Modules
-------

1. task_queue.v
   - Implements a circular FIFO queue to store incoming tasks.
   - Supports `push` (enqueue) and `pop` (dequeue) operations.
   - Maintains status flags for `empty` and `full`.

2. task_executor.v
   - Simulates task execution with a delay of clock cycles.
   - Accepts a task on `start` signal and asserts `done` after delay.
   - Passes the task through to `task_out` when done.

3. task_scheduler.v
   - Top-level control logic that coordinates between the queue and the executor.
   - Uses a finite state machine (FSM) with three states: IDLE, FETCH, and EXEC.

4. tb_task_scheduler.v
   - Testbench that simulates inputs to the scheduler and verifies output correctness - uses a reference model of queue type.
   - 
Simulation Screenshot
---------------------

[Simulation Waveform](https://github.com/hitechzex/Task_Scheduler/blob/main/simulation_screenshot.png?raw=true)
