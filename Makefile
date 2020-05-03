
# Rolf Niepraschk, 2014-01-19, Rolf.Niepraschk@gmx.de

.SUFFIXES : .tex .ltx .dvi .ps .pdf .eps

MAIN = showexpl

VERSION = $(shell awk -F"[[]" \
  '/Typesetting example code/ {split($$2,a," ");gsub("/","-",a[1]);printf "%s", a[1]}' \
  $(MAIN).dtx)

DIST_DIR1 = $(MAIN)
DIST_DIR2 = $(MAIN)/doc

DIST_FILES1 = README $(MAIN).dtx $(MAIN).ins
DIST_FILES2 = $(MAIN).pdf doc/$(MAIN)-test.tex doc/$(MAIN)-test.pdf \
  doc/result-picture.pdf



PDFLATEX = pdflatex

LATEX = latex

ARCHNAME = $(MAIN)-$(VERSION).zip

EXAMPLE = doc/$(MAIN)-test.tex

all : pdf doc

pdf : $(EXAMPLE:.tex=.pdf)

ps  : $(EXAMPLE:.tex=.ps)

doc : $(MAIN).pdf

doc/$(MAIN)-test.pdf : doc/$(MAIN)-test.tex $(MAIN).sty doc/result-picture.pdf
	$(MAKE) -C doc

debug :
	@echo ">"$(VERSION)"<"
	@echo ">"$(ARCHNAME)"<"

$(MAIN).sty : $(MAIN).ins $(MAIN).dtx
	tex $<
	mv $(basename $<).log $<.log

%.ps : %.dvi
	dvips -o $@ $<

$(MAIN).pdf : $(MAIN).dtx $(MAIN).sty
	if ! test -f $(basename $<).glo ; then touch $(basename $<).glo; fi
	if ! test -f $(basename $<).idx ; then touch $(basename $<).idx; fi
	makeindex -s gglo.ist -t $(basename $<).glg -o $(basename $<).gls \
		$(basename $<).glo
	makeindex -s gind.ist -t $(basename $<).ilg -o $(basename $<).ind \
		$(basename $<).idx
	$(PDFLATEX) $<

dist : all
	mkdir -p $(DIST_DIR1)
	mkdir -p $(DIST_DIR2)
	cp -p $(DIST_FILES1) $(DIST_DIR1)
	cp -p $(DIST_FILES2) $(DIST_DIR2)
	rm -f $(ARCHNAME)
	zip $(ARCHNAME) -r $(DIST_DIR1)
	rm -rf $(DIST_DIR1)


