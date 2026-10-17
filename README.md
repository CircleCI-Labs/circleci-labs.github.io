# CircleCI Labs home site

Source of <https://circleci-labs.github.io/>, the home page of [CircleCI Labs](https://github.com/CircleCI-Labs). It lists the Labs projects and states the support model.

CircleCI Labs is not an official CircleCI product and is not supported by CircleCI Support.

The site is Hugo with the [Hextra](https://github.com/imfing/hextra) theme (v0.13.0, pinned in `go.mod`). It uses the same theme as the [machine runner swarm docs](https://circleci-labs.github.io/machine-runner-swarm/), so the projects look like one website.

## Publish a change

1. Edit the content (see below).
2. Run the build:

   ```bash
   ./build.sh
   ```

3. Commit `docs/` with your change and push to `main`.

GitHub Pages serves `docs/` from the `main` branch (Settings, Pages, Source: Deploy from a branch, `main`, `/docs`). There is no CI. `docs/` is generated, so never edit it by hand.

## Requirements

- Hugo extended 0.168.0. `build.sh` stops on any other version.
- Go, so that Hugo can fetch the theme module.

## Add a project

Add one entry to `data/projects.yaml`. The home page and the footer render it. The file lists the fields.

```yaml
- name: Project name
  icon: server
  pitch: One or two sentences that say what it does.
  status: Maturity, stated plainly.
  docs: https://circleci-labs.github.io/<REPOSITORY>/
  repo: https://github.com/CircleCI-Labs/<REPOSITORY>
```

List only public projects that have a docs site.

## Edit the text

| What | File |
|---|---|
| Hero, at a glance panel, banner, header menu | `hugo.yaml` |
| About and Support sections | `content/_index.md` |
| Footer | `layouts/_partials/custom/footer.html` |
| Colors, fonts, layout | `assets/css/custom.css` |

`assets/css/custom.css`, the fonts, and the icon come from the machine runner swarm docs site. Change them in both places.

## Preview

```bash
hugo server --bind 127.0.0.1 --baseURL http://127.0.0.1:1313/
```

## License

[MIT](LICENSE). The fonts have their own license: `static/fonts/OFL.txt`.
