# Animals In Motion

This repository contains the course materials for ["Animals In Motion"](https://neuroinformatics.dev/open-software-week/animals-in-motion.html),
a workshop developed by the [Neuroinformatics Unit (NIU)](https://neuroinformatics.dev), as part of the [Open Software Week](https://neuroinformatics.dev/open-software-week/).

## Build the book

This is a [Quarto book](https://quarto.org/docs/books/index.html). To build it locally, you need to have [Quarto CLI](https://quarto.org/docs/get-started/) installed.
We also recommend using [uv](https://docs.astral.sh/uv/) to manage the dependencies.

First, clone the repository and navigate to it's root directory:

```bash
git clone https://github.com/neuroinformatics-unit/animals-in-motion.git
cd animals-in-motion
```

Then, install the dependencies with `uv` and render the book:

```bash
uv sync
uv run quarto render
```

## Deployment

The book is deployed in two places for now:

- [GitHub Pages](https://neuroinformatics.dev/animals-in-motion/). This deployment is handled by the [render_and_deploy.yaml](.github/workflows/render_and_deploy.yaml) workflow and corresponds to the `main` branch.
- [Read the Docs](https://animals-in-motion.readthedocs.io/en/latest/). This is configured in the [.readthedocs.yaml](.readthedocs.yaml) file and has the advantage of enabling multiple versions of the book, e.g. `latest` and `v0.1.0`.



## License

This repository is licensed under [Creative Commons Attribution 4.0 International (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/).