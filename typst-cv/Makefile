SHELL := /bin/bash
COMPOSE := docker compose
SERVICE := typst

include .env
export

TEMPLATE_ROOT ?= /work/templates
ACTIVE_TEMPLATE ?= a
TEMPLATES := a b c

# Every template reads /work/configuration.yaml, so --root must be the project root.
TYPST := $(COMPOSE) run --rm --entrypoint typst $(SERVICE)
TEMPLATE_DIR := $(TEMPLATE_ROOT)/$(ACTIVE_TEMPLATE)
OUTPUT := output/mainframe-cv-$(ACTIVE_TEMPLATE).pdf

.PHONY: build shell fonts check check-all compile compile-all watch inspect clean cover-letter check-cover-letter

build:
	$(COMPOSE) build

shell:
	$(COMPOSE) run --rm --entrypoint bash $(SERVICE)

fonts:
	$(TYPST) fonts
	$(COMPOSE) run --rm --entrypoint fc-list $(SERVICE) : family

# make check                    -> checks the active template (default: a)
# make check ACTIVE_TEMPLATE=c  -> checks template c
check:
	$(TYPST) compile --root /work --diagnostic-format short $(TEMPLATE_DIR)/main.typ /tmp/cv-check.pdf

check-all:
	@for t in $(TEMPLATES); do \
		echo "== template $$t"; \
		$(MAKE) --no-print-directory check ACTIVE_TEMPLATE=$$t || exit 1; \
	done

compile:
	mkdir -p output
	$(TYPST) compile --root /work $(TEMPLATE_DIR)/main.typ $(OUTPUT)

compile-all:
	@for t in $(TEMPLATES); do \
		$(MAKE) --no-print-directory compile ACTIVE_TEMPLATE=$$t || exit 1; \
	done

watch:
	mkdir -p output
	$(TYPST) watch --root /work $(TEMPLATE_DIR)/main.typ $(OUTPUT)

inspect:
	$(COMPOSE) run --rm --entrypoint pdfinfo $(SERVICE) $(OUTPUT)

# cover-letter/main.typ reads cover-letter/cover-letter.yaml (+ sender from configuration.yaml)
cover-letter:
	mkdir -p output
	$(TYPST) compile --root /work /work/cover-letter/main.typ output/cover-letter.pdf

check-cover-letter:
	$(TYPST) compile --root /work --diagnostic-format short /work/cover-letter/main.typ /tmp/cover-letter-check.pdf

clean:
	rm -f output/*.pdf
