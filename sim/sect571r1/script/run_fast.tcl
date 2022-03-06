if {[file exists work]} {
    vdel -lib work -all
}
vlib work

vlog -f script/filelist.f

vsim tb_sect571r1_pt_mul +TESTNAME=tc_sect571r1

run -all
