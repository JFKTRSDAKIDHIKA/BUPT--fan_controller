module SevenSegmentDisplay(
    input clk,                   // 时钟信号
    input rst_n,                 // 复位信号
    input [1:0] fan_state,       // 风扇状态（例如 2 档风速）
    input [7:0] battery_level,   // 电池电量
    input battery_empty,         // 电池是否耗尽
    output reg [6:0] disp7,      // 数码管 7 段信号（最高位）
    output reg [6:0] disp1,      // 数码管 7 段信号（中间位）
    output reg [6:0] disp0       // 数码管 7 段信号（最低位）
);

    // 数码管编码表
    function [6:0] seg_encoding;
        input [3:0] value;
        begin
            case (value)
                4'd0: seg_encoding = 7'b1111110; // "0"
                4'd1: seg_encoding = 7'b0110000; // "1"
                4'd2: seg_encoding = 7'b1101101; // "2"
                4'd3: seg_encoding = 7'b1111001; // "3"
                4'd4: seg_encoding = 7'b0110011; // "4"
                4'd5: seg_encoding = 7'b1011011; // "5"
                4'd6: seg_encoding = 7'b1011111; // "6"
                4'd7: seg_encoding = 7'b1110000; // "7"
                4'd8: seg_encoding = 7'b1111111; // "8"
                4'd9: seg_encoding = 7'b1111011; // "9"
                default: seg_encoding = 7'b0000000; // 空
            endcase
        end
    endfunction

    // 状态寄存器
    reg [7:0] timer; // 计时器，用来控制 2 秒延时，假设时钟为 100 Hz
    reg display_timeout; // 用于标记是否2秒已过

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            disp7 <= 7'b0000000; // 复位为空显示
            disp1 <= 7'b0000000;
            disp0 <= 7'b0000000;
            timer <= 8'b0; // 计时器归零
            display_timeout <= 0; // 显示未超时
        end else if (battery_empty && battery_level == 8'd0) begin
            // 当电池电量为 "00" 且电池已耗尽时
            if (timer < 8'd200) begin // 计时器达到200次，表示2秒钟
                timer <= timer + 1; // 计时
                disp7 <= 7'b1111110;  // 显示 "0"
                disp1 <= 7'b1111110;  // 显示 "0"
                disp0 <= 7'b1111110;  // 显示 "0"
            end else begin
                // 2秒后熄灭显示
                disp7 <= 7'b0000000;
                disp1 <= 7'b0000000;
                disp0 <= 7'b0000000;
            end
        end else begin
            disp7 <= seg_encoding(fan_state); // 风扇状态
            disp1 <= seg_encoding(battery_level / 10); // 电量十位
            disp0 <= seg_encoding(battery_level % 10); // 电量个位
            timer <= 8'b0; // 计时器清零
        end
    end
endmodule

