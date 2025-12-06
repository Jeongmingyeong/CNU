TEX = main
PDF = $(TEX).pdf
SECTIONS = $(shell find sections -type f -name '*.tex')

.PHONY: all clean

all: $(PDF)

$(PDF): $(TEX).tex $(SECTIONS)
	latexmk -pdf -shell-escape $(TEX).tex

clean:
	latexmk -C
	rm -f *.bbl *.blg *.log *.aux *.out *.fdb_latexmk *.fls *.synctex.gz
