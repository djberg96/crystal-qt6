PDFLATEX ?= pdflatex
TARGET := crystal-qt6-guide
CHAPTERS := $(wildcard chapters/*.tex)
IMAGES := $(wildcard images/*.png)

.PHONY: all clean

all: $(TARGET).pdf

$(TARGET).pdf: $(TARGET).tex $(CHAPTERS) $(IMAGES)
	$(PDFLATEX) -interaction=nonstopmode -halt-on-error $(TARGET).tex
	$(PDFLATEX) -interaction=nonstopmode -halt-on-error $(TARGET).tex

clean:
	rm -f $(TARGET).aux $(TARGET).log $(TARGET).out $(TARGET).toc $(TARGET).lof $(TARGET).lot $(TARGET).pdf
	rm -f chapters/*.aux
