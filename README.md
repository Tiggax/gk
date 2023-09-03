# A utility tool for git organization

based on the [Nushell](https://www.nushell.sh/) language!

The module can be used to save all your different git repositories into one folder, and they can be easily accesed with `gk to <user> <repository>` or `gk jump` for interactive fuzzy search


the git repositories are saved by default to:

1. your `$env.gk.default_folder`
2. `~/.local/share/gk/data`


it is recomended to supply `gk` env variable.
this is a default config:

```nushell
$env.gk = {
  default_folder: "/path/to/your/save"
}
```

Some of the commands are:

|command|usage|
|-|-|
|add|Add an existing Git repository to your paths.|
|clone|clone a github repository|
|jump|Jump to directory interactively. Similar to `gk to <user> <repo>`|
|list|List your git repositories|
|remove|Module for removing a local Github repository|
|to|Jump to your desired git repo|

