MAIN = main
OUTPUT_DIR = build

# 1. Get the month name (e.g., February)
MONTH := $(shell date +%B)
# 2. Get the day number (e.g., 23)
DAY_NUM := $(shell date +%-d)
# 3. Calculate the suffix (st, nd, rd, or th)
SUFFIX := $(shell case $(DAY_NUM) in \
            1|21|31) echo "st" ;; \
            2|22)    echo "nd" ;; \
            3|23)    echo "rd" ;; \
            *)       echo "th" ;; \
          esac)

# 4. Construct the pretty timestamp: February,23rd
TS := $(MONTH),$(DAY_NUM)$(SUFFIX)

# Determine the base name from 'filename' or default to 'CV'
BASE_NAME = $(shell if [ -s filename ]; then cat filename; else echo "CV"; fi)

# Final combined name: Galib_Mehta_CV_February,23rd
FINAL_NAME = $(BASE_NAME)_$(TS)

.PHONY: all clean build_pdf prepare_deploy

all: build_pdf prepare_deploy

build_pdf:
	mkdir -p $(OUTPUT_DIR)
	latexmk -pdf -outdir=$(OUTPUT_DIR) $(MAIN).tex
	cp $(OUTPUT_DIR)/$(MAIN).pdf $(OUTPUT_DIR)/$(FINAL_NAME).pdf

prepare_deploy:
	sed "s/{{FILENAME}}/$(FINAL_NAME).pdf/g" template.html > $(OUTPUT_DIR)/index.html
	@echo "Ready to deploy: $(FINAL_NAME).pdf"

clean:
	latexmk -C -outdir=$(OUTPUT_DIR)
	rm -rf $(OUTPUT_DIR)
