# A utility tool for git organization

based on the [Nushell](https://www.nushell.sh/) language!

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
