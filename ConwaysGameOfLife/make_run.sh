#!/bin/bash

verilator --trace -cc conway.sv -exe tb_conway.cpp
make -C obj_dir -f Vconway.mk Vconway
./obj_dir/Vconway