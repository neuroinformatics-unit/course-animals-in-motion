# AGENTS.md

This file provides guidance to AI coding agents working with code in this repository.

## What this is

A [Quarto book](https://quarto.org/docs/books/index.html) containing the course materials for "Animals In Motion", a workshop on animal pose estimation and motion analysis. Source lives in `book/`, chapters are `.qmd` files (Quarto Markdown mixing narrative and executable Python code cells), rendered to HTML in `book/_book/`.

## Key reference files

- **`book/prerequisites.qmd`**: course prerequisites—assumed knowledge, hardware requirements, software environments (SLEAP, movement, BORIS), and example datasets. Read this to understand the course audience and the tools/data the chapters build on.
- **`book/contributing.qmd`** (includes `CONTRIBUTING.md`): full contributor guide covering dev environment setup, content authoring conventions, the exercise/solution pattern, pre-commit hooks, versioning, and the CI workflow. Read this before making any structural or content changes to the book.

## Commands

Render the book (must set `QUARTO_PYTHON` first so Quarto uses this conda env's interpreter):

```bash
export QUARTO_PYTHON=$(which python)
quarto render book
```

Code cells execute on render and are cached (`execute: cache: true` in `book/_quarto.yml`), so subsequent renders only re-run modified cells. Force a full re-execution (e.g. after changing data or an untracked dependency) with:

```bash
quarto render book --cache-refresh
```

View the result by opening `book/_book/index.html`.

For live-reloading during development, use `quarto preview` instead—the book rebuilds and refreshes in the browser automatically as you save changes:

```bash
quarto preview book
```

Lint/format (pre-commit runs codespell, markdownlint, ruff):

```bash
pre-commit run     # staged files
pre-commit run -a  # all files
```
