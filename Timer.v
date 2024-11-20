// Timer 模块说明：
// 该模块用于产生多个定时脉冲信号：1秒、500毫秒、250毫秒、200毫秒、100毫秒。
// 输入信号：
//    clk           : 时钟信号，100Hz 时钟信号，周期为 0.01秒。
//    rst_n         : 低电平复位信号，复位时所有计数器和脉冲信号清零。
// 输出信号：
//    timer_1s      : 1秒脉冲信号，高电平持续一个时钟周期。
//    timer_500ms   : 500毫秒脉冲信号，高电平持续一个时钟周期。
//    timer_250ms   : 250毫秒脉冲信号，高电平持续一个时钟周期。
//    timer_200ms   : 200毫秒脉冲信号，高电平持续一个时钟周期。
//    timer_100ms   : 100毫秒脉冲信号，高电平持续一个时钟周期。

module Timer(
    input clk,         // 100Hz 时钟信号 (周期为0.01秒)
    input rst_n,       // 低电平复位信号
    output reg timer_1s,    // 1秒脉冲信号
    output reg timer_500ms, // 500毫秒脉冲信号
    output reg timer_250ms, // 250毫秒脉冲信号
    output reg timer_200ms, // 200毫秒脉冲信号
    output reg timer_100ms  // 100毫秒脉冲信号
);
    // 使用合适的计数器位宽
    reg [6:0] counter_1s;    // 最大计数值为100，需要7位
    reg [5:0] counter_500ms; // 最大计数值为50，需要6位
    reg [4:0] counter_250ms; // 最大计数值为25，需要5位
    reg [4:0] counter_200ms; // 最大计数值为20，需要5位
    reg [3:0] counter_100ms; // 最大计数值为10，需要4位

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // 复位所有计数器和定时信号
            counter_1s <= 7'd0;
            counter_500ms <= 6'd0;
            counter_250ms <= 5'd0;
            counter_200ms <= 5'd0;
            counter_100ms <= 4'd0;
            timer_1s <= 1'b0;
            timer_500ms <= 1'b0;
            timer_250ms <= 1'b0;
            timer_200ms <= 1'b0;
            timer_100ms <= 1'b0;
        end else begin
            // 1秒计数器
            if (counter_1s < 100 - 1) begin
                counter_1s <= counter_1s + 1;
                timer_1s <= 1'b0; // 计数过程中保持低电平
            end else begin
                counter_1s <= 7'd0;
                timer_1s <= 1'b1; // 达到计数目标，产生一个时钟周期宽度的脉冲
            end

            // 500毫秒计数器
            if (counter_500ms < 50 - 1) begin
                counter_500ms <= counter_500ms + 1;
                timer_500ms <= 1'b0; // 计数过程中保持低电平
            end else begin
                counter_500ms <= 6'd0;
                timer_500ms <= 1'b1; // 达到计数目标，产生一个时钟周期宽度的脉冲
            end

            // 250毫秒计数器
            if (counter_250ms < 25 - 1) begin
                counter_250ms <= counter_250ms + 1;
                timer_250ms <= 1'b0;  // 计数过程中保持低电平
            end else begin
                counter_250ms <= 5'd0;
                timer_250ms <= 1'b1; // 达到计数目标，产生一个时钟周期宽度的脉冲
            end

            // 200毫秒计数器
            if (counter_200ms < 20 - 1) begin
                counter_200ms <= counter_200ms + 1;
                timer_200ms <= 1'b0;  // 计数过程中保持低电平
            end else begin
                counter_200ms <= 5'd0;
                timer_200ms <= 1'b1; // 达到计数目标，产生一个时钟周期宽度的脉冲
            end

            // 100毫秒计数器
            if (counter_100ms < 10 - 1) begin
                counter_100ms <= counter_100ms + 1;
                timer_100ms <= 1'b0;  // 计数过程中保持低电平
            end else begin
                counter_100ms <= 4'd0;
                timer_100ms <= 1'b1; // 达到计数目标，产生一个时钟周期宽度的脉冲
            end
        end
    end
endmodule


