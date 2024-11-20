// =============================================================================
// 模块名称: LEDControl
// 描述: 根据电池电量和充电状态控制LED的显示模式。
// 输入:
//  - clk: 100Hz时钟信号。
//  - rst_n: 复位信号。
//  - battery: 8位电池电量值（0-255）。
//  - charging: 充电状态信号（1为充电，0为不充电）。
// 输出:
//  - led: 控制LED的输出信号（高电平为LED亮，低电平为LED灭）。
//
// 功能描述:
// 1. 如果充电中（charging = 1），LED显示呼吸灯效果。
// 2. 如果电池电量 ≤ 25，LED以2Hz频率闪烁。
// 3. 如果电池电量 > 25，LED常亮。
//
// =============================================================================

module LEDControl(
    input clk,              // 系统时钟（100 Hz）
    input rst_n,            // 复位信号
    input [7:0] battery,    // 当前电量值（0-255）
    input charging,         // 是否在充电
    input fan_state,        // 风扇状态（0表示风扇空挡）
    output reg led         // LED输出信号
);

    reg [24:0] cnt1;  // 呼吸灯计数器1
    reg [24:0] cnt2;  // 呼吸灯计数器2
    reg [31:0] blink_counter;   // 计数器，用于实现 2Hz 闪烁
    reg flag;                   // 呼吸灯变亮/变暗标志
    reg blink_2hz;              // 2Hz闪烁信号
	 wire clk_div;               // 分频后的时钟（10 kHz）

    // ** 2Hz 闪烁信号逻辑 **
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            blink_counter <= 0;
            blink_2hz <= 0;
        end else begin
            if (blink_counter == 49) begin // 计数到 50 时翻转信号
                blink_counter <= 0;
                blink_2hz <= ~blink_2hz;   // 翻转 2 Hz 信号
            end else begin
                blink_counter <= blink_counter + 1;
            end
        end
    end
	 
	 
	 // 实例化频率倍增器
	 ClockMultiplier u_multiplier(
        .clk_in(clk),
        .rst_n(rst_n),
        .clk_out(clk_div)
    );

    // ** 呼吸灯计数器1逻辑 **
    always @(posedge clk_div or negedge rst_n) begin
        if (!rst_n)
            cnt1 <= 0;
        else if (cnt1 >= 7  - 1) // 计数器1到达最大值时清零
            cnt1 <= 0;
        else
            cnt1 <= cnt1 + 1;
    end

    // ** 呼吸灯计数器2逻辑 **
    always @(posedge clk_div or negedge rst_n) begin
        if (!rst_n) begin
            cnt2 <= 0;
            flag <= 1'b0;
        end else if (cnt1 == 7  - 1) begin // 当计数器1满时，计数器2递增或递减
            if (!flag) begin
                if (cnt2 >= 7  - 1)       // 计数器2达到最大值
                    flag <= 1'b1;           // 切换到递减模式
                else
                    cnt2 <= cnt2 + 1;
            end else begin
                if (cnt2 == 0)              // 计数器2达到最小值
                    flag <= 1'b0;           // 切换到递增模式
                else
                    cnt2 <= cnt2 - 1;
            end
        end
    end

	 
    /// ** LED 状态控制逻辑 **
		always @(posedge clk or negedge rst_n) begin
			 if (!rst_n) begin
				  led <= 1'b0; // 复位时 LED 熄灭
			 end else if (fan_state == 1'b0) begin
				  led <= 1'b0; // 风扇空挡时 LED 熄灭
			 end else if (charging) begin
				  if (battery < 99) begin
						// 正在充电且电池未充满，显示呼吸灯效果（根据 cnt1 和 cnt2 的比较）
						led <= (cnt1 < cnt2) ? 1'b1 : 1'b0;
				  end else begin
						// 电池充满，LED 常亮
						led <= 1'b1;
				  end
			 end else if (battery == 99) begin
				  // 如果电池充满，LED 常亮（不管是否在充电）
				  led <= 1'b1;
			 end else if (battery <= 25) begin
				  // 电量低时，LED 以 2Hz 闪烁
				  led <= blink_2hz;
			 end else begin
				  // 电量正常，LED 常亮
				  led <= 1'b1;
			 end
		end

endmodule


