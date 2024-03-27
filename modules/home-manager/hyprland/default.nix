{
  config,
  lib,
  pkgs,
  hostName,
  ...
}: let
  cfg = config.webflo.modules.hyprland;
  inherit (lib) mkEnableOption mkIf mkOption types;
in {
  options.webflo.modules.hyprland = {
    enable = mkEnableOption "hyprland";

    defaultWallpaper = mkOption {
      type = types.path;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      swaybg
    ];

    xdg.configFile."hypr/wallpaper.jpg".source = cfg.defaultWallpaper;

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

        # source = [
        #   # ./src/animations/animation-fast.conf
        #   # ./src/decoration/blur.conf
        #   # ./src/group/default.conf
        #   # ./src/windows/default.conf
        #   # ./src/monitors/${hostName}.conf
        #   # ./src/input/${hostName}.conf
        #   # ./src/exec/${hostName}.conf
        #   # ./src/bind.conf
        #   # ./src/window-rule.conf
        #   # ./src/wallpaper/default.conf
        # ];

        animations = {
          enabled = true;
          bezier = [
            "linear, 0, 0, 1, 1"
            "md3_standard, 0.2, 0, 0, 1"
            "md3_decel, 0.05, 0.7, 0.1, 1"
            "md3_accel, 0.3, 0, 0.8, 0.15"
            "overshot, 0.05, 0.9, 0.1, 1.1"
            "crazyshot, 0.1, 1.5, 0.76, 0.92 "
            "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
            "fluent_decel, 0.1, 1, 0, 1"
            "easeInOutCirc, 0.85, 0, 0.15, 1"
            "easeOutCirc, 0, 0.55, 0.45, 1"
            "easeOutExpo, 0.16, 1, 0.3, 1"
          ];
          animation = [
            "windows, 1, 3, md3_decel, popin 60%"
            "border, 1, 10, default"
            "fade, 1, 2.5, md3_decel"
            "workspaces, 1, 3.5, easeOutExpo, slide"
            "specialWorkspace, 1, 3, md3_decel, slidevert"
          ];
        };

        decoration = {
          rounding = 10;
          blur = {
            enabled = true;
            size = 12;
            passes = 4;
            new_optimizations = true;
            ignore_opacity = true;
            xray = true;
          };
          active_opacity = 0.8;
          inactive_opacity = 0.8;
          fullscreen_opacity = 1.0;

          drop_shadow = false;
          shadow_range = 30;
          shadow_render_power = 3;
          "col.shadow" = "0x66000000";
        };

        group = {
          groupbar = {
            "col.active" = "$colors_orange";
            "col.inactive" = "$colors_dark";
            "col.locked_active" = "$colors_red";
            "col.locked_inactive" = "$colors_dark";
            font_size = 11;
            gradients = false;
            text_color = "$colors_darker";
          };
          "col.border_active" = "$colors_acccent_color";
          "col.border_inactive" = "$colors_dark";
          "col.border_locked_active" = "$colors_red";
          "col.border_locked_inactive" = "$colors_light_gray";
        };

        general = {
          allow_tearing = false;
          border_size = 4;
          "col.active_border" = "$colors_acccent_color";
          "col.inactive_border" = "$colors_dark";
          "col.nogroup_border" = "0xffffffff";
          "col.nogroup_border_active" = "0xffff00ff";
          extend_border_grab_area = 15;
          gaps_in = 10;
          gaps_out = 20;
          layout = "master";
          no_border_on_floating = false;
          resize_on_border = true;
        };

        bind = [
          "SUPER, Return, exec, terminal"
          "SUPER SHIFT, Return, exec, terminal --float"
          "SUPER, Q, killactive, "
          "SUPER, D, exec, ags toggle-window app-launcher "
          "SUPER SHIFT, Escape, exec, ags -r 'powermenu.toggle()'"

          ",XF86AudioPlay,exec,playerctl play-pause"
          ",XF86AudioPause,exec,playerctl play-pause"
          ",XF86AudioNext,exec,playerctl next "
          ",XF86AudioPrev,exec,playerctl prev"
          ",XF86AudioMute,exec, volume --toggle"
          "SHIFT,XF86AudioMute,exec, volume --toggle-mic"

          ",Print,exec, ags -r 'screenshot.screenshot()' "
          "SHIFT,Print,exec, ags -r 'screenrecord.toggle()'"

          "SUPER, left, movefocus, l"
          "SUPER, right, movefocus, r"
          "SUPER, up, movefocus, u"
          "SUPER, down, movefocus, d"

          "SUPER, h, movefocus, l"
          "SUPER, l, movefocus, r"
          "SUPER, k, movefocus, u"
          "SUPER, j, movefocus, d"

          "SUPER SHIFT, left, movewindow, l"
          "SUPER SHIFT, right, movewindow, r"
          "SUPER SHIFT, up, movewindow, u"
          "SUPER SHIFT, down, movewindow, d"

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

          "SUPER ALT, Space, togglespecialworkspace, 1"
          "SUPER CTRL, Space, movetoworkspace, special:1"

          "SUPER ALT_L, left, workspace, e-1 "
          "SUPER ALT_L, right, workspace, e+1 "

          ", F11, fullscreen, 1"
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

          "SUPER CTRL, left, resizeactive, -25 0"
          "SUPER CTRL, right, resizeactive, 25 0"
          "SUPER CTRL, up, resizeactive, 0 -25"
          "SUPER CTRL, down, resizeactive, 0 25"

          "SUPER CTRL, h, resizeactive, -25 0"
          "SUPER CTRL, l, resizeactive, 25 0"
          "SUPER CTRL, k, resizeactive, 0 -25"
          "SUPER CTRL, j, resizeactive, 0 25"
        ];

        bindm = [
          "SUPER, mouse:273, resizewindow"
          "SUPER, mouse:272, movewindow"
        ];

        windowrulev2 = [
          "float, class:^(com.github.Aylur.ags)$"
          "float,class:^(floating_terminal)$"
          "move center,class:^(floating_terminal)$"
          "pin,title:^(Picture in picture)$"
          "size 1200 650,title:^(Picture in picture)$"
          "move 100%-1220 100%-670,title:^(Picture in picture)$"
          "float,title:^(Picture in picture)$"
          "opacity 1.0,title:^(Picture in picture)$"
          "float, class:^(floating_terminal)$,title:^(pulsemixer)$"
          "move center, class:^(pulsemixer)$,title:^(pulsemixer)$"
          "size 600 300, class:^(pulsemixer)$,title:^(pulsemixer)$"
          "float, class:^(nm-connection-editor)$"
          "move center, class:^(nm-connection-editor)$"
          "workspace 5, class:^(Spotify)$"
          "workspace 2, class:^(microsoft-edge)$, title:^(.*)(- Professional - )(.*)$"
          "workspace 4, class:^(microsoft-edge)$, title:^(.*)(- Personal - )(.*)$"
          "workspace 3, class:^(Slack)$"
          "float,class:^(blueman-manager)$"
          "move center,class:^(blueman-manager)$"
        ];

        input = {
          follow_mouse = 2;
          kb_layout = "fr";
          repeat_delay = 200;
          repeat_rate = 25;

          touchpad = {
            natural_scroll = false;
          };
        };

        gestures = {
          workspace_swipe = true;
        };

        monitor = [
          "DP-1, 3840x2160@144, 0x0, 1, "
          "eDP-1, 1920x1200@60, 0x0, 1, "
        ];

        misc = {
          disable_hyprland_logo = true;
          enable_swallow = true;
          vfr = false;
          vrr = 0; # 0 = off, 1 = on, 2 = fullscreen only
        };

        dwindle = {
          force_split = 2;
          preserve_split = true;
          pseudotile = true;
        };

        master = {
          new_is_master = false;
          no_gaps_when_only = false;
          special_scale_factor = 0.3;
        };

        layerrule = [
          "blur, power-menu"
          # "blur, app-launcher"
        ];

        exec-once = [
          "swaybg -m fill -i $XDG_CONFIG_HOME/hypr/wallpaper.jpg"
          #"/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &"
          "gnome-keyring-daemon --start --components=secrets"
          "nm-applet --indicator"
          "blueman-applet"
          "solaar -w hide -b symbolic & disown"
          "ags"
        ];
      };
    };
  };
}
