# Personal Website

This is just a simple personal website which is generated by
[hugo](https://gohugo.io/), hosted by
[netlify](https://app.netlify.com/), and whose domain is managed
through [hover](https://www.hover.com/).

## Basic Set Up

### Nix

The easiest way to get started with this project is to install the
`nix` package manager with `flake` support from
https://nixos.org/download/

Once this is installed you can run `nix develop` to enter a shell with
all development packages installed.

## Testing

> !NOTE if using the `Site Generation` test certain features that are
> enabled by netlify will not work properly. Notably redirects such as
> `jtamagnan.com/github` will not work and redirect to
> `github.com/jtamagnan`.

### Full Test
To test the website fully as Netlify would run it use:
```
$ netlify dev
```

### Site generation
To test only the site generation component simply run:
```
$ hugo serve
```
