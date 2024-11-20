module DynamicDisplay3 (
    input wire clk,                  // 系统时钟
    input wire rst_n,                // 复位信号（低电平有效）
    input wire [6:0] disp0,          // 最低位数码管的7段显示信号
    input wire [6:0] disp1,          // 中间位数码管的7段显示信号
    input wire [6:0] disp7,          // 最高位数码管的7段显示信号
    output reg [6:0] segment,        // 7段显示输出
    output reg [7:0] anode_ctrl      // 8位共阴极控制信号
);

    // 扫描计数器
    reg [1:0] scan_index;            // 2位计数器，支持3位扫描（0、1、2）
    reg [6:0] disp_data;             // 当前显示的数据

    // 扫描逻辑
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            scan_index <= 2'b00;
            anode_ctrl <= 8'b1111_1110;   // 初始点亮第一个数码管
        end else begin
            // 扫描计数器递增，循环扫描三个数码管
            scan_index <= (scan_index == 2'b10) ? 2'b00 : scan_index + 1'b1;

            // 控制当前数码管点亮
            case (scan_index)
                2'b00: anode_ctrl <= 8'b1111_1110;  // 点亮最低位数码管
                2'b01: anode_ctrl <= 8'b1111_1101;  // 点亮中间位数码管
                2'b10: anode_ctrl <= 8'b0111_1111;  // 点亮最高位数码管
                default: anode_ctrl <= 8'b1111_1111; // 默认关闭所有数码管
            endcase

            // 根据当前扫描的数码管选择显示内容
            case (scan_index)
                2'b00: disp_data <= disp1;  // 选择最低位的显示内容
                2'b01: disp_data <= disp7;  // 选择中间位的显示内容
                2'b10: disp_data <= disp0;  // 选择最高位的显示内容
                default: disp_data <= 7'b0000000;  // 其他情况显示为空
            endcase
        end
    end

    // 将选中的数据输出到7段显示
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            segment <= 7'b0000000;
        else
            segment <= disp_data;
    end

endmodule

