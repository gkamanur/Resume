#let work_authorization = "Authorized to work in Germany"
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
