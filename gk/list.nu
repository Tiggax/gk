# List your git repositories

use helpers/get.nu
use helpers/completions.nu *

# List all of your local github reposiories
export def main [
  user?: string@get_local_user  # Optional user to search for
  --detail(-d)                  # Print more detail about each repository
 ] {
  let index = (get index)

  if ($detail) {
    return ($index | table -e)
  }

  $index
  | if ($user == null) {
    shorthand $in
  } else {
    if ($user in ($index | columns)) {
      $in 
      | get $user
    } else {
      print $"You have no Repositories of this user.\nAdd them using:(ansi gb)`gk clone ($user) <repo>`"
    }
  }
  | table -e
}

def shorthand [index] {
  let users = ($index | columns)

  $users
  | each {|user|
    {
      user: $user
      repos: (
        $index
        | get $user
        | get name
      )
    }
  }
}