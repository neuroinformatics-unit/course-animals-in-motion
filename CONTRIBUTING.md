# Contributing to Animals In Motion

Thank you for considering contributing to the Animals In Motion project! We welcome contributions in various forms, including bug reports, feature requests, and code contributions.

## Getting Started

Begin by cloning the repository and navigating to its root directory:

```bash
git clone https://github.com/neuroinformatics-unit/animals-in-motion.git
cd animals-in-motion
```

We use [uv](https://docs.astral.sh/uv/) to manage dependencies. Ensure you have `uv` installed, then run:

```bash
uv sync --locked --all-extras
```

This is a [Quarto book](https://quarto.org/docs/books/index.html), project. The source code for the book can be found within the
`book/` directory. We refer you to the [Quarto documentation](https://quarto.org/docs/books/index.html) for more information on how to edit the book.

To build the Quarto book locally, ensure you have the [Quarto CLI](https://quarto.org/docs/get-started/) installed. Then, render the book using:

```bash
uv run quarto render book
```

You can view the rendered book by opening the `book/_book/index.html` file in your browser.


## Pre-commit hooks

We use [pre-commit](https://pre-commit.com/) to run checks on the codebase before committing.

To enable the pre-commit hooks, run the following command once:

```bash
uv run pre-commit install
```
Current hooks include:
- [codespell](https://github.com/codespell-project/codespell) for catching common spelling mistakes
- [ruff](https://github.com/astral-sh/ruff) for code linting and formatting
- [uv-pre-commit](https://github.com/astral-sh/uv-pre-commit) for auto-updating the `uv.lock` file.

These will prevent code from being committed if any of these hooks fail.
To run all the hooks before committing:

```sh
uv run pre-commit run  # for staged files
uv run pre-commit run -a  # for all files in the repository
```

## Versioning and releasing

We use [Calendar Versioning (CalVer)](https://calver.org/) and specifically the `YYYY.0M` scheme (e.g. `2025.08` for August 2025).

To create a new release, first update the `book/index.qmd` file. Specifically, add an entry like the following under the "View other versions" section:
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
The CI workflow is defined in the [build_and_deploy.yaml](.github/workflows/build_and_deploy.yaml) file and can be triggered by:

- Pushes to the `main` branch
- Pull requests
- Releases, i.e. tags starting with `v` (e.g., `v2025.08`)
- Manual dispatches

The workflow is built using [GitHub actions](https://docs.github.com/en/actions) and includes three jobs:

- **linting**: running the [pre-commit hooks](#pre-commit-hooks)
- **build**: rendering the Quarto book and uploading an artifact
- **deploy**: deploying the book artifact to the `gh-pages` branch (only for pushes to the `main` branch and releases)

Each release version is deployed to a folder in the `gh-pages` branch, with the same name as the release tag (e.g., `v2025.08/`).
There's also a special folder called `dev/` that is deployed for pushes to the `main` branch.

The contents of the latest release are also copied to the `latest/` folder, where the home page is redirected to.

Links to previous versions can be added to the book's `index.qmd` file, under the "View other versions" section. Note that these links will only work on the deployed version of the book, not on the local version.

### Previewing the book in CI
We use [artifact.ci](https://artifact.ci/) to preview the book that is rendered as part of our CI workflow. This is useful to check that the book renders correctly before merging a PR.

To do so:

1. Go to the "Checks" tab in the GitHub PR.
2. Click on the "Build and Deploy Quarto Book" section on the left.
3. If the "Build Quarto book" action is successful, a summary section will appear under the block diagram with a link to preview the built documentation.
4. Click on the link and wait for the files to be uploaded (it may take a while the first time). You may be asked to sign in to GitHub.
5. Once the upload is complete, look for `book/_book/html/index.html` under the "Detected Entrypoints" section.
