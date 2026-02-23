MAIN = main
OUTPUT_DIR = build
# Generate timestamp
TS := $(shell date +%A%d%B%Y_%H%M)

# Determine the base name
BASE_NAME = $(shell if [ -s filename ]; then cat filename; else echo "CV"; fi)

# Final combined name
FINAL_NAME = $(BASE_NAME)_$(TS)

.PHONY: all clean build_pdf prepare_deploy

all: build_pdf prepare_deploy

build_pdf:
	mkdir -p $(OUTPUT_DIR)
	latexmk -pdf -outdir=$(OUTPUT_DIR) $(MAIN).tex
	cp $(OUTPUT_DIR)/$(MAIN).pdf $(OUTPUT_DIR)/$(FINAL_NAME).pdf

prepare_deploy:
	# 1. Create index.html from template
	sed "s/{{FILENAME}}/$(FINAL_NAME).pdf/g" template.html > $(OUTPUT_DIR)/index.html
	# 2. DELETE all auxiliary files so they don't get uploaded
	# This keeps only .pdf and .html files in the build folder
	find $(OUTPUT_DIR) -type f ! -name '*.pdf' ! -name '*.html' -delete
	@echo "Cleaned auxiliary files. Ready to deploy: $(FINAL_NAME).pdf"

clean:
	latexmk -C -outdir=$(OUTPUT_DIR)
	rm -rf $(OUTPUT_DIR)
