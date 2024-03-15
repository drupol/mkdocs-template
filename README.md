# MKDocs with Nix

## Usage

To run a development server:

```sh
nix develop
mkdocs serve
```

To build the site:

```sh
nix build
```

The resulting HTML files will be in `./result`

## Direnv integration

This project uses [direnv](https://direnv.net/) to automatically load the Nix
environment when you `cd` into the project directory. To enable this, run:

```sh
direnv allow
```
