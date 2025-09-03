def open-pacfile [] {
    let pacdir = $nu.home-path | path join '.config' 'pac'
    let pacfile = $pacdir | path join 'pac.yaml'

    if not ($pacfile | path exists) {
        mkdir $pacdir
        {pkgs: []} | save $pacfile
        print -e $'Created new pacfile at ($pacfile)'
    } else {
        print -e $'Using existing pacfile at ($pacfile)'
    }

    open $pacfile
}

def save-pacfile []: record<pkgs: list<string>> -> nothing {
    let new = $in
    let pacdir = $nu.home-path | path join '.config' 'pac'
    let pacfile = $pacdir | path join 'pac.yaml'

    if not ($pacfile | path exists) {
        mkdir $pacdir
    }

    $new | save -f $pacfile
    print -e $'Updated ($pacfile)'
}

export def merge [--save (-s)] {
    mut pacfile = open-pacfile
    
    $pacfile.pkgs = $pacfile.pkgs
    | append (^pacman -Qe | parse '{pkg} {_}' | get pkg)
    | uniq

    if $save {
        $pacfile | save-pacfile
    }

    $pacfile
}

export def sync [--noconfirm (-y)] {
    let pacfile = open-pacfile
    let extra_opts = if $noconfirm { ['--noconfirm'] } else { [] }

    sudo pacman ...$extra_opts -Syyu

    if (which paru | is-empty) {
        print -e 'Paru is needed to install AUR packages'
        sudo pacman ...$extra_opts -S paru
    }

    sudo paru ...$extra_opts --needed -S ...($pacfile.pkgs)
}
