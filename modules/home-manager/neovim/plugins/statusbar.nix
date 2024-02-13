{pkgs, ...}: {
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      heirline-nvim
    ];

    extraConfigLua = builtins.readFile ./statusbar.lua;
  };
}
