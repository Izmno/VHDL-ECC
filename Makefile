TOOL    		:= ghdl
SRCDIR			:= src
WORKDIR 		:= work
OUTDIR			:= out
TARGET  		:= $(WORKDIR)/work-obj93.cf

SIM_ENTITIES	:= vectors_tb 
SIM_ENTITIES    += hamming_tb
SIM_ENTITIES    += spc_tb
SIM_ENTITIES    += ecc_tb

TOPLEVEL 		:= pkg_matrix_tb

SIM_TARGETS 	:= $(addsuffix .sim, $(addprefix $(OUTDIR)/, $(SIM_ENTITIES)))

SIMLOG			:= $(OUTDIR)/$(TOPLEVEL).sim

SIM_OPTIONS 	:= 
SIM_OPTIONS 	+= --assert-level=error
#SIM_OPTIONS     += --backtrace-severity=error
#SIM_OPTIONS		+= --wave=$(OUTDIR)/$(TOPLEVEL).ghw

.phony:

all: $(SIM_TARGETS)
	

clean:
	@rm -rf $(WORKDIR)
	@rm -rf $(OUTDIR)

$(OUTDIR)/%.sim: $(OUTDIR) $(OUTDIR)/%.analysis
	@echo
	@echo "NOTE:  Starting simulation of $*"
	@echo "NOTE:  Writing simulation log to $(OUTDIR)/$*.sim"
	$(TOOL) -r --workdir=work $* --wave=$(OUTDIR)/$*.ghw $(SIM_OPTIONS) > $(OUTDIR)/$*.sim
	@echo "NOTE:  Simulation of $* succesful"
	@echo

$(OUTDIR)/%.analysis: $(TARGET)
	@$(TOOL) -m --workdir=work $*

# $(SIMLOG): simulation

# simulation:  $(OUTDIR) analysis
# 	@$(MAKE) simulate_default || $(MAKE) simulate_error

# simulate_default:
# 	@echo
# 	@echo "NOTE:  Starting simulation of $(TOPLEVEL)"
# 	@echo "NOTE:  Writing simulation log to $(SIMLOG)"
# 	@echo
# 	@$(TOOL) -r --workdir=work $(TOPLEVEL) $(SIM_OPTIONS) > $(SIMLOG)
# 	@echo NOTE: Simulation of $(TOPLEVEL) succesfull
# 	@echo

# simulate_error:
# 	@echo
# 	@echo ERROR: Simulation failed. Displaying last 20 lines of simulation log
# 	@echo "NOTE:  Simulation log path: ./$(SIMLOG)"
# 	@echo
# 	@tail -n 20 $(SIMLOG)

# .phony is there to analysis runs even if target is allready there
# could be created just with ghdl -i
analysis: $(TARGET) .phony
	@$(TOOL) -m --workdir=work $(TOPLEVEL)

$(TARGET): $(WORKDIR)
	@$(TOOL) -i --workdir=work $(SRCDIR)/*.vhdl

$(WORKDIR):
	@mkdir $(WORKDIR)

$(OUTDIR):
	@mkdir $(OUTDIR)

