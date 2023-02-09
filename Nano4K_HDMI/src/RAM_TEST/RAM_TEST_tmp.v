//Copyright (C)2014-2022 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//GOWIN Version: GowinSynthesis V1.9.8.05
//Part Number: GW1NSR-LV4CQN48PC7/I6
//Device: GW1NSR-4C
//Created Time: Thu Feb 09 11:57:50 2023

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

	RAM_TEST your_instance_name(
		.clk(clk_i), //input clk
		.Reset(Reset_i), //input Reset
		.Din(Din_i), //input [9:0] Din
		.SSET(SSET_i), //input SSET
		.SCLR(SCLR_i), //input SCLR
		.Q(Q_o) //output [9:0] Q
	);

//--------Copy end-------------------
