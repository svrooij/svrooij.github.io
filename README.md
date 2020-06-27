# Stephans personal website

This is a clone of [personal website](https://github.com/github/personal-website).

See [original readme](./README-original.md)

## Serve locally

Serve this website (with live reload) using docker (Unix/Mac version)

```shell
docker run --rm --volume=\"$PWD/.bundle:/usr/local/bundle\" --volume=\"$PWD:/srv/jekyll\" -p 4000:4000 -p 35729:35729 -it jekyll/jekyll jekyll serve --livereload
```

Windows

```shell
docker-compose run jekyll jekyll serve --livereload
```