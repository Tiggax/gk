use get.nu

export def get_local_user [] {
  let index = (get index)
  $index
  | columns
}

export def get_internet_user [] {
  http get "https://api.github.com/users"
    | get login
}

export def get_local_repo [user: string] {
  let query = $user
  | split words
  | get 2

  (get index)
  | get $query -i
  | get name -i
}
export def get_internet_repo [user: string] {
  let query = $user 
    | split words 
    | get 2
  
  http get  $"https://api.github.com/users/($query)/repos?per_page=100"
    | get name
}

