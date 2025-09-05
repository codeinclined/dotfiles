# export def merge [--save (-s)] {
#     mut pacfile = open-pacfile
#
#     let new_pacfile = $pacfile.pkgs
#     | append (^pacman -Qe | parse '{pkg} {_}' | get pkg)
#     | uniq
#
#     if $save {
#         $pacfile | save-pacfile
#     }
#
#     $pacfile
# }
#
# export def sync [--noconfirm (-y)] {
#     let pacfile = open-pacfile
#     let extra_opts = if $noconfirm { ['--noconfirm'] } else { [] }
#
#     sudo pacman ...$extra_opts -Syyu
#
#     if (which paru | is-empty) {
#         print -e 'Paru is needed to install AUR packages'
#         sudo pacman ...$extra_opts -S paru
#     }
#
#     paru ...$extra_opts --needed --skipreview --interactive -S ...($pacfile.pkgs)
# }

def open-pacfile [] {
    let pacdir = $nu.home-path | path join '.config' 'pac'
    let pacfile = $pacdir | path join 'pac.yaml'

    if not ($pacfile | path exists) {
        mkdir $pacdir
        { pkgs: (^pacman -Qe | parse '{name} {ver}') } | save $pacfile
        print -e $'Created new pacfile at ($pacfile)'
    } else {
        print -e $'Using existing pacfile at ($pacfile)'
    }

    open $pacfile
}

def save-pacfile []: record<pkgs: table> -> nothing {
    let new = $in
    let pacdir = $nu.home-path | path join '.config' 'pac'
    let pacfile = $pacdir | path join 'pac.yaml'

    if not ($pacfile | path exists) {
        mkdir $pacdir
    }

    $new | save -f $pacfile
    print -e $'Updated ($pacfile)'
}

def dry-run-msg []: nothing -> string {
  $'(ansi yb)[DRY RUN](ansi reset)'
}

export def status [--all (-a), --no-sync (-n), --no-color (-c)] {
  if not $no_sync {
    paru -Sy
  }

  let pacfile = open-pacfile
  let local_pkgs = ^pacman -Qe | parse '{name} {ver}'
  let outdated_pkgs = ^pacman -Que | parse '{name} {local} -> {remote}'

  let state = $pacfile.pkgs
  | join -o $local_pkgs name
  | rename name pacfile local
  | insert remote {|r|
      try { $outdated_pkgs | where name == $r.name | first | get remote } catch { $r.local }
    }
  | insert status {|r|
      if $r.pacfile == null     { if $no_color { return "ADDED"    } else { return $'(ansi cr   ) ADDED    (ansi reset)' } }
      if $r.local   == null       { if $no_color { return "MISSING"  } else { return $'(ansi yr   ) MISSING  (ansi reset)' } }
      if $r.local   != $r.remote  { if $no_color { return "OUTDATED" } else { return $'(ansi rr   ) OUTDATED (ansi reset)' } }
      if $r.pacfile != $r.local { if $no_color { return "VER DIFF" } else { return $'(ansi ligrr) VER DIFF (ansi reset)' } }

      null
    }
  | move status --after name

  if $all { $state } else { $state | where status != null }
}

export def sync [--dry-run (-d)] {
  mut pacfile = open-pacfile
  let state = status --no-color

  if $dry_run {
    print -e $'(dry-run-msg) paru -S (^echo ...($state | where status in ['MISSING','OUTDATED'] | get name))'
  } else {
    paru -S ...($state | where status in ['MISSING','OUTDATED'] | get name)
  }

  let choices = [
    'add to pacfile',
    'remove locally',
    'ignore',        
    'add remaining to pacfile',
    'remove remaining locally',    
    'ignore remaining',
  ]
  
  mut to_add_to_pacfile = []
  mut to_remove_locally = []

  let added_pkgs = $state | where status == 'ADDED'

  for kv in ($added_pkgs | enumerate) {
    print -e $kv.item
    print -e 'How would you like to proceed?'

    match ($choices | input list --fuzzy --index) {
      0 => { $to_add_to_pacfile ++= [$kv.item]; },
      1 => { $to_remove_locally ++= [$kv.item]; },
      2 => { continue; },
      3 => { $to_add_to_pacfile ++= ($added_pkgs | skip $kv.index); break; },
      4 => { $to_remove_locally ++= ($added_pkgs | skip $kv.index); break; },
      6 => { break; },
      _ => { print -e "unknown choice provided; exiting"; return; },
    }
  }

  let choices = [
    'update pacfile',
    'ignore',
    'update remaining in pacfile',
    'ignore remaining',
  ]

  mut to_fix_ver_mismatch = []
  let verdiff_pkgs = $state | where status == 'VER DIFF'

  for kv in ($verdiff_pkgs | enumerate) {
    print -e $kv.item
    print -e 'How would you like to proceed?'

    match ($choices | input list --fuzzy --index) {
      0 => { $to_fix_ver_mismatch ++= [$kv.item]; },
      1 => { continue; },
      2 => { $to_fix_ver_mismatch ++= ($verdiff_pkgs | skip $kv.index); break; },
      3 => { break; },
      _ => { print -e "unknown choice provided; exiting"; return; },
    }
  }

  if ($to_fix_ver_mismatch | is-not-empty) {
    $pacfile.pkgs = $pacfile.pkgs
    | join -o ($to_fix_ver_mismatch | select name local) name
    | update ver { |r| if $r.local != null { $r.local } else { $r.ver } }
    | reject local

    print -e $'Updated ($to_fix_ver_mismatch | length) package versions in pacfile'
  }

  if ($to_remove_locally | is-not-empty) {
    if $dry_run {
      print -e $'(dry-run-msg) paru -Rcs (^echo ...($to_remove_locally | get name))'
    } else {
      paru -Rcs ...($to_remove_locally | get name)
    }

    print -e $'Removed ($to_remove_locally | length) packages from local system'
  }

  if ($to_add_to_pacfile | is-not-empty) {
    $pacfile.pkgs ++= ($to_add_to_pacfile | select name local | rename name ver)
    print -e $'Adding ($to_add_to_pacfile | length) packages to pacfile'
  }

  if not $dry_run {
    $pacfile | save-pacfile
  }

  $pacfile.pkgs
}
