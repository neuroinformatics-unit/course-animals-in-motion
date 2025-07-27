Thank you for considering contributing to the Animals In Motion project!
We welcome contributions in various forms, including bug reports, requests for
content improvement, as well as new tutorials or case studies.

## Setting up the development environment

Begin by cloning the repository and navigating to its root directory:

```bash
git clone https://github.com/neuroinformatics-unit/animals-in-motion.git
cd animals-in-motion
```

We use `conda` to manage dependencies.
First, create a development environment using the `environment-dev.yaml` file, and activate it:

```bash
conda env create -n animals-in-motion-dev -f environment-dev.yaml
conda activate animals-in-motion-dev
```

To enable the [pre-commit hooks](#pre-commit-hooks), run the following command once:

```bash
pre-commit install
```

This is a [Quarto book](https://quarto.org/docs/books/index.html) project, with its source code located in the `book/` directory.
We refer you to the [Quarto documentation](https://quarto.org/docs/books/index.html) for more information on how books are structured and configured.

To render/preview the book locally, you'll need the [Quarto CLI](https://quarto.org/docs/get-started/) installed,
as well as the [VSCode Quarto extension](https://quarto.org/docs/get-started/hello/vscode.html)

You will also need to make sure that the `QUARTO_PYTHON` environment variable is set to the path of the `python` executable in the development `conda` environment.
This guarantees that the Quarto CLI will use the correct Python interpreter when rendering the book.

```bash
export QUARTO_PYTHON=$(which python)
```

Then, you can render the book using:

```bash
quarto render book
# or if you want to run executable code blocks before rendering to html
quarto render book --execute
```

You can view the rendered book by opening the `book/_book/index.html` file in your browser.

## Authoring content

Book chapters are written either as [Quarto Markdown](https://quarto.org/docs/authoring/markdown-basics.html) files (`.qmd`) or as Jupyter Notebooks (`.ipynb`). The latter are especially convenient for interactive content, such as code exercises, but note that both types of documents may contain executable code blocks (see [Quarto computations > Using Python](https://quarto.org/docs/computations/python.html)).

The chapter source files reside in the `book/` directory and have to be linked in the `book/_quarto.yml` file for them to show up.
See [Book Crossrefs](https://quarto.org/docs/books/book-crossrefs.html) on how to reference other chapters.

Bibliographical references should be added to the `book/references.bib` file in BibTeX format.
See [Quarto authoring > Citations](https://quarto.org/docs/manuscripts/authoring/vscode.html#citations) for more information.

In general, [cross-referencing objects](https://quarto.org/docs/manuscripts/authoring/vscode.html#cross-ref) (e.g. figures, tables, chapters, equations, citations, etc.) should be done using the `@ref` syntax, e.g. `See @fig-overview for more details`.

## Pre-commit hooks

We use [pre-commit](https://pre-commit.com/) to run checks on the codebase before committing.

Current hooks include:

- [codespell](https://github.com/codespell-project/codespell) for catching common spelling mistakes.
- [markdownlint](https://github.com/igorshubovych/markdownlint-cli) for (Quarto) Markdown linting and formatting.
- [ruff](https://github.com/astral-sh/ruff) for code linting and formatting.

These will prevent code from being committed if any of these hooks fail.
To run all the hooks before committing:

```sh
pre-commit run  # for staged files
pre-commit run -a  # for all files in the repository
```

## Versioning and releasing

We use [Calendar Versioning (CalVer)](https://calver.org/) and specifically the `YYYY.0M` scheme (e.g. `2025.08` for August 2025).

To create a new release, first update the `book/index.qmd` file. Specifically, add an entry like the following under the "Versions" section:

```md
- [v2025.08](https://animals-in-motion.neuroinformatics.dev/v2025.08/): Version used for the inaugural workshop in August 2025
```

You also need to create a new tag with the format `vYYYY.0M`, and push it to the repository. Don't forget the `v` prefix for the tag name!

For example:

```bash
git tag v2025.08
git push origin --tags
```

## Continuous integration (CI)

The CI workflow is defined in the `.github/workflows/build_and_deploy.yaml` file and can be triggered by:

- Pushes to the `main` branch
- Pull requests
- Releases, i.e. tags starting with `v` (e.g., `v2025.08`)
- Manual dispatches

The workflow is built using [GitHub actions](https://docs.github.com/en/actions) and includes three jobs:

- **linting**: running the [pre-commit hooks](#pre-commit-hooks)
- **build**: rendering the Quarto book and uploading an artifact
- **deploy**: deploying the book artifact to the `gh-pages` branch (only for pushes to the `main` branch and releases)

Each release version is deployed to a folder in the `gh-pages` branch, with the same name as the release tag (e.g., `v2025.08`).
There's also a special folder called `dev` that is deployed for pushes to the `main` branch.

The contents of the latest release are also copied to the `latest/` folder, where the home page is redirected to.

Links to previous versions can be added to the book's `index.qmd` file, under the "View other versions" section. Note that these links will only work on the deployed version of the book, not on the local version.

### Previewing the book in CI

We use [artifact.ci](https://artifact.ci/) to preview the book that is rendered as part of our CI workflow. This is useful to check that the book renders correctly before merging a PR. To do so:

1. Go to the "Checks" tab in the GitHub PR.
2. Click on the "Build and Deploy Quarto Book" section on the left.
3. If the "Build Quarto book" action is successful, a summary section will appear under the block diagram with a link to preview the built documentation.
4. Click on the link and wait for the files to be uploaded (it may take a while the first time). You may be asked to sign in to GitHub.
5. Once the upload is complete, look for `book/_book/index.html` under the "Detected Entrypoints" section.
