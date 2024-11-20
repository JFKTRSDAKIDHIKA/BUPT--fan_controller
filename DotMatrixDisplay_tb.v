`timescale 1ns/1ps

module DotMatrixDisplay_tb;
  reg clk;
  reg rst_n;
  reg [1:0] state;
  reg timer_1s;
  reg timer_500ms;
  reg timer_250ms;
  wire [63:0] dot_matrix;

  // 实例化被测模块 DotMatrixDisplay
  DotMatrixDisplay uut (
    .clk(clk),
    .rst_n(rst_n),
    .state(state),
    .timer_1s(timer_1s),
    .timer_500ms(timer_500ms),
    .timer_250ms(timer_250ms),
    .dot_matrix(dot_matrix)
  );

  // 时钟信号生成，假设 50MHz
  initial clk = 0;
  always #10 clk = ~clk;  // 50MHz 时钟周期为20ns

  // 定义定时信号生成任务
  task generate_timer_signals;
    input integer timer_1s_cycles;
    input integer timer_500ms_cycles;
    input integer timer_250ms_cycles;

    integer i;
    begin
      for (i = 0; i < timer_1s_cycles; i = i + 1) begin
        #1000000 timer_1s = 1;  // 1秒脉冲
        #20 timer_1s = 0;       // 保持脉冲高电平持续 20ns
      end

      for (i = 0; i < timer_500ms_cycles; i = i + 1) begin
        #500000 timer_500ms = 1; // 0.5秒脉冲
        #20 timer_500ms = 0;     // 保持脉冲高电平持续 20ns
      end

      for (i = 0; i < timer_250ms_cycles; i = i + 1) begin
        #250000 timer_250ms = 1; // 0.25秒脉冲
        #20 timer_250ms = 0;     // 保持脉冲高电平持续 20ns
      end
    end
  endtask

  // 测试过程
  initial begin
    $dumpfile("DotMatrixDisplay_tb.vcd");
    $dumpvars(0, DotMatrixDisplay_tb);

    // 初始化信号
    rst_n = 0;
    state = 2'b00;
    timer_1s = 0;
    timer_500ms = 0;
    timer_250ms = 0;
    #40;
    rst_n = 1;

    // 测试用例 1：空挡状态
    state = 2'b00;
    #1000000; // 等待 1秒
    $display("State: Idle, Dot Matrix: %h", dot_matrix);

    // 测试用例 2：低速状态
    state = 2'b01;
    generate_timer_signals(4, 0, 0); // 模拟 4 秒的低速运行
    $display("State: Low Speed, Dot Matrix: %h", dot_matrix);

    // 测试用例 3：中速状态
    state = 2'b10;
    generate_timer_signals(0, 4, 0); // 模拟 2 秒的中速运行
    $display("State: Mid Speed, Dot Matrix: %h", dot_matrix);

    // 测试用例 4：高速状态
    state = 2'b11;
    generate_timer_signals(0, 0, 8); // 模拟 2 秒的高速运行
    $display("State: High Speed, Dot Matrix: %h", dot_matrix);

    // 测试结束
    $finish;
  end
endmodule
