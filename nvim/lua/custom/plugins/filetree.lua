
return {
  "nvim-neo-tree/neo-tree.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
  },
  config = function ()
    require("neo-tree").setup({
    default_component_configs = {
      indent_markers = {
        enable = true,
      },
    },
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,
        hide_by_name = {
          ".DS_Store",
          "thumbs.db"
          -- You can add more files/folders to the list that you want to hide.
        },
      },
      follow_current_file = {
        enabled = true, -- This makes Neo-tree follow the current file.
      }
    },
    event_handlers = {
      {
        event = "file_opened",
        handler = function(file_path)
          require("neo-tree").focus_on_file(file_path, false)
        end,
      },
    },
  })
  end,
}
