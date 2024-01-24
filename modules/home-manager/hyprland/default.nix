{
  config,
  lib,
  ...
}: let
  cfg = config.webflo.modules.hyprland;
  inherit (lib) mkEnableOption mkIf mkOption types;
in {
  options.webflo.modules.hyprland = {
    enable = mkEnableOption "hyprland module";
    wallpaper = mkOption {type = types.path;};
  };

  config = let
    wallpaper_target = "hypr/wallpaper.jpg";
  in
    mkIf cfg.enable {
      xdg.configFile.${wallpaper_target}.source = cfg.wallpaper;

      wayland.windowManager.hyprland = {
        enable = true;
        xwayland.enable = true;
        settings = {
          "$colors_red" = "rgb(CF3746)";
          "$colors_orange" = "rgb(DF7C2C)";
          "$colors_yellow" = "rgb(ECBD10)";
          "$colors_lime" = "rgb(7CBD27)";
          "$colors_green" = "rgb(41A36F)";
          "$colors_sky" = "rgb(32B5C7)";
          "$colors_blue" = "rgb(277AB6)";
          "$colors_purple" = "rgb(AD4ED2)";

          "$colors_darker" = "rgb(1D1D1D)";
          "$colors_dark" = "rgb(292A2B)";
          "$colors_gray" = "rgb(626861)";
          "$colors_light_gray" = "rgb(AEB7B6)";
          "$colors_light" = "rgb(D8E2E1)";
          "$colors_brown" = "rgb(776550)";
          "$colors_acccent_color" = "rgb(ECBD10)";

          input = {
            kb_layout = "fr";
            repeat_delay = 200;
            repeat_rate = 25;
            follow_mouse = true;
            touchpad = {
              natural_scroll = false;
            };
          };
          gestures = {
            workspace_swipe = true;
          };

          monitor = [
            # "DP-2, 3840x2160@144, 0x0, 1, bitdepth,10" # not sure if bitdepth is required
            "DP-1, 3840x2160@144, 0x0, 1, bitdepth,10"
            "eDP-1, 1920x1200@60, 0x0, 1"
          ];

          general = {
            gaps_in = 10;
            gaps_out = 20;
            border_size = 4;
            no_border_on_floating = false;
            "col.active_border" = "$colors_acccent_color";
            "col.inactive_border" = "$colors_dark";
            "col.nogroup_border" = "0xffffffff";
            "col.nogroup_border_active" = "0xffff00ff";
            layout = "master";
            resize_on_border = true;
            extend_border_grab_area = 15;
            allow_tearing = false;
          };

          decoration = {
            rounding = 8;

            active_opacity = 0.85;
            inactive_opacity = 0.85;
            fullscreen_opacity = 1.0;

            drop_shadow = true;
            # col.shadow = rgba(1a1a1aee)
            # col.shadow_inactive =
            # shadow_offset = [0,0]
            # shadow_scale = 1

            dim_inactive = false;
            dim_strength = 0.3;

            blur = {
              enabled = true;
              new_optimizations = true;
              ignore_opacity = true;
              xray = true;
              # noise = 0.4

              size = 2;
              passes = 4;

              # size = 10
              # passes = 1
            };
          };

          group = {
            "col.border_active" = "$colors_acccent_color";
            "col.border_inactive" = "$colors_dark";
            "col.border_locked_active" = "$colors_red";
            "col.border_locked_inactive" = "$colors_light_gray";
            groupbar = {
              gradients = false;
              font_size = 11;
              text_color = "$colors_darker";
              "col.active" = "$colors_orange";
              "col.inactive" = "$colors_dark";
              "col.locked_active" = "$colors_red";
              "col.locked_inactive" = "$colors_dark";
            };
          };

          layerrule = [
            "blur, power-menu"
          ];

          animations = {
            enabled = true;
            bezier = "overshot,0.13,0.99,0.29,1.1";
            animation = [
              "windows,1,4,overshot,slide"
              "border,1,10,default"
              "fade,1,8,default"
              "workspaces,1,5,default"
            ];
          };

          misc = {
            disable_hyprland_logo = true;
            enable_swallow = true;
            # focus_on_activate = true
            vrr = 0; # 0 = off, 1 = on, 2 = fullscreen only
            vfr = false;
          };

          dwindle = {
            pseudotile = true;
            preserve_split = true;
            force_split = 2;
            # col.group_border = $colors_dark
            # col.group_border_active	= $colors_lime
            # split_width_multiplier = 0.75
          };

          master = {
            new_is_master = false;
            special_scale_factor = 0.3;
            no_gaps_when_only = false;
          };

          "$terminal" = "terminal";

          bind = [
            "SUPER, Return, exec, $terminal"
            "SUPER SHIFT, Return, exec, $terminal --float"
            "SUPER, Q, killactive, "
            "SUPER, D, exec, ags toggle-window app-launcher "
            # "SUPER SHIFT, Escape, exec, ags toggle-window power-menu "
            "SUPER SHIFT, Escape, exec, ags -r 'powermenu.toggle()'"

            # audio
            ",XF86AudioPlay,exec,playerctl play-pause"
            ",XF86AudioPause,exec,playerctl play-pause"
            ",XF86AudioNext,exec,playerctl next "
            ",XF86AudioPrev,exec,playerctl prev"

            # volume binds
            ",XF86AudioMute,exec, volume --toggle"
            "SHIFT,XF86AudioMute,exec, volume --toggle-mic"

            ",Print,exec, ags -r 'screenshot.screenshot()' "
            "SHIFT,Print,exec, ags -r 'screenrecord.toggle()'"

            # Move focus with arrow keys
            "SUPER, left, movefocus, l"
            "SUPER, right, movefocus, r"
            "SUPER, up, movefocus, u"
            "SUPER, down, movefocus, d"

            # Move focus with HJKL keys
            "SUPER, h, movefocus, l"
            "SUPER, l, movefocus, r"
            "SUPER, k, movefocus, u"
            "SUPER, j, movefocus, d"

            # Move windows with arrow keys
            "SUPER SHIFT, left, movewindow, l"
            "SUPER SHIFT, right, movewindow, r"
            "SUPER SHIFT, up, movewindow, u"
            "SUPER SHIFT, down, movewindow, d"

            # Move windows with HJKL keys
            "SUPER SHIFT, h, movewindow, l"
            "SUPER SHIFT, l, movewindow, r"
            "SUPER SHIFT, k, movewindow, u"
            "SUPER SHIFT, j, movewindow, d"

            "SUPER, ampersand, workspace, 1"
            "SUPER, eacute, workspace, 2"
            "SUPER, quotedbl, workspace, 3"
            "SUPER, apostrophe, workspace, 4"
            "SUPER, parenleft, workspace, 5"

            "SUPER SHIFT, ampersand, movetoworkspace, 1"
            "SUPER SHIFT, eacute, movetoworkspace, 2"
            "SUPER SHIFT, quotedbl, movetoworkspace, 3"
            "SUPER SHIFT, apostrophe, movetoworkspace, 4"
            "SUPER SHIFT, parenleft, movetoworkspace, 5"

            # Toggle special workspace
            "SUPER ALT, Space, togglespecialworkspace, 1"
            "SUPER CTRL, Space, movetoworkspace, special:1"
            # bind = SUPER ALT, eacute, togglespecialworkspace, 2
            # bind = SUPER ALT, quotedbl, togglespecialworkspace, 3
            # bind = SUPER ALT, apostrophe, togglespecialworkspace, 4
            # bind = SUPER ALT, parenleft, togglespecialworkspace, 5

            # Move to special workspace
            # bind = SUPER CTRL, ampersand, movetoworkspace, special:1
            # bind = SUPER CTRL, eacute, movetoworkspace, special:2
            # bind = SUPER CTRL, quotedbl, movetoworkspace, special:3
            # bind = SUPER CTRL, apostrophe, movetoworkspace, special:4
            # bind = SUPER CTRL, parenleft, movetoworkspace, special:5

            "SUPER ALT_L, left, workspace, e-1 "
            "SUPER ALT_L, right, workspace, e+1 "

            # Maximize active window
            ", F11, fullscreen, 1"

            # Real fullscreen
            "SUPER, F11, fullscreen, 0"

            "SUPER,   F,      togglefloating"
            "SUPER,   p,      pin"
            "SUPER,   O,      toggleopaque"
            "SUPER,   B,      bringactivetotop"
            "SUPER,   G,      togglegroup"
            "SUPER,   tab,    cyclenext"
            "SUPER,   tab,    bringactivetotop"
            "SUPER SHIFT, tab,    cyclenext, prev"
            "ALT,     tab,    changegroupactive, f"
            "ALT SHIFT,     tab,    changegroupactive, b"
            "SUPER,   T,      togglesplit"

            "SUPER SHIFT CTRL, space, swapnext"
          ];

          binde = [
            ",XF86AudioRaiseVolume,exec, volume --up"
            ",XF86AudioLowerVolume,exec, volume --down"

            ",XF86MonBrightnessUp,exec, backlight --up"
            ",XF86MonBrightnessDown,exec, backlight --down"

            # Resize windows with arrow keys
            "SUPER CTRL, left, resizeactive, -25 0"
            "SUPER CTRL, right, resizeactive, 25 0"
            "SUPER CTRL, up, resizeactive, 0 -25"
            "SUPER CTRL, down, resizeactive, 0 25"

            # Resize windows with HJKL keys
            "SUPER CTRL, h, resizeactive, -25 0"
            "SUPER CTRL, l, resizeactive, 25 0"
            "SUPER CTRL, k, resizeactive, 0 -25"
            "SUPER CTRL, j, resizeactive, 0 25"
          ];

          bindm = [
            "SUPER, mouse:273, resizewindow" # right mouse button
            "SUPER, mouse:272, movewindow" # left mouse button
          ];

          windowrulev2 = [
            # "float, class:^(eww)$"

            "float,class:^(floating_terminal)$"
            "move center,class:^(floating_terminal)$"

            ### Picture-in-picture
            "pin,title:^(Picture in picture)$"
            "size 1200 650,title:^(Picture in picture)$"
            "move 100%-1220 100%-670,title:^(Picture in picture)$"
            "float,title:^(Picture in picture)$"
            "opacity 1.0,title:^(Picture in picture)$"

            ### pulsemixer
            "float, class:^(floating_terminal)$,title:^(pulsemixer)$"
            "move center, class:^(pulsemixer)$,title:^(pulsemixer)$"
            "size 600 300, class:^(pulsemixer)$,title:^(pulsemixer)$"

            "float, class:^(nm-connection-editor)$"
            "move center, class:^(nm-connection-editor)$"

            # "float, class:^(xdg-desktop-portal)$"
            # "move center, class:^(xdg-desktop-portal)$"

            # "float, class:^(xdg-desktop-portal-gnome)$"
            # "move center, class:^(xdg-desktop-portal-gnome)$"

            # "float, class:^(ags)$"

            "workspace 5, class:^(Spotify)$"

            # "noblur, class:^(microsoft-edge)$"
            # "opacity 0.9, class:^(microsoft-edge)$"
            "workspace 2, class:^(microsoft-edge)$, title:^(.*)(- Professional - )(.*)$"
            "workspace 4, class:^(microsoft-edge)$, title:^(.*)(- Personal - )(.*)$"
            "workspace 3, class:^(Slack)$"

            ### Blueman
            "float,class:^(blueman-manager)$"
            "move center,class:^(blueman-manager)$"
          ];

          exec-once = [
            # "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
            # "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
            #"/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &"
            #"gnome-keyring-daemon --start --components=secrets"
            # "~/.local/bin/gtkthemes "
            "swaybg -m fill -i $XDG_CONFIG_HOME/${wallpaper_target}"
            "nm-applet --indicator"
            "blueman-applet"
            # "playerctld daemon"
            "ags"
          ];
        };
      };
    };
}
