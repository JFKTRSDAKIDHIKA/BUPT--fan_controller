`timescale 1ns/1ps  // 定义仿真时间单位和精度

module ClockDivider_tb;
    reg clk;             // 时钟信号
    reg rst_n;           // 复位信号
    wire clk_out;        // 输出时钟信号

    // 实例化被测模块
    ClockDivider uut (
        .clk_in(clk),
        .rst_n(rst_n),
        .clk_out(clk_out)
    );

    // 时钟信号生成，周期为10ns（100MHz）
    initial clk = 0;
    always #5 clk = ~clk;

    // 测试过程
    initial begin
        // 初始化
        rst_n = 0;  // 复位
        #20;        // 保持20ns
        rst_n = 1;  // 释放复位

        // 运行仿真，检查信号变化
        repeat (100) #2000;      // 仿真2秒（2000个周期）
        
        // 停止仿真
        $finish;    
    end
	 
    // 仿真结束时输出波形信息
    initial begin
        $dumpfile("ClockDivider_tb.vcd");  // 波形文件
        $dumpvars(0, ClockDivider_tb);     // 记录仿真数据
        $dumpvars(0, uut.clk_out);           // 记录输出时钟信号
    end

endmodule
