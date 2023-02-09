module top (
    input  wire       rst_n,
    input  wire       clk,
    output wire       led_pin,
    output wire       hdmi_clk_p,
    output wire       hdmi_clk_n,
    output wire [2:0] hdmi_data_p,
    output wire [2:0] hdmi_data_n
);

// f_CLKOUT = f_CLKIN * FBDIV / IDIV, 3.125~600MHz
// f_VCO = f_CLKOUT * ODIV, 400~1200MHz
// f_PFD = f_CLKIN / IDIV = f_CLKOUT / FBDIV, 3~400MHz

localparam PLL_IDIV  =  2 - 1; // 0~63
localparam PLL_FBDIV = 57 - 1; // 0~63
localparam PLL_ODIV  =      2; // 2, 4, 8, 16, 32, 48, 64, 80, 96, 112, 128

// 720p
//localparam DVI_H_BPORCH = 12'd220;
//localparam DVI_H_ACTIVE = 12'd1280;
//localparam DVI_H_FPORCH = 12'd110;
//localparam DVI_H_SYNC   = 12'd40;
//localparam DVI_H_POLAR  = 1'b1;
//localparam DVI_V_BPORCH = 12'd20;
//localparam DVI_V_ACTIVE = 12'd720;
//localparam DVI_V_FPORCH = 12'd5;
//localparam DVI_V_SYNC   = 12'd5;
//localparam DVI_V_POLAR  = 1'b1;

// 1080p
localparam DVI_H_BPORCH = 12'd148;
localparam DVI_H_ACTIVE = 12'd1920;
localparam DVI_H_FPORCH = 12'd88;
localparam DVI_H_SYNC   = 12'd44;
localparam DVI_H_POLAR  = 1'b1;
localparam DVI_V_BPORCH = 12'd36;
localparam DVI_V_ACTIVE = 12'd1080;
localparam DVI_V_FPORCH = 12'd4;
localparam DVI_V_SYNC   = 12'd5;
localparam DVI_V_POLAR  = 1'b1;

// 1440p
/*
localparam DVI_H_BPORCH = 12'd40;
localparam DVI_H_ACTIVE = 12'd2560;
localparam DVI_H_FPORCH = 12'd8;
localparam DVI_H_SYNC   = 12'd32;
localparam DVI_H_POLAR  = 1'b1;
localparam DVI_V_BPORCH = 12'd6;
localparam DVI_V_ACTIVE = 12'd1440;
localparam DVI_V_FPORCH = 12'd13;
localparam DVI_V_SYNC   = 12'd8;
localparam DVI_V_POLAR  = 1'b0;
*/
//localparam DVI_H_BPORCH = 12'd80;
//localparam DVI_H_ACTIVE = 12'd2560;
//localparam DVI_H_FPORCH = 12'd48;
//localparam DVI_H_SYNC   = 12'd32;
//localparam DVI_H_POLAR  = 1'b1;
//localparam DVI_V_BPORCH = 12'd33;
//localparam DVI_V_ACTIVE = 12'd1440;
//localparam DVI_V_FPORCH = 12'd3;
//localparam DVI_V_SYNC   = 12'd5;
//localparam DVI_V_POLAR  = 1'b0;

wire rst;
wire clk_serial;
wire clk_pixel;
wire pll_locked;

reg       rgb_vs;
reg       rgb_hs;
reg       rgb_de;
reg [7:0] rgb_r;
reg [7:0] rgb_g;
reg [7:0] rgb_b;

assign rst = ~rst_n;

led Toggle_Pin(
    .sys_clk(clk),
    .sys_rst_n(rst_n),
    .led(led_pin)
);

