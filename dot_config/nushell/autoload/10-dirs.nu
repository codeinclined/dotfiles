$env.NU_LIB_DIRS = [($nu.default-config-dir | path join "modules")]
$env.PATH = $env.PATH | prepend [
    ($nu.home-path | path join ".local" "bin")
    ($nu.home-path | path join ".cargo" "bin")
]
