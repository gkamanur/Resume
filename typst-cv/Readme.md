# Docker-Based Typst CV and Cover Letter System
## Complete Beginner-Friendly Technical Guide

**Project:** Mainframe Developer CV and Cover Letter Generator  
**Tools:** Docker, Docker Compose, Typst, Make, Linux  
**Purpose:** Build a repeatable local environment for creating professional CVs and cover letters as PDF files.

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Understanding the Technologies](#2-understanding-the-technologies)
3. [Project Directory Structure](#3-project-directory-structure)
4. [Understanding the Dockerfile](#4-understanding-the-dockerfile)
5. [Understanding Docker Compose](#5-understanding-docker-compose)
6. [Understanding .dockerignore](#6-understanding-dockerignore)
7. [Understanding Typst and Its Files](#7-understanding-typst-and-its-files)
8. [Understanding the Makefile](#8-understanding-the-makefile)
9. [Docker Commands Explained](#9-docker-commands-explained)
10. [Understanding Fonts](#10-understanding-fonts)
11. [Building the CV and Cover Letter](#11-building-the-cv-and-cover-letter)
12. [Understanding PDF Output](#12-understanding-pdf-output)
13. [File Permissions and User IDs](#13-file-permissions-and-user-ids)
14. [Troubleshooting](#14-troubleshooting)
15. [Daily Development Workflow](#15-daily-development-workflow)
16. [Software Engineering Lessons](#16-software-engineering-lessons)
17. [Security and Maintenance](#17-security-and-maintenance)
18. [Final Checklist](#18-final-checklist)

---

# 1. Project Overview

The objective is to create a local document-generation environment that can compile a CV and cover letter into PDF files.

Instead of installing Typst and all its dependencies directly on the host operating system, Docker provides an isolated environment containing the required tools.

The project follows this process:

1. Write or update the CV and cover letter source files.
2. Start a Docker container with Typst available.
3. Compile the source files into PDF documents.
4. Save the generated PDFs into the project's `output/` directory.
5. Inspect the resulting PDFs and repeat whenever the documents change.

### Example

You edit:

- `main.typ` — the main CV source.
- `cover-letter.typ` — the cover letter source.
- `configuration.yaml` — configuration values, if referenced by the template.
- `vantage-typst.typ` — shared layout or template definitions.

You then run:

```bash
make build
make compile
make cover-letter
```

The expected output files are:

```text
output/
├── mainframe-cv.pdf
└── cover-letter.pdf
```

The precise output depends on the names and paths configured in the Makefile.

## Why use Docker?

Docker makes the build environment easier to reproduce.

For example, suppose you move the project to another Linux computer. Without a container, you might need to install Typst, configure fonts, install PDF utilities, and resolve differences between package versions.

With Docker, the project describes its environment in a Dockerfile.

**Important:** Docker improves reproducibility, but it does not automatically guarantee identical PDFs forever. Image tags such as `latest`, changing fonts, and different tool versions can still change the result.

---

# 2. Understanding the Technologies

Before examining individual files, understand the purpose of each component.

## 2.1 Docker

Docker packages an application environment into a container image and runs containers from that image.

Think of a Docker image as a prepared software environment and a container as a running instance of that environment.

For this project, the environment contains Typst, fonts, and PDF inspection tools.

## 2.2 Dockerfile

A Dockerfile is a set of instructions for building a Docker image.

For example:

```dockerfile
FROM debian:bookworm-slim
RUN apt-get update
```

These instructions specify the base operating system and a command to execute while building the image.

## 2.3 Docker Compose

Docker Compose describes how to run the project using a YAML configuration file.

Instead of remembering a long `docker run` command, you can use:

```bash
docker compose run --rm typst
```

Compose reads `compose.yaml` and applies its configured volumes, environment variables, working directory, and image.

## 2.4 Typst

Typst is a document-authoring and typesetting system.

It processes `.typ` source files and generates PDFs.

For example:

```bash
typst compile main.typ output/mainframe-cv.pdf
```

This command compiles `main.typ` into a PDF.

## 2.5 Make

Make reads instructions from a file named `Makefile`.

Instead of remembering every Docker command, you can define convenient targets:

```bash
make compile
```

The `compile` target can create the output directory and invoke Typst inside the Docker container.

## 2.6 Linux shell

The shell interprets commands such as:

```bash
mkdir -p output
pwd
ls -la
```

It also runs scripts and passes command-line arguments to programs.

## 2.7 PDF utilities

This project uses PDF tools such as:

- `pdfinfo` — displays PDF metadata.
- `pdftotext` — extracts text from a PDF.
- `fc-list` — lists installed fonts.
- `fc-match` — identifies the font selected for a requested family.

These tools help validate the generated documents.

---

# 3. Project Directory Structure

A typical project layout looks like this:

```text
typst-cv/
├── Dockerfile
├── compose.yaml
├── .dockerignore
├── Makefile
│
├── main.typ
├── cover-letter.typ
├── vantage-typst.typ
├── configuration.yaml
│
├── icons/
├── fonts/
├── assets/
│
└── output/
    ├── mainframe-cv.pdf
    └── cover-letter.pdf
```

The exact contents may vary according to your existing project.

## What each file does

| File or directory | Purpose |
|---|---|
| `Dockerfile` | Defines the Docker image and installed software. |
| `compose.yaml` | Defines how the container is started. |
| `.dockerignore` | Excludes unnecessary files from the Docker build context. |
| `Makefile` | Provides short commands for common tasks. |
| `main.typ` | Main CV source document. |
| `cover-letter.typ` | Cover letter source document. |
| `vantage-typst.typ` | Shared template or layout definitions, depending on its contents. |
| `configuration.yaml` | Configuration data, if loaded by the Typst template or related tooling. |
| `icons/` | SVG or other supported icon assets. |
| `fonts/` | Optional project-specific fonts. |
| `assets/` | Images, logos, or other document resources. |
| `output/` | Generated PDF files. |

### Important distinction

Docker does not automatically understand or process every file in the project.

For example, having `configuration.yaml` in the directory does not mean Typst automatically reads it. The source code must explicitly load the file or another tool must process it.

Likewise, `vantage-typst.typ` only affects the document if it is imported or otherwise used by the relevant source.

---

# 4. Understanding the Dockerfile

The Dockerfile prepares the environment required to compile the documents.

The following is the project's current design:

```dockerfile
ARG TYPST_IMAGE=ghcr.io/typst/typst:latest

FROM ${TYPST_IMAGE} AS typst_binary

FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    fontconfig \
    fonts-dejavu-core \
    fonts-liberation \
    fonts-lato \
    fonts-noto-core \
    fonts-noto-cjk \
    fonts-crosextra-carlito \
    fonts-crosextra-caladea \
    poppler-utils \
    make \
    bash \
    && rm -rf /var/lib/apt/lists/*

COPY --from=typst_binary /bin/typst /usr/local/bin/typst

RUN mkdir -p /work /home/typst \
    && useradd --create-home --uid 1000 --shell /bin/bash typst \
    && chown -R typst:typst /work /home/typst

ENV HOME=/home/typst

ENV TYPST_FONT_PATHS=/work/fonts:/usr/local/share/fonts:/usr/share/fonts

WORKDIR /work

CMD ["bash"]
```

This uses a multi-stage build: the first image supplies the Typst executable, while the final image is based on Debian.

## 4.1 `ARG TYPST_IMAGE=...`

```dockerfile
ARG TYPST_IMAGE=ghcr.io/typst/typst:latest
```

`ARG` defines a build-time variable.

Here, `TYPST_IMAGE` identifies the image from which the Typst executable will be copied.

The default value points to an image hosted on GitHub Container Registry.

You can override this build argument when building the image.

For example:

```bash
docker compose build --build-arg TYPST_IMAGE=ghcr.io/typst/typst:latest
```

Build arguments are primarily for configuring the image build. They are not automatically persistent runtime environment variables.

## 4.2 The first `FROM`

```dockerfile
FROM ${TYPST_IMAGE} AS typst_binary
```

This starts the first build stage.

The name `typst_binary` is an alias for that stage.

Its purpose is to provide the Typst executable. The final image does not need to contain the complete first-stage filesystem.

## 4.3 The second `FROM`

```dockerfile
FROM debian:bookworm-slim
```

This starts the final build stage.

`debian:bookworm-slim` is a relatively small Debian base image.

The final image is based on this stage, not the first stage.

This is useful because you can copy only the required executable from the first image rather than retaining all its other files.

## 4.4 `DEBIAN_FRONTEND=noninteractive`

```dockerfile
ENV DEBIAN_FRONTEND=noninteractive
```

This environment variable tells Debian package-management tools to avoid interactive prompts where supported.

That is useful when building images automatically.

It does not remove every possible installation failure; package repositories can still be unavailable, packages can conflict, and network operations can fail.

## 4.5 Installing dependencies

```dockerfile
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    fontconfig \
    fonts-dejavu-core \
    fonts-liberation \
    fonts-lato \
    fonts-noto-core \
    fonts-noto-cjk \
    fonts-crosextra-carlito \
    fonts-crosextra-caladea \
    poppler-utils \
    make \
    bash \
    && rm -rf /var/lib/apt/lists/*
```

`RUN` executes a command during image construction.

### `apt-get update`

Refreshes the local package index.

It downloads package metadata from the configured Debian repositories.

### `apt-get install`

Installs the requested packages.

The `-y` option automatically confirms installation prompts.

The `--no-install-recommends` option avoids installing additional recommended packages that are not explicitly required.

### Why install these packages?

- `ca-certificates`: enables applications to validate trusted TLS certificates.
- `fontconfig`: manages font discovery and matching.
- `fonts-dejavu-core`: provides DejaVu fonts.
- `fonts-liberation`: provides Liberation fonts.
- `fonts-lato`: provides the Lato font family.
- `fonts-noto-core`: provides many Unicode glyphs.
- `fonts-noto-cjk`: adds Chinese, Japanese, and Korean font coverage.
- `fonts-crosextra-carlito` and `fonts-crosextra-caladea`: provide additional fonts commonly used as metric-compatible alternatives to other font families.
- `poppler-utils`: provides utilities such as `pdfinfo` and `pdftotext`.
- `make`: runs the project's Makefile targets.
- `bash`: provides the Bash shell.

### Why remove `/var/lib/apt/lists/*`?

```dockerfile
rm -rf /var/lib/apt/lists/*
```

The package index files are not required after installation completes.

Removing them reduces unnecessary data in the resulting image layer.

The command is safe in this specific context because the path is the package manager's metadata directory.

## 4.6 Copying the Typst executable

```dockerfile
COPY --from=typst_binary /bin/typst /usr/local/bin/typst
```

This copies a file from the first build stage into the final image.

The syntax is:

```dockerfile
COPY --from=STAGE SOURCE DESTINATION
```

Here:

- `--from=typst_binary` selects the first stage.
- `/bin/typst` is the source path in that stage.
- `/usr/local/bin/typst` is the destination in the final image.

The destination is a conventional location for locally installed executables.

### Why is the exact source path important?

The source path must exist in the image used by the first stage.

A Docker image can define an entrypoint such as:

```dockerfile
ENTRYPOINT ["/bin/typst"]
```

This identifies the program Docker normally starts. It does not, by itself, prove where the executable is stored, although in this case the image inspection identified `/bin/typst`.

If the source path does not exist, the Docker build fails.

## 4.7 Creating directories and a user

```dockerfile
RUN mkdir -p /work /home/typst \
    && useradd --create-home --uid 1000 --shell /bin/bash typst \
    && chown -R typst:typst /work /home/typst
```

This is a chain of shell commands joined with `&&`.

Each command executes only if the previous command succeeds.

### `mkdir -p`

Creates directories if they do not exist.

The `-p` option also creates missing parent directories and avoids errors when the directories already exist.

### `useradd`

Creates a Linux user named `typst`.

- `--create-home` creates a home directory.
- `--uid 1000` requests numeric user ID 1000.
- `--shell /bin/bash` sets Bash as the login shell.

### `chown`

```bash
chown -R typst:typst /work /home/typst
```

Changes ownership recursively.

The owner and group are both set to `typst`.

This establishes the intended permissions for the directories inside the image.

**Important:** A bind mount can hide the ownership and contents of the image's `/work` directory. The permissions on the host-mounted project directory still matter.

## 4.8 The `HOME` environment variable

```dockerfile
ENV HOME=/home/typst
```

Sets the default home directory environment variable.

Applications may use `HOME` to locate user configuration or cache files.

The Compose file in this project overrides this value at runtime, so the effective value can be different when the container runs.

## 4.9 The Typst font path

```dockerfile
ENV TYPST_FONT_PATHS=/work/fonts:/usr/local/share/fonts:/usr/share/fonts
```

This tells Typst which directories to search for fonts, subject to the font-loading behavior of the installed Typst version.

The colon separates paths on Linux.

The paths are:

1. `/work/fonts` — project-provided fonts.
2. `/usr/local/share/fonts` — locally installed system fonts.
3. `/usr/share/fonts` — fonts installed by the operating system.

If `fonts/` on the host is mounted into `/work`, the first path can expose project-specific fonts to Typst.

## 4.10 The working directory

```dockerfile
WORKDIR /work
```

Sets the default working directory for subsequent Dockerfile instructions and the container.

Relative paths are resolved from this directory unless another working directory is selected.

For example, `main.typ` normally refers to:

```text
/work/main.typ
```

when a command runs in the configured working directory.

## 4.11 The default command

```dockerfile
CMD ["bash"]
```

Sets the default command for the final image.

If the container is started without a different command or entrypoint override, Docker runs Bash.

The JSON-array form is called exec form. It avoids using a shell to interpret the command by default.

In this project, the default command is useful for interactive troubleshooting.

---

# 5. Understanding Docker Compose

The project's `compose.yaml` is:

```yaml
services:
  typst:
    build:
      context: .
      dockerfile: Dockerfile
      args:
        TYPST_IMAGE: ${TYPST_IMAGE:-ghcr.io/typst/typst:latest}

    image: local/typst-cv:dev

    working_dir: /work

    environment:
      HOME: /tmp
      TYPST_FONT_PATHS: /work/fonts:/usr/local/share/fonts:/usr/share/fonts

    volumes:
      - ./:/work

    init: true
    stdin_open: true
    tty: true
```

This defines a service named `typst`.

## 5.1 `services`

```yaml
services:
  typst:
```

A Compose file can define one or more services.

Each service describes a container configuration.

Here, `typst` is the service name used by commands such as:

```bash
docker compose run --rm typst
```

## 5.2 Build configuration

```yaml
build:
  context: .
  dockerfile: Dockerfile
```

`context: .` means the current project directory is the build context.

Docker uses the build context to access files needed during the image build.

`dockerfile: Dockerfile` tells Compose which file contains the image instructions.

## 5.3 Passing the image argument

```yaml
args:
  TYPST_IMAGE: ${TYPST_IMAGE:-ghcr.io/typst/typst:latest}
```

Compose supports variable interpolation.

The expression:

```text
${TYPST_IMAGE:-ghcr.io/typst/typst:latest}
```

means to use the value of `TYPST_IMAGE` when it is set and non-empty; otherwise, use the default image reference.

This lets you change the source image without editing the Compose file.

## 5.4 The resulting image name

```yaml
image: local/typst-cv:dev
```

This names the image built for the service.

- `local/typst-cv` is the image name.
- `dev` is the tag.

This is a local image reference, not necessarily an image published to a registry.

## 5.5 Working directory

```yaml
working_dir: /work
```

Sets the container's working directory at runtime.

This aligns with the Dockerfile's `WORKDIR`.

## 5.6 Runtime environment variables

```yaml
environment:
  HOME: /tmp
  TYPST_FONT_PATHS: /work/fonts:/usr/local/share/fonts:/usr/share/fonts
```

These values apply when the container runs.

Notice that `HOME` is set to `/tmp`, overriding the Dockerfile's `/home/typst`.

That can be useful for temporary application state, but it means the container is not using `/home/typst` as its runtime home directory.

A different `HOME` value is not a substitute for setting file permissions correctly.

## 5.7 Bind mounts

```yaml
volumes:
  - ./:/work
```

This is one of the most important lines in the project.

It mounts the current host project directory into the container at `/work`.

The left side is the host path:

```text
./
```

The right side is the container path:

```text
/work
```

This allows Typst inside Docker to read your local source files and write PDFs back into your project.

For example:

```text
Host:
~/typst-cv/main.typ

Container:
/work/main.typ
```

Both refer to the same underlying file while the mount is active.

### Why is this useful?

Without a bind mount, files created in a temporary container could disappear when the container is removed.

With a bind mount, the generated PDF is written into the host project directory.

### A subtle but important detail

A bind mount can hide files that were originally present at the destination inside the image.

For example, if `/work` contained files baked into the image, mounting the host directory over `/work` would hide those image files while the mount is active.

That is expected behavior.

## 5.8 `init: true`

```yaml
init: true
```

Asks Docker to use a small init process inside the container.

An init process can help with signal forwarding and reaping child processes.

It does not install a full service manager.

## 5.9 Interactive terminal settings

```yaml
stdin_open: true
tty: true
```

These options keep standard input open and allocate a terminal.

They are helpful when running an interactive shell.

They are not required for every one-off command, but they make interactive troubleshooting easier.

---

# 6. Understanding `.dockerignore`

The project uses:

```text
.git/
output/
*.pdf
*.log
.cache/
```

This file tells Docker which files and directories to exclude from the build context.

## What each pattern means

### `.git/`

Excludes the Git metadata directory.

The Docker image usually does not need the project's complete Git history.

### `output/`

Excludes the generated-output directory from the Docker build context.

The current PDFs remain on the host. They are not deleted.

### `*.pdf`

Excludes PDF files that match this pattern in the relevant context.

This avoids sending existing generated documents to Docker during the build.

### `*.log`

Excludes matching log files.

### `.cache/`

Excludes the matching cache directory.

## Why use `.dockerignore`?

It can:

- Reduce the amount of data sent to the Docker builder.
- Avoid copying unnecessary files into the image.
- Reduce accidental inclusion of generated output.
- Make builds more efficient.

**Important:** `.dockerignore` does not control bind mounts at runtime.

Even if `output/` is excluded from the build context, the Compose bind mount still exposes the host project directory at `/work`. The running container can still write to `/work/output` when that directory exists and the permissions allow it.

---

# 7. Understanding Typst and Its Files

Typst source files are text files that describe document content and layout.

A simple example:

```typst
#set page(
  paper: "a4",
  margin: 18mm,
)

#set text(
  font: "Lato",
  size: 10pt,
)

= Mainframe Developer

Experienced IT professional with expertise in mainframe development.
```

This creates a document with A4 page settings, text styling, and a heading.

Your actual CV template may be significantly more sophisticated.

## 7.1 `main.typ`

This is the main CV source file.

It may contain:

- Contact information.
- Professional summary.
- Technical skills.
- Employment history.
- Projects.
- Education.
- Certifications.
- Language proficiency.
- References or other relevant sections.

It can also import reusable template files.

For example:

```typst
#import "vantage-typst.typ": *
```

This is only an example. Use the import syntax and exported definitions that actually match your template.

## 7.2 `cover-letter.typ`

This is the source for a cover letter.

A reusable cover-letter template can separate fixed layout from editable details such as:

- Applicant contact details.
- Employer name.
- Job title.
- Application date.
- Greeting.
- Letter paragraphs.
- Closing.

Keep reusable layout rules separate from job-specific content where practical.

### Variable declaration order

If a variable is used to produce document content, define it before the part of the source that uses it.

For example:

```typst
#let work_authorization = "Authorized to work in Germany"

#work_authorization
```

This makes the dependency clear and avoids referencing a name before it has been defined.

## 7.3 `vantage-typst.typ`

This file appears to be a reusable template or layout module.

Depending on its contents, it may define:

- Helper functions.
- Color values.
- Typography rules.
- Layout functions.
- Reusable section components.
- Icon helpers.
- Header or footer components.

To understand exactly what it does, inspect its actual contents and check where it is imported.

Do not assume a file is used merely because it exists.

## 7.4 `configuration.yaml`

A YAML file is structured configuration data.

For example:

```yaml
name: Applicant Name
role: Mainframe Developer
location: Germany
```

This is a valid example of simple YAML data, but it is not necessarily the schema used by your current template.

Typst does not automatically load YAML just because the file is present. A Typst template or another tool must explicitly read and process it.

Before changing the structure, check which keys your existing code expects.

## 7.5 `icons/`

SVG files are commonly used for small visual elements such as:

- Email.
- Telephone.
- Location.
- LinkedIn.
- GitHub.

An icon helper may construct a path from a name:

```typst
image("icons/" + name + ".svg")
```

If the helper receives `email`, the resulting path would be:

```text
icons/email.svg
```

The file must exist at the expected location.

## 7.6 `fonts/`

This directory can contain fonts that belong to the project.

A project-specific font may be useful when:

- You need a particular visual identity.
- The operating system does not supply the font.
- You want more control over typography.

Only include fonts you are legally allowed to distribute.

## 7.7 `assets/`

This directory can hold images or other resources used in the documents.

Examples include a logo or a profile photograph, if you choose to include one.

Avoid including unnecessary images because they can increase file size.

---

# 8. Understanding the Makefile

The Makefile provides short commands for repetitive tasks.

The following version matches the current project design:

```makefile
SHELL := /bin/bash

COMPOSE := docker compose
SERVICE := typst
OUTPUT := output/mainframe-cv.pdf

.PHONY: build shell fonts check compile watch inspect clean cover-letter check-cover-letter

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
```

**Important:** Makefile recipe lines must start with a real tab character, not spaces. Otherwise, Make can report a missing separator error.

## 8.1 Variables

```makefile
COMPOSE := docker compose
SERVICE := typst
OUTPUT := output/mainframe-cv.pdf
```

These define reusable values.

For example:

```makefile
$(COMPOSE) build
```

expands to:

```bash
docker compose build
```

Using variables makes it easier to change a common value in one place.

## 8.2 `.PHONY`

```makefile
.PHONY: build shell fonts check compile watch inspect clean cover-letter check-cover-letter
```

This tells Make that these names represent commands rather than files to be generated.

Without `.PHONY`, if a file named `compile` existed, Make could incorrectly decide that the target was already up to date.

## 8.3 `make build`

```makefile
build:
	$(COMPOSE) build
```

Builds the service image using the Compose configuration.

Use it after changing the Dockerfile or when you need to refresh the image.

Changes to mounted `.typ` source files do not normally require rebuilding the image.

## 8.4 `make shell`

```makefile
shell:
	$(COMPOSE) run --rm --entrypoint bash $(SERVICE)
```

Starts an interactive Bash shell in a new container.

The options mean:

- `run`: create and start a one-off service container.
- `--rm`: remove the container after it exits.
- `--entrypoint bash`: run Bash instead of the image's normal entrypoint.
- `typst`: use the configured service.

Inside the container, you can run:

```bash
pwd
ls -la
typst --version
typst fonts
fc-list
exit
```

## 8.5 `make fonts`

This target runs two commands:

```bash
docker compose run --rm --entrypoint typst typst fonts
docker compose run --rm --entrypoint fc-list typst : family
```

The first asks Typst to report its known fonts.

The second lists installed fonts using Fontconfig.

These are different checks:

- Typst's font listing helps inspect what Typst can discover.
- `fc-list` shows fonts registered with Fontconfig.

A font appearing in one listing does not automatically guarantee that a particular Typst document uses it. The requested family must also be correctly named and available to the process.

## 8.6 `make check`

This command compiles the CV to a temporary path:

```bash
docker compose run --rm --entrypoint typst typst compile --diagnostic-format short main.typ /tmp/cv-check.pdf
```

It is useful for checking whether the source compiles.

The generated file is inside the container's `/tmp` directory, not the project's `output/` directory.

Since the container is removed after the command, the temporary PDF is not retained.

This target checks compilation, not the visual quality of the CV.

## 8.7 `make compile`

The target first creates the output directory:

```bash
mkdir -p output
```

It then compiles the CV:

```bash
docker compose run --rm --entrypoint typst typst compile main.typ output/mainframe-cv.pdf
```

The relative output path resolves from `/work` inside the container.

Because `/work` is the host project directory mounted into the container, the generated PDF is written to the host's `output/` directory.

## 8.8 `make watch`

```bash
docker compose run --rm --entrypoint typst typst watch main.typ output/mainframe-cv.pdf
```

Typst's watch mode monitors source dependencies and recompiles when it detects relevant changes.

Keep this command running while you edit the document.

Stop it with `Ctrl+C`.

The exact behavior depends on the installed Typst version and its file-watching support.

## 8.9 `make inspect`

```bash
docker compose run --rm --entrypoint pdfinfo typst output/mainframe-cv.pdf
```

Runs `pdfinfo` against the generated CV.

It can report:

- Page count.
- Page size.
- PDF version.
- File size.
- Metadata.

If the file does not exist, the command will fail. Compile the CV first.

## 8.10 `make cover-letter`

```bash
mkdir -p output
docker compose run --rm --entrypoint typst typst compile cover-letter.typ output/cover-letter.pdf
```

Compiles the cover letter and writes:

```text
output/cover-letter.pdf
```

## 8.11 `make check-cover-letter`

Checks the cover letter by compiling it to a temporary PDF in the container.

It is similar to `make check`, but uses `cover-letter.typ`.

## 8.12 `make clean`

```makefile
clean:
	rm -f output/*.pdf
```

Removes PDF files that match the pattern inside the host project's `output/` directory.

The `-f` option prevents an error if no matching file exists.

This does not remove your `.typ` source files.

Be careful: it removes all matching PDFs in that output directory, not just the CV.

---

# 9. Docker Commands Explained

These commands are useful for understanding and troubleshooting the environment.

## 9.1 Check Docker versions

```bash
docker --version
docker compose version
```

The first checks the Docker CLI version.

The second checks Docker Compose availability and version.

## 9.2 Inspect the current directory

Run these commands on the host:

```bash
pwd
ls -la
```

`pwd` prints the current directory.

`ls -la` lists files, including hidden files such as `.dockerignore`.

This is useful before running Compose commands because Compose normally looks for its configuration relative to the current directory.

## 9.3 Inspect the Docker image

```bash
docker image ls
```

Lists local Docker images.

To inspect a specific image:

```bash
docker image inspect local/typst-cv:dev
```

This displays metadata such as image configuration, environment variables, working directory, and default command.

To inspect the original Typst image, use the image reference configured in the Dockerfile or Compose file.

## 9.4 Build the project

```bash
docker compose build
```

Compose reads the build configuration and builds the local image.

If the image does not exist, a later `docker compose run` may attempt to build it, depending on the command and configuration. Running `make build` explicitly makes the intended step clear.

## 9.5 Run a version check

```bash
docker compose run --rm --entrypoint typst typst --version
```

This starts a one-off container and asks Typst to print its version.

The options work as follows:

- `docker compose run`: starts a one-off service container.
- `--rm`: removes the container after it exits.
- `--entrypoint typst`: uses the Typst executable as the process.
- `typst`: identifies the Compose service.
- `--version`: asks Typst to report its version.

## 9.6 Check the files inside the container

```bash
docker compose run --rm --entrypoint bash typst
```

Inside the container:

```bash
pwd
ls -la
ls -la /work
ls -la /work/output
```

These commands help verify the working directory and bind mount.

If a host file is missing from `/work`, check that:

1. You are running Compose from the intended project.
2. The volume mapping is correct.
3. The file exists on the host.
4. The filename and capitalization match.

## 9.7 Export an image to a tar file

To export a local image into an archive:

```bash
docker save -o typst-cv-image.tar local/typst-cv:dev
```

This saves the image layers and metadata to a tar archive.

It does not export the source directory or the generated PDFs unless those files are baked into the image.

To load the archive later:

```bash
docker load -i typst-cv-image.tar
```

For reproducible builds, preserve the Dockerfile, Compose file, source files, and version information in addition to any image archive.

## 9.8 Inspect an image's default configuration

```bash
docker image inspect local/typst-cv:dev
```

To print only the configured entrypoint and command:

```bash
docker image inspect \
  --format='Entrypoint={{json .Config.Entrypoint}} Cmd={{json .Config.Cmd}}' \
  local/typst-cv:dev
```

This is useful when a command unexpectedly launches Typst instead of Bash.

## 9.9 Understand entrypoint overrides

The original Typst image may define Typst as its entrypoint.

If you execute a command against that image without overriding the entrypoint, Docker can pass your command arguments to Typst instead of starting a shell.

That is why the Makefile uses commands such as:

```bash
docker compose run --rm --entrypoint bash typst
```

or:

```bash
docker compose run --rm --entrypoint typst typst --version
```

Choose the executable explicitly when troubleshooting.

## 9.10 Remove unused containers

```bash
docker container ls -a
```

Lists running and stopped containers.

To remove a specific container:

```bash
docker container rm CONTAINER_ID
```

Replace `CONTAINER_ID` with the actual ID.

Do not remove a container until you understand whether it contains any data you need.

The project's one-off commands use `--rm`, so their containers are normally removed automatically after exit.

## 9.11 Search configuration files

From the project directory:

```bash
grep -R "TYPST_FONT_PATHS" .
```

This searches files under the current directory for the specified text.

To search source files for a variable:

```bash
grep -R "work_authorization" --include="*.typ" .
```

This can help locate where a variable is declared and used.

---

# 10. Understanding Fonts

Fonts are important because they influence both appearance and layout.

Changing a font can affect:

- Text width.
- Line wrapping.
- Paragraph height.
- Heading size.
- Number of pages.
- Unicode character support.

A CV that fits on one page with one font may overflow onto a second page with another.

## 10.1 List installed fonts

Inside the container:

```bash
fc-list
```

This lists fonts known to Fontconfig.

To list only family names:

```bash
fc-list : family
```

To search for Lato:

```bash
fc-list : family | grep -i lato
```

## 10.2 Check font matching

```bash
fc-match Lato
```

This shows which font Fontconfig selects for the requested family.

If a requested font is missing, the system may select a fallback.

## 10.3 Ask Typst about fonts

```bash
typst fonts
```

This asks Typst to list fonts it discovers.

If the installed Typst version supports additional options, consult:

```bash
typst fonts --help
```

## 10.4 Why use `TYPST_FONT_PATHS`?

The variable supplies additional or explicit font-search locations to Typst, depending on its version.

For this project:

```text
/work/fonts
/usr/local/share/fonts
/usr/share/fonts
```

These cover the project directory and common system locations.

## 10.5 Font troubleshooting checklist

If the document reports a missing font:

1. Check the exact family name used in the Typst source.
2. Check whether the package containing that font is installed.
3. Run `fc-list : family`.
4. Run `fc-match "Font Family Name"`.
5. Run `typst fonts`.
6. Check the value of `TYPST_FONT_PATHS`.
7. Rebuild the image if you changed the installed system packages.
8. Recompile the document.

Do not immediately change the CV's font. First establish whether the problem is a missing font, an incorrect family name, or a search-path issue.

---

# 11. Building the CV and Cover Letter

## 11.1 First build

From the project directory:

```bash
cd ~/typst-cv
make build
```

This builds the Docker image.

Then check the Typst version:

```bash
docker compose run --rm --entrypoint typst typst --version
```

## 11.2 Compile the CV

```bash
make compile
```

Expected output:

```text
output/mainframe-cv.pdf
```

Confirm the file exists:

```bash
ls -lh output/
```

## 11.3 Compile the cover letter

```bash
make cover-letter
```

Expected output:

```text
output/cover-letter.pdf
```

Confirm both files:

```bash
ls -lh output/
```

## 11.4 Check compilation without retaining a PDF

```bash
make check
make check-cover-letter
```

These targets compile the documents to temporary paths inside the container.

Use them to identify compilation errors without overwriting the main output files.

## 11.5 Start watch mode

```bash
make watch
```

Leave it running while editing the CV.

When you finish, stop watch mode with:

```text
Ctrl+C
```

## 11.6 Validate the resulting PDFs

```bash
make inspect
```

For the cover letter, you can run:

```bash
docker compose run --rm --entrypoint pdfinfo typst output/cover-letter.pdf
```

To extract CV text:

```bash
docker compose run --rm --entrypoint pdftotext typst \
  output/mainframe-cv.pdf -
```

The `-` tells `pdftotext` to write extracted text to standard output.

This can help check whether expected words appear in the PDF.

However, text extraction does not verify visual quality. You should also open the PDFs in a viewer and inspect the page layout.

---

# 12. Understanding PDF Output

A successful Typst command means that Typst produced an output file. It does not guarantee that the CV is ready to send to an employer.

Check the following.

## 12.1 Page size

```bash
pdfinfo output/mainframe-cv.pdf
```

For a typical German job application, A4 is usually an appropriate page size.

Check the reported dimensions.

## 12.2 Page count

Use the `Pages` field in `pdfinfo`.

For example, if the CV is intended to be one page, make sure the output actually contains one page.

Do not reduce font sizes excessively merely to force all content onto one page. Readability and relevant information are more important than an arbitrary page count.

## 12.3 Extracted text

```bash
pdftotext output/mainframe-cv.pdf -
```

Check that:

- Your contact information appears correctly.
- Employer and job titles are spelled correctly.
- Dates are in the correct order.
- Technical skills have not been omitted.
- Special characters display properly.
- Text extraction is reasonably coherent.

Some visually formatted PDFs extract text in an unexpected order. Therefore, use this as a supplementary check rather than the sole measure of quality.

## 12.4 Visual inspection

Open the PDF in a viewer and check:

- Margins.
- Line spacing.
- Font sizes.
- Section hierarchy.
- Bullet alignment.
- Icons.
- Page breaks.
- Empty space.
- Text that is too close to page edges.
- Any content that overflows or overlaps.

For a professional CV, consistency is more important than excessive decoration.

## 12.5 Application tracking system compatibility

A visually attractive CV can still be difficult for some applicant tracking systems to parse.

For better compatibility:

- Use meaningful section headings.
- Keep important information as actual text rather than images.
- Avoid putting essential contact details only inside decorative graphics.
- Use conventional date and job-title formats.
- Test the extracted text.
- Keep the layout readable even if a system ignores some styling.

---

# 13. File Permissions and User IDs

This is an important Docker concept, especially when working on Linux.

## 13.1 Why permissions matter

A Docker container can write files to a host bind mount.

The host operating system still applies its normal filesystem permissions.

For example, a PDF created inside the container may appear on the host as a file owned by a numeric user ID.

If the process does not have permission to write to the mounted directory, compilation can fail.

## 13.2 Numeric user IDs

Linux identifies users using numeric UIDs and groups using numeric GIDs.

The Dockerfile creates a user with UID 1000:

```dockerfile
useradd --create-home --uid 1000 --shell /bin/bash typst
```

This is not guaranteed to match the current host user's UID.

Check the host identity with:

```bash
id
```

Example output might contain:

```text
uid=103631(...) gid=4224(...)
```

The numbers are illustrative of a possible environment. Use the actual values returned by your machine.

## 13.3 Why not always use `--user`?

A common approach is to start a container using the host's UID and GID.

However, this project's earlier attempt to use a host UID/GID override was rejected by the Docker runtime.

Therefore, the current Makefile does not include a `--user` override.

Do not add one blindly. First determine which Docker runtime and user-mapping rules are active.

## 13.4 Inspect permissions

On the host:

```bash
ls -ld .
ls -ld output
ls -l output
id
```

Inside the container:

```bash
id
ls -ld /work
ls -ld /work/output
```

Compare the results to understand the ownership and permissions involved.

## 13.5 Practical troubleshooting

If compilation fails with a permission error:

1. Confirm that the output directory exists.
2. Inspect its owner, group, and mode.
3. Check the effective user inside the container.
4. Check whether `/work` is a bind mount.
5. Review the Docker runtime's user-mapping configuration.
6. Select a solution appropriate to the environment.

Do not solve every permission issue with `chmod -R 777`. That grants broad permissions unnecessarily and can create security problems.

---

# 14. Troubleshooting

## Problem 1: Docker command not found

Check:

```bash
docker --version
```

If the command is unavailable, install or enable Docker using the appropriate instructions for your operating system and Docker distribution.

## Problem 2: Compose file not found

Check your current directory:

```bash
pwd
ls -la
```

Run Compose from the directory containing `compose.yaml`, or explicitly supply the configuration file:

```bash
docker compose -f /path/to/typst-cv/compose.yaml config
```

Replace the example path with the real path.

## Problem 3: Docker build fails while copying Typst

Inspect the first-stage image and confirm the source executable path.

The Dockerfile currently expects:

```dockerfile
COPY --from=typst_binary /bin/typst /usr/local/bin/typst
```

If the upstream image changes, the source path may change too.

Do not guess a replacement path. Inspect the actual image or its documentation first.

## Problem 4: Typst is not found

Run:

```bash
docker compose run --rm --entrypoint bash typst
```

Then:

```bash
command -v typst
typst --version
```

The executable should normally be available at:

```text
/usr/local/bin/typst
```

If it is missing, rebuild the image and inspect the Dockerfile's `COPY` instruction.

## Problem 5: A font is missing

Run:

```bash
make fonts
```

Then investigate the exact family name and the configured font directories.

If you change the Dockerfile to install a new system font package, rebuild:

```bash
make build
```

## Problem 6: The CV source cannot be found

Run:

```bash
docker compose run --rm --entrypoint bash typst
```

Inside the container:

```bash
pwd
ls -la /work
```

Confirm that `main.typ` exists at `/work/main.typ`.

If not, check the host directory and the Compose volume mapping.

## Problem 7: The output directory does not exist

Run:

```bash
mkdir -p output
```

The `compile` and `cover-letter` Makefile targets already create this directory.

## Problem 8: PDF permission denied

Check the host directory and container user:

```bash
id
ls -ld output
```

Review the UID/GID mismatch and the bind mount before changing permissions.

## Problem 9: Typst reports a syntax error

Run:

```bash
make check
```

Read the reported file and line number.

Common causes include:

- Missing closing parentheses or braces.
- Incorrect import paths.
- Misspelled variable names.
- Invalid function arguments.
- Incorrect string syntax.
- Variables declared after they are used.
- A template helper that expects different arguments.

Correct the source file and compile again.

## Problem 10: The generated CV looks different

Check whether you changed:

- Typst version.
- Font packages.
- Font family names.
- Font search paths.
- Template files.
- Page dimensions.
- Margins.
- Text size.
- Imported resources.

A change in any of these can affect layout.

## Problem 11: `make` reports “missing separator”

Makefile commands usually require a tab at the beginning of each recipe line.

Incorrect:

```makefile
compile:
    mkdir -p output
```

The indentation shown may be spaces.

Correct:

```makefile
compile:
	mkdir -p output
```

The line before `mkdir` must contain a real tab.

## Problem 12: A Docker command runs the wrong program

Inspect the image's configured entrypoint and command.

Use an explicit entrypoint override when appropriate:

```bash
docker compose run --rm --entrypoint bash typst
```

or:

```bash
docker compose run --rm --entrypoint typst typst --version
```

## Problem 13: Changes to the Dockerfile have no effect

Rebuild the image:

```bash
make build
```

Source files mounted from the host generally do not require rebuilding the image. Changes to installed packages or Dockerfile instructions usually do.

---

# 15. Daily Development Workflow

Use the following workflow when updating your application documents.

## Step 1: Enter the project

```bash
cd ~/typst-cv
```

## Step 2: Inspect the project

```bash
pwd
ls -la
```

## Step 3: Rebuild only when necessary

```bash
make build
```

Use this after changing the Dockerfile or installed dependencies.

## Step 4: Validate the source

```bash
make check
make check-cover-letter
```

Fix any compilation errors before producing the final PDFs.

## Step 5: Compile the CV

```bash
make compile
```

## Step 6: Compile the cover letter

```bash
make cover-letter
```

## Step 7: Inspect the files

```bash
ls -lh output/
```

## Step 8: Check PDF metadata

```bash
make inspect
```

## Step 9: Review the extracted text

```bash
docker compose run --rm --entrypoint pdftotext typst \
  output/mainframe-cv.pdf -
```

## Step 10: Open and visually inspect both PDFs

Check spelling, formatting, page count, alignment, and whether the documents contain the intended information.

## Step 11: Clean generated PDFs when required

```bash
make clean
```

Only run this when you are comfortable removing all PDFs that match the pattern in `output/`.

---

# 16. Software Engineering Lessons

This project illustrates several useful software engineering principles.

## 16.1 Separation of concerns

Each file has a distinct responsibility:

- Dockerfile: image construction.
- Compose file: runtime configuration.
- Makefile: common command shortcuts.
- Typst source: document content and layout.
- Configuration file: structured data, if used by the source.
- Output directory: generated documents.

This separation makes it easier to identify where a problem belongs.

For example, a missing system font is likely an environment issue, whereas an incorrectly declared Typst variable is a source-code issue.

## 16.2 Reproducibility

Keeping the build environment described in files is better than relying on undocumented manual setup.

Another developer can inspect the Dockerfile and Compose configuration to understand how the environment is assembled.

For stronger reproducibility, pin the Typst image to a verified version or immutable digest and document the chosen version.

## 16.3 Automation

The Makefile converts long commands into consistent, reusable targets.

Instead of manually typing the full Docker command each time, run:

```bash
make compile
```

Automation reduces repeated work and transcription errors.

## 16.4 Validation before delivery

A reliable workflow checks the source before producing final artifacts.

For this project:

```bash
make check
make check-cover-letter
make compile
make cover-letter
```

These commands provide a basic validation sequence.

Visual review remains a separate required step.

## 16.5 Avoid unnecessary rebuilding

The source files are bind-mounted into the container.

Therefore, editing `main.typ` does not normally require rebuilding the Docker image.

A practical rule is:

| Change | Rebuild image? |
|---|---|
| Edit CV text | No |
| Edit cover-letter text | No |
| Change Typst layout source | Usually no |
| Add or edit a mounted SVG icon | Usually no |
| Change Dockerfile packages | Yes |
| Change the Typst executable source image | Yes |
| Change system font packages | Yes |
| Change runtime environment variables in Compose | Usually no image rebuild, but start a new container |

## 16.6 Keep troubleshooting evidence-based

When something fails, inspect the actual state rather than immediately changing configuration.

For example:

- Use `docker image inspect` to inspect image metadata.
- Use `typst --version` to verify the executable.
- Use `fc-list` to inspect fonts.
- Use `id` to inspect the effective user.
- Use `ls -la` to inspect file visibility and permissions.
- Read Typst diagnostics before editing source code.

This approach reduces trial-and-error changes.

---

# 17. Security and Maintenance

Although this project generates documents rather than hosting a public service, good security practices still matter.

## 17.1 Avoid unnecessary privileges

Do not run containers as root without a reason.

Review which user runs Typst and whether that user can write to the mounted output directory.

## 17.2 Do not put secrets into the image

A CV project may contain private contact information.

Avoid adding credentials, access tokens, or unrelated personal documents to the Docker build context.

Use `.dockerignore` to exclude unnecessary files, but remember that a bind mount exposes the mounted host directory to the container.

## 17.3 Be careful with the mounted directory

This mapping:

```yaml
volumes:
  - ./:/work
```

makes the project directory available inside the container.

The container can access files in that mounted directory subject to filesystem permissions.

Only run images and commands you trust.

## 17.4 Pin versions for stable builds

The image reference:

```text
ghcr.io/typst/typst:latest
```

can change over time.

A newer version may have different behavior or produce a different layout.

For a stable production workflow:

1. Select a verified Typst release.
2. Use a version-specific image reference.
3. Record the installed version.
4. Rebuild and validate when updating.
5. Consider pinning the image by digest.
6. Keep a record of the fonts used.

The exact version should be chosen after checking which version is currently available and compatible with your template.

## 17.5 Keep a clean project

Generated PDFs are output artifacts, not source code.

Keeping them separate makes it easier to understand what must be maintained and what can be regenerated.

The same principle applies to temporary files, caches, and debugging logs.

---

# 18. Final Checklist

Use this checklist before considering the environment ready.

## Environment

- [ ] Docker is installed and working.
- [ ] Docker Compose is available.
- [ ] The Docker image builds successfully.
- [ ] Typst is available inside the container.
- [ ] The Typst version is recorded.
- [ ] Required fonts are installed and discoverable.

## Project files

- [ ] `Dockerfile` is present.
- [ ] `compose.yaml` is present.
- [ ] `.dockerignore` is present.
- [ ] `Makefile` is present.
- [ ] `main.typ` is present.
- [ ] `cover-letter.typ` is present.
- [ ] Imported template files are available.
- [ ] Required icons and other assets are present.
- [ ] The configuration file is actually loaded if the project depends on it.

## Compilation

- [ ] `make build` succeeds.
- [ ] `make check` succeeds.
- [ ] `make check-cover-letter` succeeds.
- [ ] `make compile` produces the CV PDF.
- [ ] `make cover-letter` produces the cover letter PDF.
- [ ] `make inspect` reports sensible PDF metadata.
- [ ] The output files are readable from the host.

## Document quality

- [ ] The CV contains correct contact information.
- [ ] The CV's experience and skills are accurate.
- [ ] The cover letter matches the target job.
- [ ] Dates and job titles are correct.
- [ ] Fonts render correctly.
- [ ] No text is clipped or overlapping.
- [ ] Page breaks and margins look professional.
- [ ] PDF text extraction is reasonably coherent.
- [ ] Both PDFs have been visually reviewed.

---

## Quick Reference

| Task | Command |
|---|---|
| Build Docker image | `make build` |
| Open container shell | `make shell` |
| Check available fonts | `make fonts` |
| Validate CV source | `make check` |
| Compile CV | `make compile` |
| Watch and recompile CV | `make watch` |
| Inspect CV PDF | `make inspect` |
| Compile cover letter | `make cover-letter` |
| Validate cover-letter source | `make check-cover-letter` |
| Remove generated PDFs | `make clean` |
| Check Typst version | `docker compose run --rm --entrypoint typst typst --version` |
| List project files | `ls -la` |
| Inspect output files | `ls -lh output/` |
| Inspect host identity | `id` |
| Inspect Docker images | `docker image ls` |
| Inspect PDF text | `docker compose run --rm --entrypoint pdftotext typst output/mainframe-cv.pdf -` |

## Conclusion

The main purpose of this project is to make CV and cover-letter generation repeatable, maintainable, and straightforward.

Docker defines the software environment, Compose configures the container, Typst generates the documents, and Make provides convenient commands.

Once the environment is working, most day-to-day changes should involve editing the Typst source and recompiling the PDFs—not rebuilding the Docker image.

The final step is always to inspect the generated documents and verify that the content, formatting, and output files are correct before sending them to an employer.
