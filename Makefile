
# Rolf Niepraschk, 2014-01-19, Rolf.Niepraschk@gmx.de

.SUFFIXES : .tex .ltx .dvi .ps .pdf .eps

MAIN = showexpl

PDFLATEX = pdflatex

LATEX = latex

#ARCHNAME = $(MAIN)-$(shell date +"%y%m%d-%H%M")
ARCHNAME = $(MAIN)-$(shell date +"%y%m%d")

EXAMPLE = doc/$(MAIN)-test.tex

ARCHFILES = $(MAIN).ins $(MAIN).dtx  Makefile $(EXAMPLE)

all : pdf doc README

pdf : $(EXAMPLE:.tex=.pdf)

ps  : $(EXAMPLE:.tex=.ps)

doc : $(MAIN).pdf

doc/$(MAIN)-test.pdf : doc/$(MAIN)-test.tex $(MAIN).sty doc/result-picture.pdf
	$(MAKE) -C doc

$(MAIN).sty : $(MAIN).ins $(MAIN).dtx
	tex $<
	mv $(basename $<).log $<.log

%.ps : %.dvi
	dvips -o $@ $<

$(MAIN).dvi : $(MAIN).dtx $(MAIN).sty
	if ! test -f $(basename $<).glo ; then touch $(basename $<).glo; fi
	if ! test -f $(basename $<).idx ; then touch $(basename $<).idx; fi
	makeindex -s gglo.ist -t $(basename $<).glg -o $(basename $<).gls \
		$(basename $<).glo
	makeindex -s gind.ist -t $(basename $<).ilg -o $(basename $<).ind \
		$(basename $<).idx
	$(LATEX) $<

$(MAIN).pdf : $(MAIN).dtx $(MAIN).sty
	if ! test -f $(basename $<).glo ; then touch $(basename $<).glo; fi
	if ! test -f $(basename $<).idx ; then touch $(basename $<).idx; fi
	makeindex -s gglo.ist -t $(basename $<).glg -o $(basename $<).gls \
		$(basename $<).glo
	makeindex -s gind.ist -t $(basename $<).ilg -o $(basename $<).ind \
		$(basename $<).idx
	$(PDFLATEX) $<

README : README.md
	cat $< | awk '/^```/ {$$0=""} \
     /is also/ {exit} \
     {print}' > $@

arch :
	zip $(ARCHNAME).zip $(ARCHFILES)

