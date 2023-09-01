# Jump to your desired git repo

use helpers/completions.nu *

# Jump to your desired Git reposiory

export def to [
  user: string@get_local_user
  repo: string@get_local_repo
  --fuzzy(-f)
] {
  
}