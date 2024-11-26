// WARNING: This module `fan_controller` is no longer in use and has been deprecated.
// Please avoid using or modifying this module in future development.

module fan_controller(
    input clk,             // 系统时钟
    input rst_n,           // 复位信号，低电平有效
    input btn7,            // 按键控制挡位切换
    input sw0,             // 拨码开关控制充电
    output reg [7:0] disp, // 数码管显示
    output reg [7:0] led,  // LED显示
    output reg [63:0] dot_matrix // 8×8点阵显示
);

    // 内部信号声明
    reg [1:0] state;       // 风扇状态：空挡、低速、中速、高速
    reg [7:0] battery;     // 电量，范围0-99
    reg [1:0] fan_speed;   // 风扇速度，0=空挡, 1=低速, 2=中速, 3=高速
    reg charging;          // 充电状态标志

    // 定时器模块实例化
    wire timer_1s, timer_500ms, timer_250ms;
    Timer timer_inst(
        .clk(clk),
        .rst_n(rst_n),
        .timer_1s(timer_1s),
        .timer_500ms(timer_500ms),
        .timer_250ms(timer_250ms)
    );

    // 按键处理模块实例化
    wire btn7_press;
    Debounce debounce_inst(
        .clk(clk),
        .rst_n(rst_n),
        .button(btn7),
        .button_out(btn7_press)
    );

    // 逻辑实现
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // 初始化状态
            state <= 2'b00;
            battery <= 8'd99;
            fan_speed <= 2'b00;
            charging <= 1'b0;
            disp <= 8'h00;
            led <= 8'h00;
            dot_matrix <= 64'b0;
        end else begin
            // 按键处理：切换挡位
            if (btn7_press) begin
                if (state == 2'b11)
                    state <= 2'b00; // 回到空挡
                else
                    state <= state + 1'b1; // 切换到下一个挡位
            end

            // 充电控制
            if (sw0) begin
                charging <= 1'b1;
                if (battery < 8'd99) begin
                    if (state == 2'b00 && timer_100ms) // 空挡充电
                        battery <= battery + 1;
                    else if (timer_200ms) // 转动状态充电
                        battery <= battery + 1;
                end else begin
                    charging <= 1'b0;
                end
            end else begin
                charging <= 1'b0;
            end

            // 电量管理
            if (!charging && state != 2'b00) begin
                if (timer_200ms && battery > 0)
                    battery <= battery - 1;
                if (battery == 0) begin
                    state <= 2'b00; // 电量耗尽回到空挡
                    disp <= 8'b00; // 显示"00"
                end
            end

            // 点阵显示更新
            case (state)
                2'b01: dot_matrix <= fan_speed_low(timer_1s);
                2'b10: dot_matrix <= fan_speed_mid(timer_500ms);
                2'b11: dot_matrix <= fan_speed_high(timer_250ms);
                default: dot_matrix <= 64'b0;
            endcase
        end
    end

endmodule

