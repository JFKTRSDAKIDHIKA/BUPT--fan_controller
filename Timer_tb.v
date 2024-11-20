`timescale 1ns/1ps  // 定义仿真时间单位和精度

module Timer_tb;
    reg clk;             // 时钟信号
    reg rst_n;           // 复位信号
    wire timer_1s;       // 1秒定时信号
    wire timer_500ms;    // 500毫秒定时信号
    wire timer_250ms;    // 250毫秒定时信号

    // 实例化被测模块
    Timer uut (
        .clk(clk),
        .rst_n(rst_n),
        .timer_1s(timer_1s),
        .timer_500ms(timer_500ms),
        .timer_250ms(timer_250ms)
    );

    // 时钟信号生成，周期为10ns（100MHz）
    initial clk = 0;
    always #5 clk = ~clk;

    // 测试过程
    initial begin
        $dumpfile("Timer_tb.vcd");  // 波形文件
        $dumpvars(0, Timer_tb);     // 记录仿真数据

        // 初始化
        rst_n = 0;  // 复位
        #20;        // 保持20ns
        rst_n = 1;  // 释放复位

        // 运行仿真，检查信号变化
        #2000;      // 仿真2秒（2000个周期）
        $finish;    // 停止仿真
    end
endmodule
