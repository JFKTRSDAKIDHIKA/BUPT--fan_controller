// BatteryManager 模块说明：
// 该模块用于模拟电池管理，包括充电和放电的逻辑。
// 输入信号：
//    clk        : 时钟信号，用于驱动模块时序。
//    rst_n      : 复位信号，低有效，复位时电池电量为 99，电池空标志为 0。
//    sw0        : 充电开关，控制是否进行充电操作，1 表示充电，0 表示停止充电。
//    state      : 当前风扇状态，2 位宽。状态为 00 表示空挡，其他状态表示转动状态。
//    timer_100ms: 100ms 定时信号，用于判断是否进入充电操作（空挡状态下）。
//    timer_200ms: 200ms 定时信号，用于判断是否进入充电操作（转动状态下）。
// 输出信号：
//    battery    : 电池当前电量值，范围 0-99，表示电池电量的百分比。
//    battery_empty: 电池空标志，1 表示电池已空，0 表示电池未空。

module BatteryManager(
    input clk,
    input rst_n,
    input sw0,              // 充电开关
    input [1:0] state,      // 当前风扇状态
    input timer_100ms,      // 100ms定时信号
    input timer_200ms,      // 200ms定时信号
    output reg [7:0] battery,  // 当前电量值（0-99）
    output reg battery_empty   // 电量耗尽标志
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            battery <= 8'd99;
        end else if (sw0) begin
            // 充电逻辑
            if (battery < 8'd99) begin
                if (state == 2'b00 && timer_100ms) // 只有在空挡状态且timer_100ms有效时充电
                    battery <= battery + 1;
                else if (state != 2'b00 && timer_200ms) // 其他状态下，基于timer_200ms充电
                    battery <= battery + 1;
            end
        end else if (state != 2'b00 && timer_200ms) begin
            // 放电逻辑
            if (battery > 0)
                battery <= battery - 1;
        end
    end

    // 单独一个always块来检查battery_empty信号
    always @(battery) begin
        if (battery == 0)
            battery_empty <= 1'b1;
        else
            battery_empty <= 1'b0;
    end
endmodule

