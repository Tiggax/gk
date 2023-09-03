# clone a github repository

use helpers/completions.nu *
use helpers/get.nu
use std log

# Clone a reposiotry. optionaly clone it to a path.
export def main [
  user: string@get_local_user       # the name of the user (or organization) of the repository
  repo: string@get_internet_repo    # The name of the repository
  --directory(-d): path             # optional directory to clone into (defaults to $env.gk.default_directory)
  ...rest                           # optional rest paramaters to pass to `git clone` command. <- Warning not tested too much with other commands
] {
  let conf = (get conf)
  let user = (get normalized_user $user)
  let dir = (
    $directory
    | default ( 
      $conf.default_folder
      | path join $user $repo
    )
  )
  match (add $user $repo $dir) {
    {result: ERROR data: $x} => {
      print $"You seem to have already created this repository in this location:\n(ansi green)($x)(ansi reset)\nYou can enter it by typing:\n(ansi gb)`gk to ($user) ($repo)`(ansi reset)"
    }
    {result: OK} => {
      git clone (get github url $user $repo) $dir $rest
    }
  }
  

}

def add [
  user: string 
  repo: string
  path: path
  ] {
  let index = (get index)

  $index
  | if (
    $in
    | get $user -i
    | default [[name path]; [$nothing $nothing]]
    | $repo in $in.name
  ) {
    get result "ERROR" ($index | get $user | where name == $repo | get path)
  } else {
    $in
    | upsert $user (
      $in
      | get $user -i
      | append {
        name: $repo
        path: $path
      })
    | to nuon
    | save -f (get index path)
    get result "OK"
  }
}