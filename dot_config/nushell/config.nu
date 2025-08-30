let vendor_autoload_dir = ($nu.data-dir | path join "vendor/autoload")
mkdir $vendor_autoload_dir

starship init nu | save -f ($vendor_autoload_dir | path join "starship.nu")

$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
carapace _carapace nushell | save -f ($vendor_autoload_dir | path join "carapace.nu")

zoxide init nushell | save -f ($vendor_autoload_dir | path join "zoxide.nu")

