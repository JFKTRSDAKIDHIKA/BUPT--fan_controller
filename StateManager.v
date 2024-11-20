// StateManager 模块说明：
// 该模块用于管理风扇的工作状态，根据按钮 `btn7_press` 的按下情况，循环切换风扇的状态。
// 输入信号：
//    clk           : 时钟信号，用于同步状态变化。
//    rst_n         : 低电平复位信号，复位时将风扇状态设置为空挡。
//    btn7_press    : 按钮按下信号，用于切换风扇状态。
//    battery_empty : 电池空电标志信号，当电量为 00 时为 1。
// 输出信号：
//    state         : 当前风扇的工作状态，2位信号：
//                    00 - 空挡
//                    01 - 低速
//                    10 - 中速
//                    11 - 高速

module StateManager(
    input clk,
    input rst_n,
    input btn7_press,
    input battery_empty,  // 输入信号：电池空电标志
    output reg [1:0] state // 当前风扇状态：00-空挡，01-低速，10-中速，11-高速
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= 2'b00; // 初始状态为空挡
        else if (battery_empty)
            state <= 2'b00; // 电池电量为 00 时强制进入空挡状态
        else if (btn7_press)
            state <= (state == 2'b11) ? 2'b00 : state + 1'b1; // 循环切换状态
    end
endmodule

