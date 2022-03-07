TARGETS += build/python/python_stamp
TARGETS += build/pdf/main.pdf
FIGURETARGETS += build/python/python_stamp
export TARGETS
export FIGURETARGETS
export DATATARGETS

.PHONY: all clean open

all: $(TARGETS)



clean:
	$(MAKE) -C src/python clean
	$(MAKE) -C doc clean
	-@ rm -r build/

open:
	open build/pdf/main.pdf
build/python/python_stamp: $(wildcard src/python/*.py) $(DATATARGETS) 
	$(MAKE) -C src/python
build/pdf/main.pdf: $(wildcard doc/*.md)  $(wildcard doc/*.bib) $(FIGURETARGETS)
	$(MAKE) -C doc 
pdf: $(wildcard doc/*.md) $(wildcard doc/*.bib)
	$(MAKE) -C doc FIGURETARGETS=
