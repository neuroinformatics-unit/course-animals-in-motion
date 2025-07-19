# Animals In Motion

This repository contains the course materials for ["Animals In Motion"](https://neuroinformatics.dev/open-software-week/animals-in-motion.html),
a workshop developed by the [Neuroinformatics Unit (NIU)](https://neuroinformatics.dev), as part of the [Open Software Week](https://neuroinformatics.dev/open-software-week/).

## Build the book

This is a [Quarto book](https://quarto.org/docs/books/index.html).
To build it locally, you need to have [Quarto CLI](https://quarto.org/docs/get-started/) installed.
We also recommend using [uv](https://docs.astral.sh/uv/) to manage the dependencies.

First, clone the repository and navigate to it's root directory:

```bash
git clone https://github.com/neuroinformatics-unit/animals-in-motion.git
cd animals-in-motion
```

Then, install the dependencies with `uv` and render the book:

```bash
uv sync --locked --all-extras
uv run quarto render book
```

## Deployment

The book is deployed via [Read the Docs](https://animals-in-motion.readthedocs.io/en/latest/) to [animals-in-motion.readthedocs.io](https://animals-in-motion.readthedocs.io).


## License

This repository is licensed under [Creative Commons Attribution 4.0 International (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/).