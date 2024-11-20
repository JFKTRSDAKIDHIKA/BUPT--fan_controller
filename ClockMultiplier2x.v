module ClockMultiplier2x(
    input wire clk_in,       // 输入时钟：100Hz
    input wire rst_n,        // 异步复位信号
    output reg clk_out       // 输出时钟：200Hz
);

    always @(posedge clk_in or negedge rst_n) begin
        if (!rst_n) begin
            clk_out <= 0; // 异步复位，初始化输出时钟
        end else begin
            clk_out <= ~clk_out; // 每次上升沿翻转一次
        end
    end

    always @(negedge clk_in or negedge rst_n) begin
        if (!rst_n) begin
            clk_out <= 0; // 异步复位，初始化输出时钟
        end else begin
            clk_out <= ~clk_out; // 每次下降沿翻转一次
        end
    end

endmodule
