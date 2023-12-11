dir = `pwd`
rtl_src = $(dir)/rtl
tb_src = $(dir)/tb
templates_src = $(dir)/templates
name ?= ""



module:
	@cp $(templates_src)/module.v $(rtl_src)/$(name).v
	@sed -i 's@name@$(name)@g' $(rtl_src)/$(name).v


tb:
	@cp $(templates_src)/tb.sv $(tb_src)/tb_$(name).sv
	@sed -i 's@tb_name@tb_$(name)@g' $(tb_src)/tb_$(name).sv
	@sed -i 's@name@$(name)@g' $(tb_src)/tb_$(name).sv


compile:
	@vlib work
	@vlog -work work +acc -sv tb/tb_$(name).sv

sim:
	@make compile name=$(name)
	@vsim -c work.tb_$(name) -voptargs=+acc
	@rm -rf transcript	
	@rm -rf *.log work

wave:
	gtkwave wave_file/tb_$(name).vcd
