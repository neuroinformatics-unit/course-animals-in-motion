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

### Adding exercises and their solutions

Exercises and their solutions are authored inline in the chapter source, but at
render time each solution is moved into a per-chapter "Solutions" section by the
`book/collect-solutions.lua` filter (registered in `book/_quarto.yml`). The book
is rendered as a single build — there are no longer separate "with/without
answers" profiles.

Write each exercise prompt as an `.exercise-block` div:

```{.markdown}
::: {.exercise-block}
Describe the task here.
:::
```

Immediately after it, write the solution as an `.exercise-solution` div:

```{.markdown}
::: {.exercise-solution}
Write your solution here (prose and `{python}` code cells).
:::
```

You don't write the collapsible callout yourself — the filter builds it. It
numbers exercises and solutions per chapter (Exercise 1 ↔ Solution 1, and so on),
moves each solution to a "Solutions" section at the end of the chapter, wraps the
answer in a collapsed callout titled "Exercise N" to match its exercise, and
prepends a "↩ back to exercise" link at the top of the solution body (so it
appears only once the solution is expanded). There is deliberately no forward link
from an exercise to its solution, to discourage jumping straight to the answer.
Solution code cells execute in the chapter's kernel (before the filter runs), so
they can use variables and imports defined earlier in the chapter.

Each `.exercise-block` must be followed by exactly one `.exercise-solution`, in
order — this keeps the numbering aligned. If they get out of sync, the render
fails with an assertion error.

Do not use the reserved Quarto classes `.exercise` or `.solution` for these divs.

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
- **build**: rendering the Quarto book (a single build; solutions are moved to a per-chapter "Solutions" section by `book/collect-solutions.lua`) and uploading the rendered artifact;
- **deploy**: deploying the book artifact(s) to the `gh-pages` branch (only for pushes to the `main` branch and releases).

Each release version is deployed to a folder in the `gh-pages` branch, with the same name as the release tag (e.g., `v2025.08`). Solutions are included in that single build, in each chapter's "Solutions" section.

There's also a special folder called `dev` that is deployed for pushes to the `main` branch.

Versions up to and including `v2025.10` were additionally deployed to a `vYYYY.0M-answers` folder (a separate build with answers). Those folders remain online as historical archives; new versions no longer produce them.
