# A module to help organize and move around in your Github git repositories

export use add.nu
export use clone.nu
export use jump.nu
export use jto.nu
export use list.nu
export use remove.nu

export def main [] {
  let out = (help gk)
  
  print ([
    $out
    $"(ansi green)Environment(ansi reset):"
    $"  gk = {"
    $"    default_folder = \"path/to/your/def/folder\""
    $"  }"
    $"   (ansi cyan)gk(ansi reset) - configurational var specifing where to save your git repositories."
    $"   Alternatively searches for (ansi cyan)~/.local/share/gk/(ansi reset)"
  ]
  | str join "\n"
  | nu-highlight
  )
}