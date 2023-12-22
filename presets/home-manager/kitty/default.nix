{ pkgs, ... }:
{
  programs.kitty = {
    enable = true;

    shellIntegration = {
      mode = "no-cursor";
      enableZshIntegration = true;
    };

    font = {
      name = "monospace";
      size = 10;
    };

    settings = {
      font_features = "CartographCF-Regular +ss04";
      # font_features CartographCF-RegularItalic +ss01

      confirm_os_window_close = 0;

      input_delay = 0;
      repaint_delay = 0;
      sync_to_monitor = true;

      # startup_session work.ini

      clear_all_shortcuts = true;

      # THEME
      # background_opacity 0.8
      window_padding_width = 10;
      cursor_shape = "underline";
      cursor_underline_thickness = 1;
      tab_bar_style = "fade";
      tab_fade = 1;
      # tab_title_template "[{layout_name}] {fmt.fg.red}{bell_symbol}{activity_symbol}{fmt.fg.tab}{title}"

      # tab_bar_margin_width 2.0
      tab_bar_margin_height = "0.0 2.0";

      # tab_bar_margin_color    #7cbd27
      # active_tab_foreground   #171a1f
      # active_tab_background   #ecbd10
      # active_tab_font_style   bold
      # inactive_tab_foreground #d8e2e1
      # inactive_tab_background #171a1f
      # inactive_tab_font_style normal

      # foreground #d8e2e1
      # background #292A2B
      # color0       #1D1D1D
      # color1       #CF3746
      # color2       #7CBD27
      # color3       #ECBD10
      # color4       #277AB6
      # color5       #AD4ED2
      # color6       #32B5C7
      # color7       #626861
      #
      # color8       #292A2B
      # color9       #D95473
      # color10      #B6DA74
      # color11      #E7CA62
      # color12      #64A8D8
      # color13      #BC82D37
      # color14      #65CEDC
      # color15      #D8E2E1

      #foreground = "#aeb7b6";
      #background = "#292a2b";

      selection_foreground = "#292a2b";
      selection_background = "#aeb7b6";
      url_color = "#64a8d8";


      foreground = "#b6beca";
      background = "#171a1f";

      # black
      color0 = "#1d1f21";
      color8 = " #626861";

      # red
      color1 = "#cf3746";
      color9 = "#d95473";

      # green
      color2 = "#7cbd27";
      color10 = "#b6da74";

      # yellow
      color3 = "#ecbd10";
      color11 = "#e7ca62";

      # blue
      color4 = "#277ab6";
      color12 = "#64a8d8";

      # magenta
      color5 = "#ad4ed2";
      color13 = "#bc82d3";

      # cyan
      color6 = "#32b5c7";
      color14 = "#65cedc";

      # white
      color7 = "#d8e2e1";
      color15 = "#ebf6f5";


      # Cursor
      cursor = "#FFFFFF";
      cursor_text_color = "#292a2b";

    };

    keybindings = {
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";

      "ctrl+shift+enter" = "new_window";
      "ctrl+shift+w" = "close_window";

      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+q" = "close_tab";
      "ctrl+shift+o" = "next_tab";
      "ctrl+shift+u" = "previous_tab";
      # "ctrl+shift+right" = "next_tab";
      # "ctrl+shift+left" = "previous_tab";
      "ctrl+shift+." = "move_tab_forward";
      "ctrl+shift+," = "move_tab_backward";

      "ctrl+shift+l" = "next_layout";
      "ctrl+shift+alt+t" = "set_tab_title";

      # "ctrl+left" = "neighboring_window left";
      # "ctrl+right" = "neighboring_window right";
      # "ctrl+up" = "neighboring_window up";
      # "ctrl+down" = "neighboring_window down";
      "ctrl+shift+left" = "neighboring_window left";
      "ctrl+shift+right" = "neighboring_window right";
      "ctrl+shift+up" = "neighboring_window up";
      "ctrl+shift+down" = "neighboring_window down";

      "shift+up" = "move_window up";
      "shift+down" = "move_window down";
      "shift+left" = "move_window left";
      "shift+right" = "move_window right";

      "ctrl+shift+equal" = "change_font_size all +2.0";
      "ctrl+shift+plus" = "change_font_size all +2.0";
      "ctrl+shift+kp_add" = "change_font_size all +2.0";
      "ctrl+shift+minus" = "change_font_size all -2.0";
      "ctrl+shift+kp_subtract" = "change_font_size all -2.0";
      "ctrl+shift+backspace" = "change_font_size all 0";


      "ctrl+shift+g" = "show_last_command_output";
      "ctrl+shift+z" = "scroll_to_prompt -1";
      "ctrl+shift+x" = "scroll_to_prompt 1";
      "ctrl+shift+h" = "show_scrollback";

      # "ctrl+shift+up" = "scroll_line_up";
      # "ctrl+shift+down" = "scroll_line_down";

      "ctrl+shift+page_up" = "scroll_page_up";
      "ctrl+shift+page_down" = "scroll_page_down";
      "ctrl+shift+home" = "scroll_home";
      "ctrl+shift+end" = "scroll_end";
    };

  };

}
