// =============================================
// 模块名称: ClockDivider
// 功能描述: 实现时钟分频功能
//           输入时钟频率为 1000 Hz，输出时钟频率为 200 Hz。
// 工作原理: 在每个输入时钟上升沿时，将输出时钟翻转。
//           通过翻转行为，输出时钟的频率变为输入时钟的一半。
// 输入端口: 
//   - clk_in: 输入时钟信号，频率为 1000 Hz。
//   - rst_n: 异步复位信号，低电平有效。
// 输出端口:
//   - clk_out: 输出时钟信号，频率为 200 Hz。
// =============================================

module ClockDivider(
    input wire clk_in,       // 输入时钟：1000Hz
    input wire rst_n,        // 复位信号，低电平有效
    output reg clk_out       // 输出时钟：200Hz
);

    // 计数器，用于分频
    reg [4:0] counter; // 最大计数值为 20，需要 5 位计数器

    always @(posedge clk_in or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 5'd0; // 复位计数器
            clk_out <= 1'b0; // 输出时钟复位为低电平
        end else begin
            if (counter < 3 - 1) begin
                counter <= counter + 1; // 计数器加 1
            end else begin
                counter <= 5'd0;        // 计数器清零
                clk_out <= ~clk_out;    // 翻转输出时钟
            end
        end
    end
endmodule
