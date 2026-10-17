# Give a project a docs site

How to give a CircleCI Labs project a docs site that matches the hub, and list it on the hub. The reference is the [machine runner swarm](https://github.com/CircleCI-Labs/machine-runner-swarm) site, in its `site/` folder.

## 1. What every Labs site must have

- The same theme: Hugo extended 0.168.0 and Hextra v0.13.0, with `assets/css/custom.css` and the fonts in `static/fonts/`.
- The Labs banner: "Not an official CircleCI product and not supported by CircleCI support" (`layouts/_partials/custom/banner.html`).
- A header with the Labs icon linking to `https://circleci-labs.github.io/`, and the project name linking to the project home (`layouts/_partials/navbar-title.html`).
- The footer (`layouts/_partials/custom/footer.html`), with the repository, the support notice and the license.
- Copy buttons on code blocks: `params.highlight.copy.enable: true` in `hugo.yaml`.
- A repository README that links to the site.

## 2. Create the site

Copy these from the reference `site/` folder into `site/` of the new repository:

```bash
REFERENCE=~/src/machine-runner-swarm
NEW_REPO=~/src/my-project
mkdir -p "$NEW_REPO/site"
cp -R "$REFERENCE"/site/{assets,layouts,static,hugo.yaml,go.mod,go.sum,.gitignore} "$NEW_REPO/site/"
```

Then change:

1. `hugo.yaml`: `baseURL` (`https://circleci-labs.github.io/<REPOSITORY>/`), `title`, `params.description`, `params.home`, the menus, and the `GitHub` menu URL. The footer and the repository links read that URL.
2. `go.mod`: the module name. Keep the Hextra version.
3. `layouts/_partials/custom/banner.html` and `footer.html`: the maturity wording and the footer links.
4. `static/site.webmanifest`: the names.
5. Delete what the project does not use, such as the Mermaid render hook.

Write pages under `site/content/`. The reference builds its content from the repository Markdown with `stage.sh` and `nav.txt`. That is specific to it, so skip them unless you want the same.

The Labs `custom.css`, the fonts and the icon are copies. A style change is made by hand in each repository.

## 3. Publish

**Simple path (the hub's way).** Set `publishDir: ../docs` in `site/hugo.yaml`, copy `build.sh` from this repository into `site/` (change its `docs/` paths), and run:

```bash
site/build.sh
git add site docs && git commit -m "docs: add the docs site" && git push
```

GitHub Pages serves only `/` or `/docs`, so use this path only if the repository has no other files in `docs/`. If it does, use the CI path.

**CI path (machine runner swarm).** CircleCI builds and pushes `gh-pages` on every merge to `main`.

1. Copy `site/publish.sh` (and `check.sh`, `preview.sh` if you want link checks and PR previews). Change the `baseURL` prefix and the context name.
2. Copy the `docs-site` command, the `docs-site-build` and `docs-site-publish` jobs, and the `docs-site` workflow from `.circleci/continue.yml`. The workflow runs on `main` only.
3. Create a context with `GITHUB_TOKEN`, a fine-grained token with Contents: write on this repository. Set the context name in the workflow. Without the token the job builds and publishes nothing.
4. The first run creates `gh-pages`. Then turn on Pages with `gh-pages` as the source.

Validate the CircleCI config after each edit: `circleci config validate`.

## 4. Turn on GitHub Pages

Repository, Settings, Pages, Build and deployment, Source: Deploy from a branch. Pick `main` and `/docs` (simple path), or `gh-pages` and `/ (root)` (CI path).

The same with the CLI (use `gh-pages` and `/` for the CI path):

```bash
REPOSITORY=my-project
echo '{"source":{"branch":"main","path":"/docs"}}' | gh api -X POST "repos/CircleCI-Labs/$REPOSITORY/pages" --input -
```

If Pages already exists, use `-X PUT` instead of `-X POST`. Send the JSON body as shown: with `-f "source[path]=/docs"` the API ignores the path and serves `/`.

## 5. Add the project to the hub

1. Add an entry to `data/projects.yaml` (fields as in the README, "Add a project"). List only public projects with a live site.
2. Run `./build.sh`.
3. Commit `data/` and `docs/`, and push to `main`.

## 6. Checklist before you announce it

- [ ] The site loads at `https://circleci-labs.github.io/<REPOSITORY>/` in light and dark mode.
- [ ] The banner shows, and the Labs icon links to the hub.
- [ ] The project name links to the project home.
- [ ] Code blocks have copy buttons.
- [ ] Repository, footer and menu links work.
- [ ] The README links to the site.
- [ ] The hub card shows, and its links work.
- [ ] No customer names, tokens or internal URLs on any page.
