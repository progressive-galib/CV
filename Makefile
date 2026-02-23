MAIN = main
OUTPUT_DIR = build
# Generate timestamp in format: YYYYMMDD_HHMM
TS := $(shell date +%Y%m%d_%H%M)

# Determine the base name
BASE_NAME = $(shell if [ -s filename ]; then cat filename; else echo "CV"; fi)

# Final combined name
FINAL_NAME = $(BASE_NAME)_$(TS)

.PHONY: all clean build_pdf prepare_deploy

all: build_pdf prepare_deploy

build_pdf:
	mkdir -p $(OUTPUT_DIR)
	latexmk -pdf -outdir=$(OUTPUT_DIR) $(MAIN).tex
	# Copy to the timestamped name
	cp $(OUTPUT_DIR)/$(MAIN).pdf $(OUTPUT_DIR)/$(FINAL_NAME).pdf

prepare_deploy:
	# Create index.html from template, replacing placeholder with actual filename
	sed "s/{{FILENAME}}/$(FINAL_NAME).pdf/g" template.html > $(OUTPUT_DIR)/index.html
	@echo "Ready to deploy: $(FINAL_NAME).pdf"

clean:
	latexmk -C -outdir=$(OUTPUT_DIR)
	rm -rf $(OUTPUT_DIR)
