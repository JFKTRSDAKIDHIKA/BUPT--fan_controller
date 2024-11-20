`timescale 1ns / 1ps

module LEDControl_tb;

    // 输入信号
    reg clk;
    reg rst_n;
    reg [7:0] battery;
    reg charging;
    reg fan_state;

    // 输出信号
    wire led;
    wire [24:0] cnt1;  // 添加 cnt1 的信号
    wire [24:0] cnt2;  // 添加 cnt2 的信号

    // 时钟周期定义 (100Hz 时钟周期为10ms)
    localparam CLK_PERIOD = 10_000_000; // 10ms = 10,000,000ns

    // 实例化待测模块
    LEDControl uut (
        .clk(clk),
        .rst_n(rst_n),
        .battery(battery),
        .charging(charging),
        .fan_state(fan_state),
        .led(led),
        .cnt1(cnt1),  // 连接 cnt1 输出端口
        .cnt2(cnt2)   // 连接 cnt2 输出端口
    );

    // 时钟信号生成
    initial begin
        clk = 0;
        forever #(CLK_PERIOD / 2) clk = ~clk; // 每半个时钟周期翻转时钟
    end

    initial begin
    // 初始化输入信号
    clk = 0;
    rst_n = 0;
    battery = 8'd0;
    charging = 0;
    fan_state = 1;

    // 释放复位，系统进入正常工作状态
    #(CLK_PERIOD * 5);   // 保持复位状态 50ms
    rst_n = 1;           // 释放复位

    // 测试用例 1：充电状态，呼吸灯效果
    battery = 8'd50;
    charging = 1;
    fan_state = 1;

    // 延长仿真时间，分段处理
    repeat (1000000) #(CLK_PERIOD);  // 模拟足够长时间

    // 停止仿真
    $finish;
end


    // 仿真结束时输出波形信息
    initial begin
        $dumpfile("LEDControl_tb.vcd");
        $dumpvars(0, LEDControl_tb);
        $dumpvars(0, uut.cnt1);  // 记录 cnt1
        $dumpvars(0, uut.cnt2);  // 记录 cnt2
    end

endmodule

