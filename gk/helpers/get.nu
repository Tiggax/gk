# Getter functions for different stuff


# Get the configuration record
export def conf [] {
  try {
    $env.gk
  } catch {|_|
     {
        default_folder: (
          $nu.home-path 
          | path join ".local" "share"
          | path join "gk"
        )
    }
  }
}

# get the index data file
export def index [] {
  let conf = (conf)
  let index = $conf.default_folder
    | path join index.nuon

  if not ( $index | path exists ) {
    "{ }"| save $index
  }
    open $index
}

# save every user as lowercase
export def normalized_user [user: string] {
  $user
  | str downcase
}

# result "type" returns 1 and data if Ok() and 0 and error type.
export def result [res: string data?: any] {
    {
      result: $res
      data: $data
    }
  }

# Get the index path  
export def "index path" [] {
  conf
  | get default_folder
  | path join "index.nuon"
}

# get github url
export def "github url" [
  user: string
  repo: string
] {
  $"git@github.com:($user)/($repo).git"
}