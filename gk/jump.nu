# Jump to directory interactively. Similar to `gk to <user> <repo>`

use helpers/get.nu

# Jump to directory interactively. Similar to `gk to <user> <repo>`
export def --env main [] {
  let conf = (get conf)
  let index = (get index)

  $index
  | items {|key,val|
    $val
    | each {|x|
      {user: $key repo: $x.name }
    }
  }
  | flatten
  | input list -f
  | match (get_search_path $in) {
    {result: "OK" data: $data } => {
      print $data
      cd $data
    },
    {result: "ERR" data: $data } => {
      $"There was an error: ($data)"
    }
  }
}


def get_search_path [search] {
  let index = (get index)

  let path = (
    $index
    | get $search.user
    | where name == $search.repo
    | get path.0
  )
  if ($path | path exists) {
    return { result: "OK" data: $path}
  } else {
    return { result: "ERR" data: "path not found"}
  }
}