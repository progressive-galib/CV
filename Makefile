MAIN = main
OUTPUT_DIR = build
# Read the custom filename, default to 'CV' if file is empty/missing
FINAL_NAME = $(shell cat filename 2>/dev/null || echo "CV")

.PHONY: all clean build_pdf prepare_deploy

all: build_pdf prepare_deploy

build_pdf:
	mkdir -p $(OUTPUT_DIR)
	latexmk -pdf -outdir=$(OUTPUT_DIR) $(MAIN).tex
	# Rename the output to your custom filename
	cp $(OUTPUT_DIR)/$(MAIN).pdf $(OUTPUT_DIR)/$(FINAL_NAME).pdf

prepare_deploy:
	# Create index.html from template, replacing placeholder with actual filename
	sed "s/{{FILENAME}}/$(FINAL_NAME).pdf/g" template.html > $(OUTPUT_DIR)/index.html
	@echo "Ready to deploy $(FINAL_NAME).pdf"

clean:
	latexmk -C -outdir=$(OUTPUT_DIR)
	rm -rf $(OUTPUT_DIR)
