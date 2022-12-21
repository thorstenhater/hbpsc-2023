LTX=pdflatex -shell-escape
SRC=main.tex
BIB=biber

all: main.pdf

main.pdf: $(SRC) references.bib
	$(LTX) $(SRC)
	$(BIB) $(SRC:tex=bcf)
	$(LTX) $(SRC)
	$(LTX) $(SRC)

readme: main.pdf
	pdf2svg main.pdf main.svg

.PHONY: clean readme
clean:
	-rm -f *.log *.snm *.out *.nav *.toc *.aux *.bbl *.bcf *.blg *.vrb
	-rm -f main.pdf
