
 #compile the source 

  vlib    work  
  
 

  vlog   ./src_trans/*.v
  
  vlog  ../src_rec/*.v

 vcom   ../src_rec/*.vhd

 vlog  ./*.v

 #
  
 
 

 #map  the library

    vmap  altera_mf_ver		D:/altera_13_0sp1/alib_32/verilog_libs/altera_mf_ver
   
    vmap  altera_mf		D:/altera_13_0sp1/alib_32/vhdl_libs/altera_mf

  vmap  lpm_ver                 	D:/altera_13_0sp1/alib_32/verilog_libs/lpm_ver
  vmap  lpm                	D:/altera_13_0sp1/alib_32/vhdl_libs/lpm



  vmap  sgate_ver                	D:/altera_13_0sp1/alib_32/verilog_libs/sgate_ver

vmap  sgate                	D:/altera_13_0sp1/alib_32/vhdl_libs/sgate


  vmap  altgxb_ver              	D:/altera_13_0sp1/alib_32/verilog_libs/altgxb_ver

  vmap  altgxb              	D:/altera_13_0sp1/alib_32/vhdl_libs/altgxb


  vmap   cycloneiii_ver         	D:/altera_13_0sp1/alib_32/verilog_libs/cycloneiii_ver




  vmap   cycloneiii         	D:/altera_13_0sp1/alib_32/vhdl_libs/cycloneiii




 # vmap   auk_dspip_lib         auk_dspip_lib  




   
 
 #vsim the top

  vsim  -t ps  -novopt  +notimingchecks  -L altera_mf_ver  -L  lpm_ver  -L  sgate_ver  -L   altgxb_ver  -L  cyclone_ver  -L  cycloneiii_ver  -L   cycloneiiils_ver  -L  auk_dspip_lib    work.receive_top_module_tb 

  
 onerror {resume}

 #Log all the objects in design. These will appear in .wlf file#

  log -r /*

  
#View sim_tb_top signals in waveform#

add wave sim:receive_top_module_tb/*


#Change radix to Hexadecimal#
radix hex

#In order to suppress these warnings, we use following two commands#
set NumericStdNoWarnings 1
set StdArithNoWarnings 1

echo "email:takeshineshiro@126.com"

run -all

run  1us 

stop

