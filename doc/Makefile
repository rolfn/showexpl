
# Rolf Niepraschk, 2014-01-19, Rolf.Niepraschk@gmx.de

.SUFFIXES : .tex .ltx .dvi .ps .pdf .eps

PDFLATEX = pdflatex

LATEX = latex

all : showexpl-test.pdf

showexpl-test.pdf : showexpl-test.tex ../showexpl.sty result-picture.pdf
	pdflatex $<
	pdflatex $<
