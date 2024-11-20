module DynamicDotMatrix (
    input clk_in,            // 输入时钟：100 Hz
    input rst_n,             // 复位信号
    input [63:0] dot_matrix_R, // 红色点阵数据
    input [63:0] dot_matrix_G, // 绿色点阵数据
    output reg [7:0] ROW,       // 行信号
    output reg [7:0] R_COL,     // 红色列信号
    output reg [7:0] G_COL      // 绿色列信号
);

    // Signals Declaration
    // 行计数器，用于选择当前显示的行
    reg [2:0] row_counter; // 3-bit 行计数器 (0-7)
	 //wire clk_fast;
    
	 /*
	 // Module Instantiation
	 ClockMultiplier2x u_multiplier2x(
	     .clk_in(clk_in),
		  .rst_n(rst_n),
		  .clk_out(clk_fast)
	 );
	 */
	 
	  
    // 每个时钟周期更新当前行
    always @(posedge clk_in or negedge rst_n) begin
        if (!rst_n) begin
            row_counter <= 3'b000;
        end else begin
            // 逐行切换，从 0 到 7，然后循环
            row_counter <= row_counter + 1;
        end
    end

	 
    // 根据行计数器设置 ROW 信号（只有一行是低电平）
    always @(*) begin
        case (row_counter)
            3'b000: ROW = 8'b1111_1110; // 激活第 0 行(Bottom Line)
            3'b001: ROW = 8'b1111_1101; // 激活第 1 行
            3'b010: ROW = 8'b1111_1011; // 激活第 2 行
            3'b011: ROW = 8'b1111_0111; // 激活第 3 行
            3'b100: ROW = 8'b1110_1111; // 激活第 4 行
            3'b101: ROW = 8'b1101_1111; // 激活第 5 行
            3'b110: ROW = 8'b1011_1111; // 激活第 6 行
            3'b111: ROW = 8'b0111_1111; // 激活第 7 行(Top Line)
            default: ROW = 8'b1111_1111; // 默认关闭所有行
        endcase
    end
	 
	 // 根据行计数器读取对应行的显示数据
	 always @(*) begin
        case (row_counter)
            3'b000: begin
                R_COL <= dot_matrix_R[7:0];
                G_COL <= dot_matrix_G[7:0];
            end
            3'b001: begin
                R_COL <= dot_matrix_R[15:8];
                G_COL <= dot_matrix_G[15:8];
            end
            3'b010: begin
                R_COL <= dot_matrix_R[23:16];
                G_COL <= dot_matrix_G[23:16];
            end
            3'b011: begin
                R_COL <= dot_matrix_R[31:24];
                G_COL <= dot_matrix_G[31:24];
            end
            3'b100: begin
                R_COL <= dot_matrix_R[39:32];
                G_COL <= dot_matrix_G[39:32];
            end
            3'b101: begin
                R_COL <= dot_matrix_R[47:40];
                G_COL <= dot_matrix_G[47:40];
            end
            3'b110: begin
                R_COL <= dot_matrix_R[55:48];
                G_COL <= dot_matrix_G[55:48];
            end
            3'b111: begin
                R_COL <= dot_matrix_R[63:56];
                G_COL <= dot_matrix_G[63:56];
            end
        endcase
    end

	 
endmodule
