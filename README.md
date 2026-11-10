# alfinwilliam.github.io

Personal site: tech brief, blog, hobbies. Live at https://alfinwilliam.github.io/

Plain Jekyll, built by GitHub Pages' built-in build every time `main` is pushed. No JavaScript, no third-party requests, one stylesheet.

## Runbook

Everything here works with only git, Docker and the `gh` CLI.

### Where things live

| To change | Edit |
|---|---|
| Name, headline, About text, stack, links, photo | `_data/profile.yml` |
| Hobby tiles | `_data/hobbies.yml` and images in `assets/img/hobbies/` |
| Blog posts | `_posts/` |
| Colours, sizes, font | top section of `assets/css/style.css` |
| Page structure | `index.html`, `blog.html`, `_layouts/`, `_includes/` |

### Preview locally

```bash
./preview.sh          # http://localhost:4000, rebuilds on save, Ctrl+C to stop
./preview.sh build    # one build into _site/, fails loudly on errors
```

The first run downloads the `ruby:3.3` image and installs gems into `vendor/bundle`, which takes several minutes. Changes to `_config.yml` need a restart of the preview; everything else rebuilds on save.

To reclaim the disk space later: `docker image rm ruby:3.3` and `rm -r vendor`.

### Add a blog post

Create `_posts/YYYY-MM-DD-short-name.md`:

```markdown
---
layout: post
title: My post title
date: 2026-11-20 10:00:00
summary: One sentence shown on the post card and the blog page.
categories: Notes
---

Post body in Markdown.
```

The URL is built from the category, date and file name (`/notes/2026/11/20/short-name/`). Changing any of those after publishing breaks existing links to the post.

Before publishing anything about past work: no former-employer names, product or customer names, hostnames, account IDs, ARNs, real CIDRs, ticket IDs, or verbatim config and logs. Describe systems by their role and use example values.

### Edit the About text

Edit `_data/profile.yml`. Each entry under `about:` is one paragraph; each `group` under `stack:` is one row of chips. Text containing a colon must be in double quotes.

### Add or change a hobby

1. Put the image in `assets/img/hobbies/`, for example `hiking.jpg`. Landscape 4:3 works best (1200x900 is plenty); keep it under about 300 KB. Other shapes are cropped to 4:3.
2. Edit its entry in `_data/hobbies.yml`:

   ```yaml
   - name: Hiking
     blurb: One line about it.
     image: hiking.jpg
     alt: Ridge line at sunrise
   ```

Add an entry for a new tile, delete one to remove it. Delete all of them and the whole section disappears.

### Change the colours or font

Open `assets/css/style.css`. The Settings section at the top holds every colour, once for light mode and once for dark mode. For a new accent, change `--accent`, `--accent-hover`, `--chip-bg` and `--chip-text` in both blocks. Keep text at a contrast ratio of at least 4.5:1 against its background (https://webaim.org/resources/contrastchecker/).

The favicon has its own colour, in `assets/img/favicon.svg`.

### Publish

GitHub publishes whatever is on `main`.

```bash
./preview.sh build            # must finish without errors
git add <files you changed>
git commit -m "Describe the change"
git push origin main
```

### Check the publish worked

```bash
gh api repos/alfinwilliam/alfinwilliam.github.io/pages/builds/latest --jq '{status, error: .error.message}'
```

`building` means wait a minute. `built` means it is live. `errored` means see below. The same runs appear under the repo's Actions tab as "pages build and deployment".

### Roll back a bad publish

```bash
git log --oneline -5
git revert <sha>          # for a normal commit
git revert -m 1 <sha>     # for a merge commit
git push origin main
```

GitHub rebuilds the previous state within a couple of minutes. A revert keeps history, so never force-push `main` for this.

### If the build fails

The old site stays live until a build succeeds, so there is no rush.

1. Run `./preview.sh build`. It uses the same Jekyll and plugin versions as GitHub and reproduces most errors with a file and line number.
2. The usual causes are bad indentation in a `_data/*.yml` file or in a post's front matter, or an unquoted colon in a text value.
3. If it builds locally but fails on GitHub, compare the `github-pages` number in `Gemfile` with https://pages.github.com/versions.json. If it is behind, update the number, delete `Gemfile.lock` and build again. Only plugins on that list work with the built-in build.

## Licences

The Inter font is under the SIL Open Font License 1.1, see `assets/fonts/LICENSE-Inter.txt`.
