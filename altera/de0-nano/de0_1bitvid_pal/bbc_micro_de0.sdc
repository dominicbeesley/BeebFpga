#**************************************************************
# Altera DE0-SoC SDC settings
# Users are recommended to modify this file to match users logic.
#**************************************************************

#**************************************************************
# Create Clock
#**************************************************************

# External clock input
create_clock -period "50 MHz" -name brd_clk_50 [get_ports brd_clk_50]

	
#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {clock_48} -source [get_ports {brd_clk_50}] -divide_by 25 -multiply_by 24 -duty_cycle 50.00 { e_pll_50_48_96|altpll_component|auto_generated|pll1|clk[0] }
create_generated_clock -name {clock_96} -source [get_ports {brd_clk_50}] -divide_by 25 -multiply_by 48 -duty_cycle 50.00 { e_pll_50_48_96|altpll_component|auto_generated|pll1|clk[1] }
create_generated_clock -name {clock_96p} -source [get_ports {brd_clk_50}] -divide_by 25 -multiply_by 48 -duty_cycle 50.00 -phase 117.0 { e_pll_50_48_96|altpll_component|auto_generated|pll1|clk[2] }
create_generated_clock -name {i2s_clk} -source { e_pll_50_48_96|altpll_component|auto_generated|pll1|clk[1] } -divide_by 125 -multiply_by 2 -duty_cycle 50.00  { i2s_clk }
create_generated_clock -name {dac_clk} -source { e_pll_50_48_96|altpll_component|auto_generated|pll1|clk[0] } -divide_by 1 -multiply_by 5 -duty_cycle 50.00  { e_pll2|altpll_component|auto_generated|pll1|clk[0] }
create_generated_clock -name {chroma_x4_clk} -source { e_pll_50_48_96|altpll_component|auto_generated|pll1|clk[0] } -divide_by 1920000 -multiply_by 709379 { dossy_chroma:e_chroma_gen|i_clk_chroma_x4 }

#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************
derive_clock_uncertainty


