if {[file exists work]} {
    vdel -lib work -all
}
vlib work

vlog -f script/filelist.f

vsim tb_sect233r1_pt_mul +TESTNAME=tc_sect233r1

run -all
