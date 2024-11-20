// =============================================
// 模块名称: ClockDivider
// 功能描述: 实现时钟分频功能
//           输入时钟频率为 100 Hz，输出时钟频率为 50 Hz。
// 工作原理: 在每个输入时钟上升沿时，将输出时钟翻转。
//           通过翻转行为，输出时钟的频率变为输入时钟的一半。
// 输入端口: 
//   - clk_in: 输入时钟信号，频率为 100 Hz。
//   - rst_n: 异步复位信号，低电平有效。
// 输出端口:
//   - clk_out: 输出时钟信号，频率为 50 Hz。
// =============================================

module ClockDivider(
    input wire clk_in,       // 输入时钟：100 Hz
    input wire rst_n,        // 复位信号
    output reg clk_out       // 输出时钟：50Hz
);

    always @(posedge clk_in or negedge rst_n) begin
        if (!rst_n) begin
            clk_out <= 0;
        end else begin    
            clk_out <= ~clk_out;             
        end
    end
endmodule
