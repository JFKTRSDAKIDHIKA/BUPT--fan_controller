module Debounce(
    input clk,            // 时钟信号
    input reset,          // 异步复位信号
    input btn,            // 按钮输入
    output reg stable_flag, // 持续稳定信号
    output reg press      // 按下的单周期脉冲信号
);
    // 中间信号：稳定计数器
    reg [2:0] cnt_s;

    // 持续稳定计数器，用于判断消抖
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            cnt_s <= 3'b000;
        end
        else if (cnt_s == 3'b011) begin
            cnt_s <= 3'b000; // 计数饱和后归零
        end
        else if (btn == 1'b1) begin
            cnt_s <= cnt_s + 1'b1; // 按钮持续按下时计数
        end
        else begin
            cnt_s <= 3'b000; // 按钮未按下时计数归零
        end
    end

    // 稳定标志位：在btn稳定为1并经过3个时钟周期后，拉高
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stable_flag <= 1'b0;
        end
        else if (btn == 1'b1 && cnt_s == 3'd3) begin
            stable_flag <= 1'b1; // 稳定状态
        end
        else if (btn == 1'b0) begin
            stable_flag <= 1'b0; // 按钮松开时，重置稳定标志位
        end
    end

    // 按下的单周期脉冲信号
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            press <= 1'b0;
        end
        else if (stable_flag == 1'b1 && cnt_s == 3'd3) begin
            press <= 1'b1; // 输出一个时钟周期的脉冲
        end
        else begin
            press <= 1'b0; // 其余时间保持低电平
        end
    end
endmodule
