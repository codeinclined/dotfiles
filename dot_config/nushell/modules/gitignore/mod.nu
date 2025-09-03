export def main [template: string, ...extra: string]: nothing -> string {
    let params = [$template, ...$extra] | url encode | str join ','
    http -r $'https://www.toptal.com/developers/gitignore/api/($params)'
}
