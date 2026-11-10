#!/usr/bin/env bash
# Build or preview the site with Docker, so Ruby is not needed on the laptop.
#
#   ./preview.sh          serve at http://localhost:4000, rebuild on save, Ctrl+C to stop
#   ./preview.sh build    build once into _site/, exit non-zero if the build fails
#
# The first run downloads the ruby:3.3 image and installs gems into vendor/bundle.
# That takes several minutes; later runs start in seconds.

set -euo pipefail
cd "$(dirname "$(readlink -f "$0")")"

mode="${1:-serve}"

tty_args=()
if [ -t 0 ] && [ -t 1 ]; then
  tty_args=(-it)
fi

case "$mode" in
  serve)
    # Host networking lets Jekyll bind to localhost. Binding to 0.0.0.0 with a
    # published port would write http://0.0.0.0:4000 into the generated links.
    network_args=(--network host)
    jekyll_cmd="jekyll serve --host localhost --port 4000"
    ;;
  build)
    network_args=()
    jekyll_cmd="jekyll build"
    ;;
  *)
    echo "Usage: $0 [serve|build]" >&2
    exit 2
    ;;
esac

exec docker run --rm "${tty_args[@]}" "${network_args[@]}" \
  --user "$(id -u):$(id -g)" \
  -e HOME=/tmp \
  -e BUNDLE_PATH=vendor/bundle \
  -e BUNDLE_APP_CONFIG=.bundle \
  -e PAGES_REPO_NWO=alfinwilliam/alfinwilliam.github.io \
  -v "$PWD:/srv/site" \
  -w /srv/site \
  ruby:3.3 \
  bash -c "bundle check >/dev/null 2>&1 || bundle install --quiet; exec bundle exec $jekyll_cmd"
