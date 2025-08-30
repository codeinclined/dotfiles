$env.config.edit_mode = 'vi'

$env.PROMPT_INDICATOR_VI_NORMAL = $'(ansi gb) (ansi gd)󰄾(ansi reset) '
$env.PROMPT_INDICATOR_VI_INSERT = $'(ansi y)󱩽 (ansi yd)󰅂(ansi reset) '

$env.TRANSIENT_PROMPT_COMMAND = {|| $"(ansi b)\n󰅐 (date now | format date "%T") (ansi bd)󰶻(ansi reset) " }
$env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = ''
$env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = ''
