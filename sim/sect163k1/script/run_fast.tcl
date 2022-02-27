if {[file exists work]} {
    vdel -lib work -all
}
vlib work

vlog -f script/filelist.f

vsim tb_sect163k1_pt_mul +TESTNAME=tc_sect163k1

run -all
