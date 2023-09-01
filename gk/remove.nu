# Module for removing a local Github repository

use helpers/completions.nu *
use helpers/get.nu

# Remove all local data of the repository
export def main [
  user: string@get_local_user  # The name of the owner of the repository
  repo: string@get_local_repo  # The repository you want to remove
  --noconfirm(-n)              # do not ask for confirmation
] {

  let index = (get index)

  try {
    $index
    | if not ($user in $in) {
      return "you dont have any repositories from this user"
    } else {$in}
    | get $user
    | if not ($repo in $in.name) {
      return "you dont have that repository installed"
    } else {$in}
    | where name == $repo
    | get path.0
    | rm -f $in
  } catch {|e|
    return $"There was an error: ($e)"
  }
  remove_from_index $user $repo
}

def remove_from_index [user repo] {
  let conf = (get conf)
  let index = (get index)
  let repos = $index | get $user

  if (($repos | length) == 1) {
    $index
    | reject $user
  } else {
    $index
    | upsert $user (
      $repos
      | where name != $repo
    )
  }
  | save -f $conf.default_folder
}