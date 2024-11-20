// DotMatrixDisplay 模块说明：
// 该模块用于控制一个 64 位的点阵显示，根据不同的风扇状态（空挡、低速、中速、高速）显示不同的图案。
// 输入信号：
//    clk            : 时钟信号，用于同步所有操作。
//    rst_n          : 低电平复位信号，复位时清空显示内容。
//    state          : 风扇状态信号，2位：00 - 空挡，01 - 低速，10 - 中速，11 - 高速。
//    timer_1s       : 1秒定时信号，用于低速状态下切换图案。
//    timer_500ms    : 500毫秒定时信号，用于中速状态下切换图案。
//    timer_250ms    : 250毫秒定时信号，用于高速状态下切换图案。
// 输出信号：
//    dot_matrix_R     : 64位点阵显示Red数据，控制显示的图案。
//    dot_matrix_G     : 64位点阵显示Green数据，控制显示的图案。

module DotMatrixDisplay(
    input clk,
    input rst_n,
    input [1:0] state,       // 风扇状态：00 - 空挡，01 - 低速，10 - 中速，11 - 高速
    input timer_1s,
    input timer_500ms,
    input timer_250ms,
    output reg [63:0] dot_matrix_R, // 点阵显示Red数据
	 output reg [63:0] dot_matrix_G  // 点阵显示Green数据
);
    // 定义一个内部寄存器来存储当前的图案索引
    reg [1:0] pattern_index;

    // 在时钟上升沿或复位信号的下降沿触发
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dot_matrix_R <= 64'b0;    // 系统复位时，清空显示
				dot_matrix_G <= 64'b0;
            pattern_index <= 2'b00; // 系统复位时，图案索引初始化为0
        end
        else begin
            case (state)
                2'b00: begin
                    // 空挡状态，显示图案1，并保持静止
                    dot_matrix_R <= display_pattern_R(2'b00);
						  dot_matrix_G <= display_pattern_G(2'b00);
                end
                2'b01: begin
                    // 低速状态，1秒切换一次图案
                    if (timer_1s) begin
                        pattern_index <= pattern_index + 1;  // 低速切换图案
                    end
                    dot_matrix_R <= display_pattern_R(pattern_index);
						  dot_matrix_G <= display_pattern_G(pattern_index);
                end
                2'b10: begin
                    // 中速状态，0.5秒切换一次图案
                    if (timer_500ms) begin
                        pattern_index <= pattern_index + 1;  // 中速切换图案
                    end
                    dot_matrix_R <= display_pattern_R(pattern_index);
						  dot_matrix_G <= display_pattern_G(pattern_index);						  
                end
                2'b11: begin
                    // 高速状态，0.25秒切换一次图案
                    if (timer_250ms) begin
                        pattern_index <= pattern_index + 1;  // 高速切换图案
                    end
                    dot_matrix_R <= display_pattern_R(pattern_index);
						  dot_matrix_G <= display_pattern_G(pattern_index);
                end
                default: begin
                    dot_matrix_R <= display_pattern_R(2'b00); // 未知状态时清空显示
						  dot_matrix_G <= display_pattern_G(2'b00); 
                end
            endcase
        end
    end

    // 功能函数：根据图案索引返回对应的Red点阵图案
    function [63:0] display_pattern_R(input [1:0] index);
        case (index)
            2'b00: display_pattern_R = 64'h0103070810E0C080; // 图案1
            2'b01: display_pattern_R = 64'h0000004FF2000000; // 图案2
            2'b10: display_pattern_R = 64'hE060201008040607; // 图案3
            2'b11: display_pattern_R = 64'h1018101008081808; // 图案4
		  endcase
	 endfunction
	 
//  图案1 (Red)
//  0 0 0 0 0 0 0 1
//  0 0 0 0 0 0 1 1
//  0 0 0 0 0 1 1 1
//  0 0 0 0 1 0 0 0
//  0 0 0 1 0 0 0 0
//  1 1 1 0 0 0 0 0
//  1 1 0 0 0 0 0 0
//  1 0 0 0 0 0 0 0

//  图案2 (Red)
//  0 0 0 0 0 0 0 0
//  0 0 0 0 0 0 0 0
//  0 0 0 0 0 0 0 0
//  0 1 0 0 1 1 1 1
//  1 1 1 1 0 0 1 0
//  0 0 0 0 0 0 0 0
//  0 0 0 0 0 0 0 0
//  0 0 0 0 0 0 0 0

//  图案3 (Red)
//  1 1 1 0 0 0 0 0
//  0 1 1 0 0 0 0 0
//  0 0 1 0 0 0 0 0
//  0 0 0 1 0 0 0 0
//  0 0 0 0 1 0 0 0
//  0 0 0 0 0 1 0 0
//  0 0 0 0 0 1 1 0
//  0 0 0 0 0 1 1 1

//  图案4 (Red)
//  0 0 0 1 0 0 0 0
//  0 0 0 1 1 0 0 0
//  0 0 0 1 0 0 0 0
//  0 0 0 1 0 0 0 0
//  0 0 0 0 1 0 0 0
//  0 0 0 0 1 0 0 0
//  0 0 0 1 1 0 0 0
//  0 0 0 0 1 0 0 0



	 
    // 功能函数：根据图案索引返回对应的Green点阵图案
    function [63:0] display_pattern_G(input [1:0] index);
        case (index)
            2'b00: display_pattern_G = 64'hE060201008040607; // 图案1
            2'b01: display_pattern_G = 64'h1018101008081808; // 图案2
            2'b10: display_pattern_G = 64'h0103070810E0C080; // 图案3
            2'b11: display_pattern_G = 64'h0000004FF2000000; // 图案4
		  endcase
	 endfunction
	 
//  图案1 (Green)
//  1 1 1 0 0 0 0 0
//  0 1 1 0 0 0 0 0
//  0 0 1 0 0 0 0 0
//  0 0 0 1 0 0 0 0
//  0 0 0 0 1 0 0 0
//  0 0 0 0 0 1 0 0
//  0 0 0 0 0 0 1 1
//  0 0 0 0 0 1 1 1

//  图案2 (Green)
//  0 0 0 1 0 0 0 0
//  0 0 0 1 1 0 0 0
//  0 0 0 1 0 0 0 0
//  0 0 0 1 0 0 0 0
//  0 0 0 0 1 0 0 0
//  0 0 0 0 1 0 0 0
//  0 0 0 1 1 0 0 0
//  0 0 0 0 1 0 0 0

//  图案3 (Green)
//  0 0 0 0 0 0 0 1
//  0 0 0 0 0 0 1 1
//  0 0 0 0 0 1 1 1
//  0 0 0 0 1 0 0 0
//  0 0 0 1 0 0 0 0
//  1 1 1 0 0 0 0 0
//  1 1 0 0 0 0 0 0
//  1 0 0 0 0 0 0 0


//  图案4 (Green)
//  0 0 0 0 0 0 0 0
//  0 0 0 0 0 0 0 0
//  0 0 0 0 0 0 0 0
//  0 1 0 0 1 1 1 1
//  1 1 1 1 0 0 1 0
//  0 0 0 0 0 0 0 0
//  0 0 0 0 0 0 0 0
//  0 0 0 0 0 0 0 0



	 
endmodule
