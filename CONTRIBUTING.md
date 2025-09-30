Thank you for considering contributing to the Animals In Motion project!
We welcome contributions in various forms, including bug reports, requests for
content improvement, as well as new tutorials or case studies.

## Setting up the development environment

Begin by cloning the repository and navigating to its root directory:

```bash
git clone https://github.com/neuroinformatics-unit/course-animals-in-motion.git
cd course-animals-in-motion
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

Book chapters are written primarily as [Quarto Markdown](https://quarto.org/docs/authoring/markdown-basics.html) files (`.qmd`).
These can contain a mix of narrative and interactive content, such as code exercises. See [Quarto computations > Using Python](https://quarto.org/docs/computations/python.html) to learn more about executable code blocks.

We recommend using the [Quarto VSCode extension](https://marketplace.visualstudio.com/items?itemName=quarto.quarto) for authoring and previewing content.

Alternatively, you may also use JupyterLab, with Jupyter Notebooks (`.ipynb`) as source files—see [Quarto tools > JupyterLab](https://quarto.org/docs/tools/jupyter-lab.html) for more information.

The chapter source files reside in the `book/` directory and have to be linked in the `book/_quarto.yml` file for them to show up.
See [Book Crossrefs](https://quarto.org/docs/books/book-crossrefs.html) on how to reference other chapters.

Bibliographical references should be added to the `book/references.bib` file in BibTeX format.
See [Quarto authoring > Citations](https://quarto.org/docs/manuscripts/authoring/vscode.html#citations) for more information.

In general, [cross-referencing objects](https://quarto.org/docs/manuscripts/authoring/vscode.html#cross-ref) (e.g. figures, tables, chapters, equations, citations, etc.) should be done using the `@ref` syntax, e.g. `See @fig-overview for more details`.

### Adding answers to exercises

This book is configured to be rendered with or without answers to exercises,
using [Quarto profiles](https://quarto.org/docs/projects/profiles.html).

- The `_quarto.yml` file defines the "default" profile for the book, which
  does not show the answers to exercises.
- The `_quarto-answers.yml` file defines the "answers" profile, which
  is identical to the "default" profile, but also includes solutions
  to code exercises.

To add answers to code exercises, please enclose them in a block of the following form:

```{.bash}
::: {.content-visible when-profile="answers"}

::: {.callout-tip title="Click to reveal the answers" collapse="true"}

Write your solution here.

:::

:::
```

Then you can control whether the answers are shown or not by passing the appropriate Quarto profile to the `quarto render` command:

```bash
quarto render book --execute --profile default  # equivalent to no profile
quarto render book --execute --profile answers
```

You can achieve the same effect by setting the `QUARTO_PROFILE` environment variable before rendering the book:

```bash
export QUARTO_PROFILE=answers
quarto render book --execute
```

In general, it's most convenient to show the answers while you are developing the content,
and then hide them to preview the book as a student would see it.

See the [@sec-versioning] for more information on how to create releases with or without answers.

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

## Versioning and releasing {#sec-versioning}

We use [Calendar Versioning (CalVer)](https://calver.org/) and specifically the `YYYY.0M` scheme (e.g. `2025.08` for August 2025).

To create a new release, first update the `book/index.qmd` file. Specifically, add two rows like the following to the "Versions" table:

```md
| `v2025.08` | version used for the inaugural workshop in August 2025 |
| `v2025.08-answers` | same as `v2025.08` but with answers to exercises |
```

You also need to create a new tag in the `vYYYY.0M` format (e.g. `v2025.08`)
and push it to the repository. Don't forget the `v` prefix for the tag name!

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

- **linting**: running the [pre-commit hooks](#pre-commit-hooks);
- **build**: rendering the Quarto book with and without answers, and uploading the rendered artifacts;
- **deploy**: deploying the book artifact(s) to the `gh-pages` branch (only for pushes to the `main` branch and releases).

Each release version is deployed to a folder in the `gh-pages` branch, with the same name as the release tag (e.g., `v2025.08`). This is accompanied by a `vYYYY.0M-answers` folder containing a version of the book with answers to exercises (e.g. `v2025.08-answers`).

There's also a special folder called `dev` that is deployed for pushes to the `main` branch. This folder always includes the answers to exercises.
