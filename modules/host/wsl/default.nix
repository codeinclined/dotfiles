{ ... }:

{
  wsl = {
    enable = true;
    defaultUser = "jtaylor";
    useWindowsDriver = true;
    startMenuLaunchers = false;

    wslConf = {
      automount.root = "/mnt";
      interop.appendWindowsPath = true;
      network.generateHosts = true;
    };
  };
}
