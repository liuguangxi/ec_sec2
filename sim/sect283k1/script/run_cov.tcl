if {[file exists work]} {
    vdel -lib work -all
}
vlib work

vlog -f script/filelist.f

vsim -coverage tb_sect283k1_pt_mul -voptargs="+cover=bcesfx" +TESTNAME=tc_sect283k1

set NoQuitOnFinish 1
onbreak {resume}

run -all

coverage exclude -src ../../tb/tb_sect283k1_pt_mul.sv
coverage save tc_sect283k1.ucdb
coverage report -details -html

quit
