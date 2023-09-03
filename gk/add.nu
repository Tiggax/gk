# Add an existing Git repository to your paths.

use helpers/get.nu

# Add an existing Git repository to your paths.
export def main [
  dir?: path      # Optional path to your git repository
  --myself(-m)    # automaticaly add yourself as the owner if no owner is found.(This works by using the `user.name` var of git)
  ] {
  let index = (get index)
  let dir = if ($dir == $nothing) { (pwd) } else {$dir}
  
  if (not ($dir | path type) == "dir") {
    return "you have not provided a directory"
  }

  let data = match (get_git_root $dir) {
    {result: "OK" data: {root: $root url: "" } } => {
      if ($myself) {
        {
          root: $root
          user: (get normalized_user (git config --get user.name))
          repo: ($root | path basename)
        }
      } else {
        print "origin was not found, and in turn user could not be fetched."
        {
          root: $root
          user: (get normalized_user (get_user))
          repo: ($root | path basename)
        }
      }
    },
    {result: "OK" data: $data} => {
      {
        root: ($data.root)
        user: ($data.url | path dirname |  parse "git@github.com:{user}" | get user.0 | get normalized_user $in)
        repo: ($data.url | path basename | parse "{repo}.git" | get repo.0 )
      }
    },
    {result: "ERR" data: $data } => {
      return $data
    }
  } 

  $index
  | if ($data.user in $in) {
    $in
    | upsert $data.user (
      $in
      | get $data.user
      | append {name: $data.repo path: $data.root}
    )
  } else {
    $in
    | upsert $data.user [{name: $data.repo path: $data.root}]
  }
  | to nuon
  | save -f (get index path)
}

def get_git_root [dir] {
  cd $dir
  if ($"(git rev-parse --is-inside-work-tree)" == "true") {
    return { result:"OK" data: {root:$"(git rev-parse --show-toplevel)" url: (git config --get remote.origin.url) }}
  }
  {
    result:"ERR" 
    data: $"(ansi rb)The curent directory is not a git directory. please use the command inside of a git directory or suppy a git directory(ansi reset)" 
  }
}

def get_user [] {
  mut user = ""
  mut confirm = "no"
  while ($confirm == "no") {
  print "Please provide a owner of the reposiory:"
  $user = (input)
  print $"Is this your user?:[($user)]"
  $confirm = (["yes" "no"] | input list)
  clear
  }
  $user
}