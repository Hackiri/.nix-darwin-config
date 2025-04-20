{ config, pkgs, theme, ... }: {
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      manager = {
        show_hidden = true;
        ratio = [1 2 5];
      };
      theme = {
        manager = {
          tab_normal.bg = {hex = theme.colors.bg;};
          tab_normal.fg = {hex = theme.colors.comment;};
          tab_select.bg = {hex = theme.colors.bg;};
          tab_select.fg = {hex = theme.colors.blue;};
          border_symbol = "│";
          border_style.fg = {hex = theme.colors.blue0;};
          selection.bg = {hex = theme.colors.blue0;};
          selection.fg = {hex = theme.colors.fg;};
          status_normal.bg = {hex = theme.colors.bg;};
          status_normal.fg = {hex = theme.colors.fg_dark;};
          status_select.bg = {hex = theme.colors.blue0;};
          status_select.fg = {hex = theme.colors.fg;};
          folder.fg = {hex = theme.colors.blue;};
          link.fg = {hex = theme.colors.green1;};
          exec.fg = {hex = theme.colors.green;};
        };
        preview = {
          hovered.bg = {hex = theme.colors.bg_highlight;};
          hovered.fg = {hex = theme.colors.fg;};
        };
        input = {
          border.fg = {hex = theme.colors.blue;};
          title.fg = {hex = theme.colors.fg_dark;};
          value.fg = {hex = theme.colors.fg;};
          selected.bg = {hex = theme.colors.blue0;};
        };
        completion = {
          border.fg = {hex = theme.colors.blue;};
          selected.bg = {hex = theme.colors.blue0;};
        };
        tasks = {
          border.fg = {hex = theme.colors.blue;};
          selected.bg = {hex = theme.colors.blue0;};
        };
        which = {
          mask.bg = {hex = theme.colors.bg;};
          desc.fg = {hex = theme.colors.comment;};
          selected.bg = {hex = theme.colors.blue0;};
          selected.fg = {hex = theme.colors.fg;};
        };
      };
    };
  };
}
