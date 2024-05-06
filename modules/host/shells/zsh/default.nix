{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    vteIntegration = true;
    promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    histSize = 10000;

    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    setOptions = [
      "EXTENDED_GLOB"
      "NOTIFY"
      "HIST_EXPIRE_DUPS_FIRST"
      "SHARE_HISTORY"
      "HIST_FCNTL_LOCK"
    ];

    interactiveShellInit = '' 
      # programs.zsh.interactiveShellInit
      eval "$(zoxide init zsh)"

    '' + (builtins.readFile ./p10k.zsh) + (builtins.readFile ./wezterm.sh);

    shellAliases = {
      l = "eza -lhF --git --group-directories-first --icons=auto";
      c = "bat";
    };
  };
}
