// Copyright (c) 2024 Jia Shu Ao, School of Information and Communication Engineering, BUPT
// Permission is hereby granted, free of charge, 
// to any person obtaining a copy of this software 
// and associated documentation files 

module FanController(
    input clk,                // 100Hz 时钟信号
    // input rst_n,           // 复位信号（低电平有效）
    input btn7,               // BTN7 按钮，用于切换挡位
    input sw0,                // SW0 拨码开关，用于控制充电状态
    output wire [6:0] segment,
	 output wire [7:0] anode_ctrl,
    output led,               // 风扇工作状态及电量指示灯
	 output [7:0] ROW,         // 红绿双色点阵,行信号（发光二极管公共端）
	 output [7:0] R_COL,       // 红绿双色点阵,红色发光二极管列信号
	 output [7:0] G_COL        // 红绿双色点阵,绿色发光二极管列信号 
);

    // Intermediate Signals Declaration
	 
    wire timer_1s, timer_500ms, timer_250ms, timer_200ms, timer_100ms;
    wire btn7_press;               // 去抖动后的按钮按下信号
    wire [1:0] fan_state;          // 风扇状态：00-空挡，01-低速，10-中速，11-高速
    wire [7:0] battery_level;      // 电池电量
    wire battery_empty;            // 电量耗尽标志
    wire charging = sw0;           // 充电状态由 SW0 控制
	 wire [7:0] disp7;             // 数码管显示风扇挡位
    wire [7:0] disp1;             // 数码管显示电池电量（十位）
    wire [7:0] disp0;            // 数码管显示电池电量（个位）
	 wire [63:0] dot_matrix_R;
	 wire [63:0] dot_matrix_G;
	 wire rst_n = 1'b1;
	 
	 // Module Instantiation

    // Timer 模块实例化
    Timer timer_inst(
        .clk(clk),
        .rst_n(rst_n),
        .timer_1s(timer_1s),
        .timer_500ms(timer_500ms),
        .timer_250ms(timer_250ms),
        .timer_200ms(timer_200ms),
        .timer_100ms(timer_100ms)
    );

    // 按钮去抖动模块实例化
    Debounce debounce_inst(
        .clk(clk),
        .reset(~rst_n),           // 将低电平复位信号映射为模块的高电平有效
        .btn(btn7),               // 按钮输入信号
        .stable_flag(),           // 如果暂时不需要 `stable_flag`，可以留空
        .press(btn7_press)        // 映射到需要的单周期脉冲信号
    );


    // 风扇状态管理模块实例化
    StateManager state_manager_inst(
        .clk(clk),
        .rst_n(rst_n),
        .btn7_press(btn7_press),
		  .battery_empty(battery_empty),
        .state(fan_state)
    );

    // 电池管理模块实例化
    BatteryManager battery_manager_inst(
        .clk(clk),
        .rst_n(rst_n),
        .sw0(sw0),
        .state(fan_state),
        .timer_100ms(timer_100ms),
        .timer_200ms(timer_200ms),
        .battery(battery_level),
        .battery_empty(battery_empty)
    );

    // LED 控制模块实例化
    LEDControl led_control_inst(
        .clk(clk),
        .rst_n(rst_n),
		  .fan_state(fan_state),
        .battery(battery_level),
        .charging(charging),
        .led(led)
    );

    // 点阵显示模块实例化
    DotMatrixDisplay dot_matrix_inst(
        .clk(clk),
        .rst_n(rst_n),
        .state(fan_state),
        .timer_1s(timer_1s),
        .timer_500ms(timer_500ms),
        .timer_250ms(timer_250ms),
        .dot_matrix_R(dot_matrix_R),
		  .dot_matrix_G(dot_matrix_G)
    );
	 
	 // 点阵分时复用模块实例化
	 DynamicDotMatrix dynamic_dot_matrix(
	      .clk_in(clk),
			.rst_n(rst_n),
			.dot_matrix_R(dot_matrix_R),
			.dot_matrix_G(dot_matrix_G),
			.ROW(ROW),
			.R_COL(R_COL),
			.G_COL(G_COL)	 
	 );

    // 数码管显示模块实例化
    SevenSegmentDisplay disp_inst(
        .clk(clk),
        .rst_n(rst_n),
        .fan_state(fan_state),
        .battery_level(battery_level),
        .battery_empty(battery_empty),
        .disp7(disp7),
        .disp1(disp1),
        .disp0(disp0)
    );
	 
	 // 动态扫描模块实例化
	 DynamicDisplay3 Dyna_inst(
	     .clk(clk),
        .rst_n(rst_n),
		  .disp0(disp0),
		  .disp1(disp1),
		  .disp7(disp7),
		  .segment(segment),
		  .anode_ctrl(anode_ctrl)
	 );
	 
endmodule
