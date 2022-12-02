LTX=pdflatex -shell-escape
SRC=main.tex
BIB=biber

all: main.pdf

main.pdf: $(SRC) references.bib
	$(LTX) $(SRC)
	$(BIB) $(SRC:tex=bcf)
	$(LTX) $(SRC)
	$(LTX) $(SRC)

.PHONY: clean
clean:
	-rm -f *.log *.snm *.out *.nav *.toc *.aux *.bbl *.bcf *.blg *.vrb
	-rm -f main.pdf
