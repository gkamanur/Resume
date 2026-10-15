# Five-Minute Quick Start

This section helps you build the Docker environment and generate your CV and cover letter without reading the entire guide first.

**Assumption:** Your project is already located at `~/typst-cv` and contains `Dockerfile`, `compose.yaml`, `Makefile`, `main.typ`, and `cover-letter.typ`.

## Minute 1 — Open the project

Open a terminal and run:

```bash
cd ~/typst-cv
pwd
ls -la
```

Confirm that you are in the correct directory and that the project files are present.

Check that Docker and Docker Compose are available:

```bash
docker --version
docker compose version
```

If either command fails, resolve the Docker installation or configuration issue before continuing.

## Minute 2 — Build the Docker image

Run:

```bash
make build
```

This builds the local image using your `Dockerfile` and `compose.yaml`.

The first build may take longer than one minute because Docker needs to download the base images and install the required packages.

If the build fails, read the first relevant error message rather than immediately changing the configuration.

## Minute 3 — Verify Typst

Run:

```bash
docker compose run --rm --entrypoint typst typst --version
```

This starts a temporary container and prints the installed Typst version.

Next, check that your CV source compiles:

```bash
make check
```

If Typst reports an error, correct the source file before proceeding.

## Minute 4 — Generate both PDFs

Compile the CV:

```bash
make compile
```

Compile the cover letter:

```bash
make cover-letter
```

Both commands create the `output/` directory if necessary.

Expected files:

```text
output/
├── mainframe-cv.pdf
└── cover-letter.pdf
```

## Minute 5 — Verify the results

List the generated files:

```bash
ls -lh output/
```

Inspect the CV's PDF metadata:

```bash
make inspect
```

Extract the CV's text to check that important content is present:

```bash
docker compose run --rm --entrypoint pdftotext typst \
  output/mainframe-cv.pdf -
```

Finally, open both PDFs in your PDF viewer. Check spelling, contact details, fonts, page breaks, margins, and alignment.

## Quick troubleshooting

| Problem | First action |
|---|---|
| `make: command not found` | Install Make or use the equivalent Docker Compose command directly. |
| Docker daemon unavailable | Check that Docker is running and your user can access it. |
| Typst source error | Run `make check` and inspect the reported file and line. |
| Font missing | Run `make fonts` and verify the requested font family. |
| Output file missing | Confirm compilation succeeded and inspect `output/`. |
| Permission denied | Run `id` and `ls -ld output` to inspect user and directory permissions. |

**Remember:** Editing `main.typ` or `cover-letter.typ` normally does not require rebuilding the Docker image. Recompile the affected document instead.

For the complete explanation of each file, command, and troubleshooting procedure, continue with the main guide below.
