




echo "INFO: Staring simulation script..."


vlog -sv Full_Adder.sv FA_Behav.sv Top_RCA.sv tb_Top_RCA.sv

echo "INFO: Compilation Completed!"

vsim -voptargs=+acc work.tb_Top_RCA

echo "INFO: simulation loaded!"

add wave -r sim:/tb_Top_RCA/dut/a
add wave -r sim:/tb_Top_RCA/dut/b
add wave -r sim:/tb_Top_RCA/dut/cin
add wave -r sim:/tb_Top_RCA/dut/sum
add wave -r sim:/tb_Top_RCA/dut/cout

add wave -r sim:/tb_Top_RCA/dut_behav/a
add wave -r sim:/tb_Top_RCA/dut_behav/b
add wave -r sim:/tb_Top_RCA/dut_behav/cin
add wave -r sim:/tb_Top_RCA/dut_behav/sum
add wave -r sim:/tb_Top_RCA/dut_behav/cout


run -all

echo "INFO: Simulation finished!"