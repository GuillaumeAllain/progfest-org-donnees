builddir = ../../build/python

pythonfiles = $(wildcard *.py)

pythonfname = $(notdir $(pythonfiles))
pythonbname = $(pythonfname:%.py=%)
pythonflag = $(addprefix $(builddir)/,$(addsuffix .flag,$(pythonbname)))

DATATARGETSLOC = $(addprefix ../../,$(DATATARGETS))

SHELL := /usr/bin/env zsh
.PHONY: cleanenv all env clean

all : $(pythonflag)
	-@ mkdir -p $(builddir)
	touch $(builddir)/python_stamp

env: $(builddir)/env/touchfile

$(builddir)/env/touchfile: environment.yaml
	test -d $(builddir)/env || conda env create --prefix $(builddir)/env --file environment.yaml \
	&& conda env update --prefix $(builddir)/env --file environment.yaml --prune
	touch $(builddir)/env/touchfile

cleanenv :
	rm -rf $(builddir)/env

clean:
	-@ rm -rf $(builddir) output

$(builddir)/%.flag : %.py $(DATATARGETSLOC) env
	-@ mkdir output
	source $(HOME)/.zshrc;conda activate $(builddir)/env; python $<; conda deactivate;
	-@ mkdir -p $(builddir)
	rsync -aP output $(builddir)
	touch $@


