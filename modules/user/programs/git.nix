{ ... }:

{
  programs.git = {
    enable = true;
    userName = "Josh Taylor";
    userEmail = "taylor.joshua88@gmail.com";

    extraConfig = {
      init.defaultBranch = "main";
    };
  };
}
