PACKAGES = pkg/*.vhdl
FILES = rtl/*.vhdl
TESTBENCH = tb/*.vhdl

FILEDIR = ./files
SIMDIR = sim
STOP_TIME = 2000ns

TEXT_FILE = "$(FILEDIR)/text.txt"
DATA_FILE = "$(FILEDIR)/data.txt"
REGS_FILE = "$(FILEDIR)/regs.txt"

WAVEFILE = $(SIMDIR)/result.fst

GHDL_CMD = ghdl
GHDL_FLAGS = --std=08 -fexplicit --ieee=synopsys --workdir=$(SIMDIR)
GHDL_SIM_OPT = --stop-time=$(STOP_TIME)

WAVEFORM_VIEWER = surfer

REPORT_GENERATOR = genhtml

.PHONY: syntax analyze elaborate run view clean

all: syntax analyse elaborate run

syntax:
	@[ -d $(SIMDIR) ] || mkdir -p $(SIMDIR)
	@$(GHDL_CMD) -s $(GHDL_FLAGS) $(PACKAGES) $(FILES) $(TESTBENCH)

analyse: syntax
	@$(GHDL_CMD) -a -Wno-hide -Wno-library $(GHDL_FLAGS) $(PACKAGES) $(FILES) $(TESTBENCH)

elaborate: analyse
	@$(GHDL_CMD) -e $(GHDL_FLAGS) testbench

run: elaborate
	@$(GHDL_CMD) -r $(GHDL_FLAGS) testbench $(GHDL_SIM_OPT) --fst=$(WAVEFILE) -gTEXT_SEGMENT=$(TEXT_FILE) -gDATA_SEGMENT=$(DATA_FILE) -gREGISTERS=$(REGS_FILE)

coverage: elaborate
	@$(GHDL_CMD) -r --coverage $(GHDL_FLAGS) testbench $(GHDL_SIM_OPT) --fst=$(WAVEFILE) -gTEXT_SEGMENT=$(TEXT_FILE) -gDATA_SEGMENT=$(DATA_FILE) -gREGISTERS=$(REGS_FILE)
	@$(GHDL_CMD) coverage --format=lcov coverage-* > coverage.info
	@sed -i 's/FN:1:file/FN:1,file/g' coverage.info
	@$(REPORT_GENERATOR) coverage.info --quiet --output-directory $(SIMDIR)/coverage_html
	@rm -f coverage*

view: $(WAVEFILE)
	$(WAVEFORM_VIEWER) -s riscv.surf.ron $(WAVEFILE) &


clean:
	rm -rf $(SIMDIR)
	rm -rf $(WORKDIR)
	rm -f  *.o
	rm -f  testbench
	rm -f coverage*
