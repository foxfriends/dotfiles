# Dotfiles

Please feel free to take inspiration, send suggestions, or anything. Some parts may work
better than others, depending on how recently I used/updated each program.

## Setup

1.  Clone the repo somewhere (I ususally put it in `$HOME/.dotfiles`).
2.  Run `./setup install/for-linux` or `./setup install/for-mac` and it will (hopefully) set
    itself up and install all sorts of things. You can skip the install step
    by just running `./setup` with no parameter.

    It's very likely that some programs that should be installed/would be
    nice to have are not yet included in the installer. That will be fixed
    over time I hope.

Note that this may or may not blindly overwrite any existing configuration files you
have installed. Use with caution if you have a setup you like already.

## Usage

Once it has been set up, run `./setup` again at any time to regenerate all templated
files and reinstall the configurations.

The `./setup` script will use the value of the `SKIN` environment variable to pick
a file from the `themes` directory to use when generating the templated files. Use
that to choose a colour scheme. It defaults to `onedark` if a `SKIN` is not provided.

## Templates

Files ending in `.template` are not intended to be used directly. They reference theme
variables (`theme_*`) which will be replaced when compiling that template with the
values from the file in the `themes` directory corresponding to the value of the `SKIN`
environment variable, as described above.

Colours listed in the theme file are expected to be written in hex format (without `#`).
In addition to the theme variables listed out in the theme file, for compatibility with
programs which prefer other formats, each colours is converted to RGB format
(e.g. `rgb(#, #, #)`) using [pastel][] and made available as a corresponding variable
named `theme_rgb_*`. For this reason, ensure at least the `pastel` command is installed
(so I suppose a minimal initial install of these configs would be `./setup install/pastel`).

[pastel]: https://github.com/sharkdp/pastel

Additionally, the variable `PWD` will be replaced with the directory in which the
template file is located at the time of generation. This means that the variable `PWD`
will not function as expected when running any generated scripts. To reference the
current directory at runtime, I suggest using `$(pwd)` instead.

The variable `FONT_SIZE` will also be replaced with whatever is set on the command line
when running `./setup`, defaulting to 14. This variable is not set in themes, as its value
is more related to the computer/monitor that the system is being set up for.

## Notice

Note that some of the files here are actually not mine (most notably the fonts)
but I think they are free/open source and I like collecting them, so here they are.
If you happen to be the owner of such a file, and wish it removed, I will do that.
