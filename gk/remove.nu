# Module for removing a local Github repository

use helpers/completions.nu *
use helpers/get.nu

# Remove all local data of the repository
export def main [
  user: string@get_local_user  # The name of the owner of the repository
  repo: string@get_local_repo  # The repository you want to remove
  --noconfirm(-n)              # do not ask for confirmation
  --only_index(-i)             # Remove only the index and leave the phyisical git alone
] {

  let index = (get index)
  if (not $only_index) {
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
      if (not (confirm prompt $in)) {return "There was no deletion"} else {$in}
      | rm -r $in
    } catch {|e|
      match $e {
        {msg: "File(s) not found"} => {
          print "The folder seems to be already removed, removing the index"
        },
        $x => {
          return $"There was an error:\n($x)"
        }
      }
    }
  }
  remove_from_index $user $repo
}

def remove_from_index [user repo] {
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
  | to nuon
  | save -f (get index path)
}

def "confirm prompt" [path] {
  print $"This is going to remove (ansi bold)all(ansi reset) files in [($path)]!"
  print $"are you sure you want to proceed?"
  ["yes" "no"] 
  | input list
  match $in {
    "yes" => {true}
    "no" => {false}
  }
}