PLLVR #(
    .FCLKIN    (27),
    .IDIV_SEL  (PLL_IDIV),
    .FBDIV_SEL (PLL_FBDIV),
    .ODIV_SEL  (PLL_ODIV),
    .DEVICE    ("GW1NSR-4C")
) pll (
    .CLKIN    (clk),
    .CLKFB    (1'b0),
    .RESET    (rst),
    .RESET_P  (1'b0),
    .FBDSEL   (6'b0),
    .IDSEL    (6'b0),
    .ODSEL    (6'b0),
    .DUTYDA   (4'b0),
    .PSDA     (4'b0),
    .FDLY     (4'b0),
    .VREN     (1'b1),
    .CLKOUT   (clk_serial),
    .LOCK     (pll_locked),
    .CLKOUTP  (),
    .CLKOUTD  (),
    .CLKOUTD3 ()
);

CLKDIV #(
    .DIV_MODE (5)
) clk_pixel_gen (
    .HCLKIN (clk_serial),
    .RESETN (rst_n),
    .CALIB  (1'b0),
    .CLKOUT (clk_pixel)
);

DVI_TX_Top dvi_tx (
    .I_rst_n       (rst_n),       // input I_rst_n
    .I_serial_clk  (clk_serial),  // input I_serial_clk
    .I_rgb_clk     (clk_pixel),   // input I_rgb_clk
    .I_rgb_vs      (rgb_vs),      // input I_rgb_vs
    .I_rgb_hs      (rgb_hs),      // input I_rgb_hs
    .I_rgb_de      (rgb_de),      // input I_rgb_de
    .I_rgb_r       (rgb_r),       // input [7:0] I_rgb_r
    .I_rgb_g       (rgb_g),       // input [7:0] I_rgb_g
    .I_rgb_b       (rgb_b),       // input [7:0] I_rgb_b
    .O_tmds_clk_p  (hdmi_clk_p),  // output O_tmds_clk_p
    .O_tmds_clk_n  (hdmi_clk_n),  // output O_tmds_clk_n
    .O_tmds_data_p (hdmi_data_p), // output [2:0] O_tmds_data_p
    .O_tmds_data_n (hdmi_data_n)  // output [2:0] O_tmds_data_n
);

// Video Timing Generator

reg [11:0] cnt_h;
reg [11:0] cnt_h_next;
reg [11:0] cnt_v;
reg [11:0] cnt_v_next;

always @(negedge rst_n or posedge clk_pixel)
    if (!rst_n) begin
        cnt_h <= 12'd0;
        cnt_v <= 12'd0;
    end else if (!pll_locked) begin
        cnt_h <= 12'd0;
        cnt_v <= 12'd0;
    end else begin
        cnt_h <= cnt_h_next;
        cnt_v <= cnt_v_next;
    end

always @(*) begin
    if (cnt_h == DVI_H_BPORCH + DVI_H_ACTIVE + DVI_H_FPORCH + DVI_H_SYNC - 1'd1) begin
        cnt_h_next = 12'd0;
        if (cnt_v == DVI_V_BPORCH + DVI_V_ACTIVE + DVI_V_FPORCH + DVI_V_SYNC - 1'd1) begin
            cnt_v_next = 12'd0;
        end else begin
            cnt_v_next = cnt_v + 1'd1;
        end
    end else begin
        cnt_h_next = cnt_h + 1'd1;
        cnt_v_next = cnt_v;
    end
end

always @(*) begin
    if (cnt_h < DVI_H_BPORCH + DVI_H_ACTIVE + DVI_H_FPORCH) begin
        rgb_hs = ~DVI_H_POLAR;
    end else begin
        rgb_hs = DVI_H_POLAR;
    end

    if (cnt_v < DVI_V_BPORCH + DVI_V_ACTIVE + DVI_V_FPORCH) begin
        rgb_vs = ~DVI_V_POLAR;
    end else begin
        rgb_vs = DVI_V_POLAR;
    end

    if (cnt_h < DVI_H_BPORCH || cnt_h >= DVI_H_BPORCH + DVI_H_ACTIVE) begin
        rgb_de = 1'b0;
    end else if (cnt_v < DVI_V_BPORCH || cnt_v >= DVI_V_BPORCH + DVI_V_ACTIVE) begin
        rgb_de = 1'b0;
    end else begin
        rgb_de = 1'b1;
    end
end

// Video Pattern Generator

localparam BLACK_COMPARE     = 4'h0;
localparam WHITE_COMPARE     = 4'h1;
localparam GREEN_COMPARE     = 4'h2;
localparam RED_COMPARE       = 4'h3;
localparam PINK_COMPARE      = 4'h4;
localparam ORANGE_COMPARE    = 4'h5;
localparam YELLOW_COMPARE    = 4'h6;
localparam BLUE_COMPARE      = 4'h7;
localparam BROWN_COMPARE     = 4'h8;
localparam PURPULE_COMPARE   = 4'h9;
localparam GRAY_COMPARE      = 4'hA;
localparam CYAN_COMPARE      = 4'hB;
localparam OLIVE_COMPARE     = 4'hC;
localparam CORAL_COMPARE     = 4'hD;
localparam LIME_COMPARE      = 4'hE;
localparam MAROON_COMPARE    = 4'hF;

localparam BLACK_COLOR       = 24'h000000;
localparam WHITE_COLOR       = 24'hFFFFFF;
localparam GREEN_COLOR       = 24'h008000;
localparam RED_COLOR         = 24'hFF0000;
localparam PINK_COLOR        = 24'hFFC0CB;
localparam ORANGE_COLOR      = 24'hFFA500;
localparam YELLOW_COLOR      = 24'hFFFF00;
localparam BLUE_COLOR        = 24'h0000FF;
localparam BROWN_COLOR       = 24'hA52A2A;
localparam PURPULE_COLOR     = 24'h800080;
localparam GRAY_COLOR        = 24'h808080;
localparam CYAN_COLOR        = 24'h00FFFF;
localparam OLIVE_COLOR       = 24'h808000;
localparam CORAL_COLOR       = 24'hF08080;
localparam LIME_COLOR        = 24'h00FF00;
localparam MAROON_COLOR      = 24'h800000;

reg [3:0]  color;
reg [23:0] rgb_next;

// GRID
wire       vga_read;

VGA_GRID #(
    .Radius1 (150),
    .Radius2 (350),
    .Radius3 (430),
    .Radius4 (800),
    .Wight (DVI_H_ACTIVE),
    .Height (DVI_V_ACTIVE),
    .Line_Width (1),
    .Bit_Wight (12)
) VGA_PRINT (
    .iVGA_X(cnt_h_next),
    .iVGA_Y(cnt_v_next),
    .Read_Grid(vga_read));

// ROM
localparam HEX_Width  = 30;
localparam HEX_Height = 30;

reg [9:0]   ADDR_ROM_reg;
wire [9:0]  ADDR_ROM;
wire [11:0] ROM_Q;
wire        Read_ROM;
wire [11:0] Centre_X;
wire [11:0] Centre_Y;

assign Read_ROM = (ROM_Q == 12'h000) ? 0 : 1;
assign ADDR_ROM = ADDR_ROM_reg;

always @(*) begin
	if (cnt_h_next <= (Centre_X + HEX_Width/2) && cnt_h_next >= (Centre_X - HEX_Width/2)  && cnt_v_next <= (Centre_Y + HEX_Height/2) && cnt_v_next >= (Centre_Y - HEX_Height/2)) begin
		ADDR_ROM_reg = (cnt_v_next - 1 + HEX_Height/2 - Centre_Y) * HEX_Width + (cnt_h_next - 1 + HEX_Width/2 - Centre_X);
	end
	else ADDR_ROM_reg = 10'hFFF;
end

Gowin_ROM ROM_T(
        .dout(ROM_Q), //output [11:0] dout
        .clk(clk_serial), //input clk
        .oce(), //input oce
        .ce(), //input ce
        .reset(rst_n), //input reset
        .wre(), //input wre
        .ad(ADDR_ROM) //input [9:0] ad
    );

CENTER_MOVEMENT SHIFT_Centre(
    .clk(clk_pixel), 
    .rst_n(rst_n), 
    .Centre_X(Centre_X), 
    .Centre_Y(Centre_Y)
    );
    defparam
        SHIFT_Centre.Radius = 220,
        SHIFT_Centre.Wight = DVI_H_ACTIVE,
        SHIFT_Centre.Height = DVI_V_ACTIVE,
        SHIFT_Centre.Line_Width = 1,
        SHIFT_Centre.Speed = 32'h1F_FFFF,
        SHIFT_Centre.Bit_Wight = 12;

always @(*) begin
    if (cnt_v_next == 12'd0 || cnt_h_next == 12'd0) color = BLACK_COMPARE;
    else if (vga_read) color = BLACK_COMPARE;
    else if (cnt_v_next <= DVI_V_ACTIVE/2 && cnt_h_next <= DVI_H_ACTIVE/8) begin
        if ( Read_ROM ) color = WHITE_COMPARE;
        else color = BLACK_COMPARE;
    end
    else if (cnt_v_next >= DVI_V_ACTIVE/2 + 1 && cnt_h_next <= DVI_H_ACTIVE/8) begin
        if ( Read_ROM ) color = BLACK_COMPARE;
        else color = WHITE_COMPARE;
    end
    else if (cnt_v_next <= DVI_V_ACTIVE/2 && cnt_h_next <= 2*DVI_H_ACTIVE/8) begin
        if ( Read_ROM ) color = RED_COMPARE;
        else color = GREEN_COMPARE;
    end
    else if (cnt_v_next >= DVI_V_ACTIVE/2 + 1 && cnt_h_next <= 2*DVI_H_ACTIVE/8) begin
        if ( Read_ROM ) color = GREEN_COMPARE;
        else color = RED_COMPARE;
    end
    else if (cnt_v_next <= DVI_V_ACTIVE/2 && cnt_h_next <= 3*DVI_H_ACTIVE/8) begin
        if ( Read_ROM ) color = ORANGE_COMPARE;
        else color = PINK_COMPARE;
    end
    else if (cnt_v_next >= DVI_V_ACTIVE/2 + 1 && cnt_h_next <= 3*DVI_H_ACTIVE/8) begin
        if ( Read_ROM ) color = PINK_COMPARE;
        else color = ORANGE_COMPARE;
    end
    else if (cnt_v_next <= DVI_V_ACTIVE/2 && cnt_h_next <= 4*DVI_H_ACTIVE/8) begin
        if ( Read_ROM ) color = BLUE_COMPARE;
        else color = YELLOW_COMPARE;
    end
    else if (cnt_v_next >= DVI_V_ACTIVE/2 + 1 && cnt_h_next <= 4*DVI_H_ACTIVE/8) begin
        if ( Read_ROM ) color = YELLOW_COMPARE;
        else color = BLUE_COMPARE;
    end
    else if (cnt_v_next <= DVI_V_ACTIVE/2 && cnt_h_next <= 5*DVI_H_ACTIVE/8) begin
        if ( Read_ROM ) color = PURPULE_COMPARE;
        else color = BROWN_COMPARE;
    end
    else if (cnt_v_next >= DVI_V_ACTIVE/2 + 1 && cnt_h_next <= 5*DVI_H_ACTIVE/8) begin
        if ( Read_ROM ) color = BROWN_COMPARE;
        else color = PURPULE_COMPARE;
    end
    else if (cnt_v_next <= DVI_V_ACTIVE/2 && cnt_h_next <= 6*DVI_H_ACTIVE/8) begin
        if ( Read_ROM ) color = CYAN_COMPARE;
        else color = GRAY_COMPARE;
    end
    else if (cnt_v_next >= DVI_V_ACTIVE/2 + 1 && cnt_h_next <= 6*DVI_H_ACTIVE/8) begin
        if ( Read_ROM ) color = GRAY_COMPARE;
        else color = CYAN_COMPARE;
    end
    else if (cnt_v_next <= DVI_V_ACTIVE/2 && cnt_h_next <= 7*DVI_H_ACTIVE/8) begin
        if ( Read_ROM ) color = LIME_COMPARE;
        else color = OLIVE_COMPARE;
    end
    else if (cnt_v_next >= DVI_V_ACTIVE/2 + 1 && cnt_h_next <= 7*DVI_H_ACTIVE/8) begin
        if ( Read_ROM ) color = OLIVE_COMPARE;
        else color = LIME_COMPARE;
    end
    else if (cnt_v_next <= DVI_V_ACTIVE/2 && cnt_h_next <= 8*DVI_H_ACTIVE/8) begin
        if ( Read_ROM ) color = CORAL_COMPARE;
        else color = MAROON_COMPARE;
    end
    else begin
        if ( Read_ROM ) color = MAROON_COMPARE;
        else color = CORAL_COMPARE;
    end
end

always @(*) begin
    case (color)
        BLACK_COMPARE:      rgb_next = BLACK_COLOR;
        WHITE_COMPARE:      rgb_next = WHITE_COLOR;
        GREEN_COMPARE:      rgb_next = GREEN_COLOR;
        RED_COMPARE:        rgb_next = RED_COLOR;
        PINK_COMPARE:       rgb_next = PINK_COLOR;
        ORANGE_COMPARE:     rgb_next = ORANGE_COLOR;
        YELLOW_COMPARE:     rgb_next = YELLOW_COLOR;
        BLUE_COMPARE:       rgb_next = BLUE_COLOR;
        BROWN_COMPARE:      rgb_next = BROWN_COLOR;
        PURPULE_COMPARE:    rgb_next = PURPULE_COLOR;
        GRAY_COMPARE:       rgb_next = GRAY_COLOR;
        CYAN_COMPARE:       rgb_next = CYAN_COLOR;
        OLIVE_COMPARE:      rgb_next = OLIVE_COLOR;
        CORAL_COMPARE:      rgb_next = CORAL_COLOR;
        LIME_COMPARE:       rgb_next = LIME_COLOR;
        MAROON_COMPARE:     rgb_next = MAROON_COLOR;

        default:  rgb_next = BLACK_COLOR;
    endcase
end

always @(negedge rst_n or posedge clk_pixel)
    if (!rst_n) begin
        {rgb_r, rgb_g, rgb_b} <= 24'h000000;
    end else begin
        {rgb_r, rgb_g, rgb_b} <= rgb_next;
    end

endmodule
