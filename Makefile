MAIN = main
OUTPUT_DIR = build

.PHONY: all clean setup

all: setup
	latexmk $(MAIN).tex

setup:
	mkdir -p $(OUTPUT_DIR)

clean:
	latexmk -C
	rm -rf $(OUTPUT_DIR)
watch: setup
	latexmk -pvc $(MAIN).tex