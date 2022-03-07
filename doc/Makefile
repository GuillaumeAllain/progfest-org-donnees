logdir = log
builddir = ../build/pdf
buildlatexdir = ../build/latex
pandocfiles = $(wildcard ./*.md) $(wildcard ./*.bib)
mainfile = main.md

PD := /usr/local/bin/pandoc

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))

mainfname = $(notdir $(mainfile))
mainbname = $(mainfname:%.md=%)
mainpdf = $(addprefix $(builddir)/,$(addsuffix .pdf,$(mainbname)))

auto_template_loc = $(logdir)/latextemplate.template
template_default_loc = $(logdir)

pandocflags += --template=$(auto_template_loc)
pandocflags += -d options.yaml

ifneq ($(wildcard $(logdir)/template_default_ulthese.yaml),)
    pandocflags += --top-level-division=chapter 
endif

texflag = -pdflua -pdflualatex='lualatex --interaction=nonstopmode --shell-escape %O "\\def\\OUTPUTDIRECTORY{$(logdir)}\\input{%S}"' -cd -quiet -shell-escape -outdir="$(logdir)" 

FIGURETARGETSLOC = $(addprefix ../,$(FIGURETARGETS))

.PHONY: all clean open pdf

all : $(mainpdf)

clean: 
	-@ rm -r $(logdir) $(builddir) $(buildlatexdir)

$(mainpdf): $(mainfile) $(pandocfiles) $(auto_template_loc) $(FIGURETARGETSLOC)
	$(MAKE) -f $(mkfile_path) pdf

$(auto_template_loc): $(mainfile)
	-@ mkdir -p $(logdir)
	-@ rm $(logdir)/template_default*.yaml
	-@ rm $(logdir)/*template*
	../.pandot/pandoc/injection/genlatextemplate_script.py -o $(auto_template_loc) -y $(template_default_loc)/ -m $(mainfile)

ifneq ($(wildcard $(logdir)/template_default_osa-article.yaml),)
pdf:
	-@ rm $(logdir)/pandoc_backup.tex
	$(PD) $(pandocflags) -o pandoc_backup.tex $(mainfile) $(filter-out options.yaml,$(wildcard *.yaml)) $(wildcard $(logdir)/template_default*.yaml)
	-@ cp ../.pandot/latex/defaults/latexmkrc .
	-@ perl -pi -e 's/\(cite.*\){internal-/\1internal{/g' pandoc_backup.tex;\
	perl -pi -e 's/\\cite[t,p]{/\\cite{/g' pandoc_backup.tex;\
	latexmk $(texflag) pandoc_backup.tex
	-@ mkdir -p $(buildlatexdir)
	-@ echo latexmk $(texflag) pandoc_backup.tex > latex_cmd.sh
	-@ rsync -ax --exclude $(buildlatexdir) ./* $(buildlatexdir)
	-@ rm $(buildlatexdir)/Makefile
	-@ rm latex_cmd.sh
	-@ mv pandoc_backup.tex $(logdir)
	-@ mv latexmkrc $(logdir)
	-@ mkdir -p $(builddir)
	-@ cp $(logdir)/pandoc_backup.pdf $(mainpdf)
else
pdf:
	-@ rm $(logdir)/pandoc_backup.tex
	$(PD) $(pandocflags) -o pandoc_backup.tex $(mainfile) $(filter-out options.yaml,$(wildcard *.yaml)) $(wildcard $(logdir)/template_default*.yaml)
	-@ cp ../.pandot/latex/defaults/latexmkrc .
	-@ perl -pi -e 's/\(cite.*\){internal-/\1internal{/g' pandoc_backup.tex;\
	perl -pi -e 's/\\cite[t,p]{/\\cite{/g' pandoc_backup.tex;\
	latexmk $(texflag) pandoc_backup.tex
	-@ mkdir -p $(buildlatexdir)
	-@ echo latexmk $(texflag) pandoc_backup.tex > latex_cmd.sh
	-@ rsync -ax --exclude $(buildlatexdir) ./* $(buildlatexdir)
	-@ rm $(buildlatexdir)/Makefile
	-@ rm latex_cmd.sh
	-@ mv pandoc_backup.tex $(logdir)
	-@ mv latexmkrc $(logdir)
	-@ mkdir -p $(builddir)
	-@ cp $(logdir)/pandoc_backup.pdf $(mainpdf)
endif

open:
	-open $(mainpdf)
