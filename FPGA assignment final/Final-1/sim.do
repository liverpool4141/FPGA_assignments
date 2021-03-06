setenv LMC_TIMEUNIT -9
vlib  work
vcom -work work "quantize.vhd"
vcom -work work "parameters.vhd"
vcom -work work "compute.vhd"
vcom -work work "fir_n.vhd"
vcom -work work "fir_cmplx_n.vhd"
vcom -work work "fifo.vhd"
vcom -work work "demodulate_n.vhd"
vcom -work work "deemphasis_n.vhd"
vcom -work work "read_IQ.vhd"
vcom -work work "fm_radio_stereo.vhd"
vcom -work work "fm_radio_top.vhd"
vcom -work work "fm_radio_tb.vhd"


vsim work.fm_radio_tb -wlf fm_radio_sim.wlf
add wave -noupdate -group fm_radio_tb
add wave -noupdate -group fm_radio_tb -radix hexadecimal /fm_radio_tb/*

add wave -noupdate -group fm_radio_tb/fm_radio_top_inst
add wave -noupdate -group fm_radio_tb/fm_radio_top_inst -radix hexadecimal /fm_radio_tb/fm_radio_top_inst/*




#add wave -noupdate -group fm_radio_tb/input_fifo_inst
#add wave -noupdate -group fm_radio_tb/input_fifo_inst -radix hexadecimal /fm_radio_tb/input_fifo_inst/*
#add wave -noupdate -group fm_radio_tb/left_audio_fifo_inst
#add wave -noupdate -group fm_radio_tb/left_audio_fifo_inst -radix hexadecimal /fm_radio_tb/left_audio_fifo_inst/*
#add wave -noupdate -group fm_radio_tb/right_audio_fifo_inst
#add wave -noupdate -group fm_radio_tb/right_audio_fifo_inst -radix hexadecimal /fm_radio_tb/right_audio_fifo_inst/*
#
run -all