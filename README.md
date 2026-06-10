# SFPI Compiler Explorer Container

This repository is for demonstrating **SFPI support in Compiler Explorer** using containers.

It is based on:

- <https://github.com/mert-kurttutan/infra/tree/sfpi-support>
- <https://github.com/mert-kurttutan/compiler-explorer/tree/tenstorrent-support>

This repo is intended to hold the container setup that packages the SFPI-enabled Compiler Explorer environment for local demos and evaluation.

Planned contents:

- container definitions
- Compiler Explorer runtime configuration
- local run instructions
- basic validation steps for SFPI support

## Podman

Build:

```bash
podman build -t sfpi-ce-demo .
```

Run:

```bash
podman run --rm -p 10240:10240 sfpi-ce-demo
```

Then open `http://localhost:10240`.
