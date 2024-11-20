module ClockMultiplier(
    input wire clk_in,       // 输入时钟：100 Hz
    input wire rst_n,        // 复位信号
    output reg clk_out       // 输出时钟：10 kHz
);

    reg [6:0] counter;       // 用于倍增计数的计数器，宽度根据需求调整（100 = 7位）

    always @(posedge clk_in or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
            clk_out <= 0;
        end else begin
            counter <= counter + 1;
            if (counter < 50) // 每个输入时钟周期内生成 100 个输出时钟周期
                clk_out <= ~clk_out;
            else
                counter <= 0; // 计数器复位
        end
    end

endmodule

