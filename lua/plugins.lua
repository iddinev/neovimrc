-- vim: set shiftwidth=2 expandtab:

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.o.shell = "/usr/bin/bash"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

  -- UI
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    opts = {
      auto_integrations = true,
      flavour = "macchiato",
      custom_highlights = function(colors)
        return {
          TreesitterContext = { bg = colors.surface0 },
          TreesitterContextLineNumber = { bg = colors.base },
          TreesitterContextBottom = { style = {} },
        }
      end,
      integrations = {
        lualine = {
          all = function(colors)
            local c_override = { bg = colors.surface1, gui = "bold" }
            return {
              normal   = { c = c_override },
              insert   = { c = c_override },
              visual   = { c = c_override },
              replace  = { c = c_override },
              command  = { c = c_override },
              terminal = { c = c_override },
              inactive = { c = { bg = colors.mantle } },
            }
          end,
        },
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    name = "lualine",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      tabline = {
        lualine_a = {
          {
            "tabs",
            mode = 2,
            max_length = vim.o.columns,
            fmt = function(name)
              return name
            end,
          },
        },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
    },
  },

  -- SYNTAX
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",

    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPost",

    opts = {
      enable = true,

      max_lines = 0, -- 0 = no limit
      min_window_height = 0,

      line_numbers = true,
      multiwindow = true,

      multiline_threshold = 20, -- collapse long blocks

      trim_scope = "outer", -- keep outer context clean

      mode = "topline", -- cursor | topline

      separator = nil, -- or "-" for visual separation

      zindex = 20,

      on_attach = nil, -- leave nil unless custom logic needed
    },
  },

  -- GIT
  {
    -- No reset hunk index functionality as of writing.
    -- Consider mini.nvim or other gitsign plugins.
    "lewis6991/gitsigns.nvim",
    name = "gitsigns",
    opts = {
      signs = {
        add          = { text = "+" },
        change       = { text = "*" },
        delete       = { text = "−" }, -- UTF 2212
        topdelete    = { text = "−" }, -- UTF 2212
        changedelete = { text = "~" },
      },

      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'right_align', -- 'eol' | 'overlay' | 'right_align'
        delay = 100,
        ignore_whitespace = false,
        virt_text_priority = 100,
        use_focus = true,
      },


      on_attach = function(bufnr)
        local gitsigns = require('gitsigns')

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']h', function()
          if vim.wo.diff then
            vim.cmd.normal({']h', bang = true})
          else
            gitsigns.nav_hunk('next')
          end
        end)

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal({'[c', bang = true})
          else
            gitsigns.nav_hunk('prev')
          end
        end)

        -- Actions
        map('n', '<leader>hs', gitsigns.stage_hunk)
        map('n', '<leader>hr', gitsigns.reset_hunk)

        map('v', '<leader>hs', function()
          gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end)

        map('v', '<leader>hr', function()
          gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end)

        map('n', '<leader>hS', gitsigns.stage_buffer)
        map('n', '<leader>hR', gitsigns.reset_buffer)
        map('n', '<leader>hp', gitsigns.preview_hunk)
        map('n', '<leader>hi', gitsigns.preview_hunk_inline)

        map('n', '<leader>hb', function()
          gitsigns.blame_line({ full = true })
        end)

        map('n', '<leader>hd', gitsigns.diffthis)

        map('n', '<leader>hD', function()
          gitsigns.diffthis('~')
        end)

        map('n', '<leader>hQ', function() gitsigns.setqflist('all') end)
        map('n', '<leader>hq', gitsigns.setqflist)

        -- Toggles
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
        map('n', '<leader>tw', gitsigns.toggle_word_diff)

        -- Text object
        map({'o', 'x'}, 'ih', gitsigns.select_hunk)
      end,
    },
  },

})

vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    vim.treesitter.start(args.buf)
  end,
})
local ts_select = require("nvim-treesitter-textobjects.select")

vim.keymap.set({ "x", "o" }, "af", function()
  ts_select.select_textobject("@function.outer")
end)

vim.keymap.set({ "x", "o" }, "if", function()
  ts_select.select_textobject("@function.inner")
end)

vim.keymap.set({ "x", "o" }, "ac", function()
  ts_select.select_textobject("@class.outer")
end)

vim.keymap.set({ "x", "o" }, "ic", function()
  ts_select.select_textobject("@class.inner")
end)
