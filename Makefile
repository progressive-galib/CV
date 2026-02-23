MAIN = main
OUTPUT_DIR = build

# Determine the base name from 'filename' or default to 'CV'
BASE_NAME = $(shell if [ -s filename ]; then cat filename; else echo "CV"; fi)

# 1. Get Month
MONTH := $(shell date +%B)
# 2. Get Day
DAY_NUM := $(shell date +%-d)
# 3. Logic for the suffix (st, nd, rd, th)
ORDINAL := $(shell case $(DAY_NUM) in 1|21|31) echo "st" ;; 2|22) echo "nd" ;; 3|23) echo "rd" ;; *) echo "th" ;; esac)

# Combine for the pretty timestamp
TS := $(MONTH),$(DAY_NUM)$(ORDINAL)
FINAL_NAME := $(BASE_NAME)_$(TS)

.PHONY: all clean build_pdf prepare_deploy

all: build_pdf prepare_deploy

build_pdf:
	mkdir -p $(OUTPUT_DIR)
	latexmk -pdf -outdir=$(OUTPUT_DIR) $(MAIN).tex
	# We use quotes around the path in case there are spaces or special chars
	cp "$(OUTPUT_DIR)/$(MAIN).pdf" "$(OUTPUT_DIR)/$(FINAL_NAME).pdf"

prepare_deploy:
	# Use @ to keep the output clean
	@sed "s/{{FILENAME}}/$(FINAL_NAME).pdf/g" template.html > $(OUTPUT_DIR)/index.html
	@echo "------------------------------------------------"
	@echo "Successfully built: $(FINAL_NAME).pdf"
	@echo "------------------------------------------------"

clean:
	latexmk -C -outdir=$(OUTPUT_DIR)
	rm -rf $(OUTPUT_DIR)
