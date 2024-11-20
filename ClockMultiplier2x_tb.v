`timescale 1ns / 1ps

module ClockMultiplier2x_tb;

    reg clk_in;
    reg rst_n;
    wire clk_out;

    // 实例化模块
    ClockMultiplier2x uut (
        .clk_in(clk_in),
        .rst_n(rst_n),
        .clk_out(clk_out)
    );

    // 生成输入时钟信号（100Hz）
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in; // 周期为10ms（模拟100Hz时钟）
    end

    // 复位信号生成
    initial begin
        rst_n = 0; // 初始复位为低
        #12 rst_n = 1; // 在12ms后释放复位信号
    end

    // 仿真运行时间
    initial begin
        #200000000; // 仿真运行2000ms
        $finish; // 仿真结束
    end

    // 波形输出
    initial begin
        $dumpfile("ClockMultiplier2x_tb.vcd"); // VCD波形文件名
        $dumpvars(0, ClockMultiplier2x_tb);    // Dump所有变量
    end

endmodule
