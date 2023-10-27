# Jump to your desired git repo

use helpers/completions.nu *
use helpers/get.nu

# Jump to your desired Git reposiory
export def --env main [
  user: string@get_local_user  # Name of the user to jump to
  repo: string@get_local_repo  # Name of the repository to jump to
] {
  let index = (get index)

  $index
  | if ($user in $in) {
    $in
  } else {
    return $"The user[($user)] was not found"
  }
  | get $user
  | if ($repo in $in.name) {
    $in
  } else {
    return $"the Reposiotry [($repo)] was not found"
  }
  | where name == $repo
  | get path.0
  | cd $in
}