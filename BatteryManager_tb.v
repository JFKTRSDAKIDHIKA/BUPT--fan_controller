`timescale 1ns/1ps

module BatteryManager_tb;
    // 信号声明
    reg clk;
    reg rst_n;
    reg sw0;
    reg [1:0] state;
    reg timer_100ms;
    reg timer_200ms;
    wire [7:0] battery;
    wire battery_empty;

    // 实例化被测模块
    BatteryManager uut (
        .clk(clk),
        .rst_n(rst_n),
        .sw0(sw0),
        .state(state),
        .timer_100ms(timer_100ms),
        .timer_200ms(timer_200ms),
        .battery(battery),
        .battery_empty(battery_empty)
    );

    // 时钟信号生成，假设 10ns 的时钟周期 (即 100MHz)
    initial clk = 0;
    always #5 clk = ~clk;

    // 定时信号生成，用于模拟 100ms 和 200ms 脉冲信号
    initial begin
        timer_100ms = 0;
        timer_200ms = 0;
        forever begin
            // 生成 100ms 脉冲信号
            #999980;  // 等待接近 100ms 的时间 (100ms - 20ns)
            timer_100ms = 1;
            #10;      // 保持脉冲高电平持续 10ns
            timer_100ms = 0;

            // 生成 200ms 脉冲信号
            #999980;  // 再次等待接近 100ms 的时间
            timer_200ms = 1;
            #10;      // 保持脉冲高电平持续 10ns
            timer_200ms = 0;
        end
    end

    // 测试过程
    initial begin
        // 生成仿真波形文件
        $dumpfile("BatteryManager_tb.vcd");
        $dumpvars(0, BatteryManager_tb);

        // 初始化
        rst_n = 0;
        sw0 = 0;
        state = 2'b00;
        #20;
        rst_n = 1;

        // 测试用例 0：放电，开始从满电状态放电到50%电量
        sw0 = 0; // 不充电
        state = 2'b01; // 风扇转动状态
        #100000000;  // 200ms * 50 = 10s，电池应该减少到约50%的电量
        $display("Time 10s, Battery Level: %d", battery);

        // 测试用例 1：放电至完全耗尽
        while (battery > 0) begin
            #2000000;  // 200ms
        end
        $display("Battery Empty, battery_empty: %b", battery_empty);

        // 测试用例 2：从电量耗尽状态开始充电，空挡状态
        sw0 = 1;  // 开始充电
        state = 2'b00;  // 空挡状态
        #10000000;  // 100ms * 10 = 1s，电池应该增加10
        $display("Time 1s, Battery Level After Charge: %d", battery);

        // 测试用例 3：在风扇转动状态下充电
        state = 2'b01;  // 风扇转动状态
        #20000000;  // 200ms * 10 = 2s，电池增加10
        $display("Time 3s, Battery Level During Charge: %d", battery);

        // 测试用例 4：充电至满电
        while (battery < 8'd99) begin
            #1000000;  // 100ms
        end
        $display("Battery Fully Charged, Battery Level: %d", battery);

        // 测试用例 5：继续充电，检测是否超过99
        #1000000;  // 继续充电 100ms
        $display("Battery Level After Additional Charge: %d", battery);

        // 测试用例 6：从部分充电状态再度放电至空
        sw0 = 0;  // 停止充电，开始放电
        state = 2'b10;  // 更高的放电状态
        while (battery > 0) begin
            #2000000;  // 200ms
        end
        $display("Battery Depleted Again, battery_empty: %b", battery_empty);
		  
		  #1000000

        // 结束仿真
        $finish;
    end
endmodule
