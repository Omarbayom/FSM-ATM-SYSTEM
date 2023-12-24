vlib work
vlog DRIVER.v TB.v +cover
vsim -voptargs=+acc work.testbench -cover 
add wave *
coverage save atm_tb.ucdb -onexit -du ATM
run -all