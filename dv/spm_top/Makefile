# SPDX-FileCopyrightText: 2020 Efabless Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0

PDK_PATH ?= $(PDK_ROOT)/sky130A/
VERILOG_PATH=../../verilog/
RTL_PATH=$(VERILOG_PATH)/rtl

SIM ?= RTL

.SUFFIXES:

PATTERN = spm_top

all:  ${PATTERN:=.vcd}

%.vvp: %_tb.v
ifeq ($(SIM),RTL)
	iverilog -I $(RTL_PATH) \
	$< -o $@
else  
	iverilog -DFUNCTIONAL -DUSE_POWER_PINS -DGL -DDFT -DUNIT_DELAY=#1 \
	-I $(PDK_PATH) -I $(VERILOG_PATH) \
	$< -o $@ 
endif

%.vcd: %.vvp
	vvp $<

clean:
	rm -f *.vvp *.vcd

.PHONY: clean all