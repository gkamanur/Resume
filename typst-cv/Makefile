SHELL := /bin/bash
COMPOSE := docker compose
SERVICE := typst
OUTPUT := output/mainframe-cv.pdf

.PHONY: build shell fonts check compile watch inspect clean

build:
	$(COMPOSE) build

shell:
	$(COMPOSE) run --rm --entrypoint bash $(SERVICE)

fonts:
	$(COMPOSE) run --rm --entrypoint typst $(SERVICE) fonts
	$(COMPOSE) run --rm --entrypoint fc-list $(SERVICE) : family

check:
	$(COMPOSE) run --rm --entrypoint typst $(SERVICE) compile --diagnostic-format short main.typ /tmp/cv-check.pdf

compile:
	mkdir -p output
	$(COMPOSE) run --rm --entrypoint typst $(SERVICE) compile main.typ $(OUTPUT)

watch:
	mkdir -p output
	$(COMPOSE) run --rm --entrypoint typst $(SERVICE) watch main.typ $(OUTPUT)

inspect:
	$(COMPOSE) run --rm --entrypoint pdfinfo $(SERVICE) $(OUTPUT)

cover-letter:
	mkdir -p output
	$(COMPOSE) run --rm --entrypoint typst $(SERVICE) compile cover-letter.typ output/cover-letter.pdf

check-cover-letter:
	$(COMPOSE) run --rm --entrypoint typst $(SERVICE) compile --diagnostic-format short cover-letter.typ /tmp/cover-letter-check.pdf

clean:
	rm -f output/*.pdf
