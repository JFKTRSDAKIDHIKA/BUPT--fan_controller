module ClockMultiplier(
    input wire clk_in,       // 输入时钟：100 Hz
    input wire rst_n,        // 复位信号
    output reg clk_out       // 输出时钟：100 kHz
);

    reg [31:0] counter;       // 用于倍增计数的计数器，宽度调整为 32 位，能够容纳更大的计数值

    always @(posedge clk_in or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
            clk_out <= 0;
        end else begin
            counter <= counter + 1;
            if (counter < 5000)  // 每个输入时钟周期内生成 2 个输出时钟周期，输出频率为 100 kHz
                clk_out <= ~clk_out;
            else
                counter <= 0; // 计数器复位，重新开始计数
        end
    end

endmodule

