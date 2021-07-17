# Fuog's Dotfiles

The idea behind this Repo is to share a zshrc between firends and multiple devices. You will need to have some shared-intrest in "how" a basic "shared-zshrc" should look like while also leaving space for personal stuff that others dont whant or you would not need on other devices.

It's more or less a "let's colaborate on semi-personal stuff"

This repo will also respect code that is added by other tools to the main `.zshrc` while updating its own part.

## Disclaimer

This repo tested with Ubuntu Linux 21.04 and may also require tools that are not installed by this Repo. Usage by your own risk.

## install prerequisites

This Repo does not install any prerequisites for the full features it can load at shell-launch. In most cases, should a dependency not be installed, the feature will just not be activated. Thats why most of the dependencies are "optionals" and will result in a smaller feature-stack if the prerequisites are ignored.

- [install and enable ZSH](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH) as your user shells
- optionals
  - install [kubectl](https://kubernetes.io/docs/tasks/tools/) (any source)
  - install [grc](https://github.com/garabik/grc)
  - install [fzf](https://github.com/junegunn/fzf) ( with `go get github.com/junegunn/fzf` or see [Howto](https://github.com/junegunn/fzf#installation) )

## Principals

- The core part of the dotfiles should be a consense of everyone that colaborates with this repo.
- Every part that is personal or otherwise not shared should be placed within folders and loaded or linked
  - `p10k` for personal p10k styles you would normally find at `$HOME/.p10k.zsh`
  - `additionals` mostly for other zshrc-stuff that is not shared
  - `vimrc` just the config for vimrc to use
  - (`scripts` not implemented yet)
- the code should alway check if requierements are met before executing something within the rc
- a update should always be possible
- we dont use oh-my-zsh but zplug DONT combine oh-my-zsh with this repo

## install dotfiles

This is a quick way to install dotfiles:

```bash
$SHELL <(curl -s "https://raw.githubusercontent.com/fuog/dotfiles/master/install.zsh") # will install to $HOME/git/dotfiles

$SHELL <(curl -s "https://raw.githubusercontent.com/fuog/dotfiles/master/install.zsh") "$HOME/git/private/dotfiles" # for custom locations
```

## more C&P

Example1 for setting all up in one blow

```bash
mkdir -p "$HOME/git";
$SHELL <(curl -s "https://raw.githubusercontent.com/fuog/dotfiles/master/install.zsh")
exec $SHELL
zplug install
dotfiles vimrc fuog-default.vimrc; dotfiles p10k fuog-full.zsh; dotfiles additionals fuog-default.zsh
```
Example2 for setting things up without direct execution.. for some proxy problems ..
```bash
mkdir -p "$HOME/git";
git clone https://github.com/fuog/dotfiles.git "$HOME/git/dotfiles"
$HOME/git/dotfiles/install.zsh
exec $SHELL
zplug install
dotfiles vimrc fuog-default.vimrc; dotfiles p10k fuog-full.zsh; dotfiles additionals fuog-default.zsh
```

## dotfiles tool usage

After Install, you can use a tool for selecting your personal files. Just add your personal files to the folders and activate them.

```bash
❯ dotfiles
Usage: dotfiles [subcommand]
 ..  repopath <file>        specify the folder manually
 ..  additionals <file>     select or specify the file manually
 ..  p10k <file>            select or specify the file manually
 ..  vimrc <file>           select or specify the file manually
 ..  install                just run the install script again
                            (update repo && update .zshrc template)

❯ dotfiles additionals my-personal-stuff.zsh
Setting ADDITIONALS-File to .zshrc
```

## Links

- Zplug (plugin manager) <https://github.com/zplug/zplug>
