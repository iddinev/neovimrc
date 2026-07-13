-- vim: set shiftwidth=2 expandtab:

-- OS DEPENDENCIES
-- nerdfonts
-- noto-fonts-emoji
-- neovim-treesitter/nvim-treesitter:
-- -- tree-sitter
-- ibhagwan/fzf-lua:
-- -- fzf
-- -- fd
-- -- rg
-- -- bat

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
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      winopts = {
        preview = {
          title = false,
          horizontal = "right:50%",
        },
      },
      keymap = {
        builtin = {
          -- WORKAROUND: these sit next to the defaults (can be seen with the help window F1)
          -- currently defaults can't explicitly be remmaped
          ["<M-S-k>"] = "preview-page-up",
          ["<M-S-j>"] = "preview-page-down",
          ["<M-S-h>"] = "preview-top",
          ["<M-S-l>"] = "preview-bottom",
        },
      },
      fzf_opts = {
        ["--wrap=word"] = true
      },
    },
    keys = function()
      local fzf = require("fzf-lua")
      return {
        { "<F1>",   fzf.buffers,            desc = "Buffers" },
        { "<F7>",   fzf.files,              desc = "Files" },
        { "<C-f>",  fzf.live_grep,          desc = "Live Grep" },
        { "<C-h>",  fzf.helptags,           desc = "Help Tags" },
        { "<C-r>",  fzf.command_history,    desc = "Command History" },
      }
    end,
  },

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
          Folded = { bg = colors.none },
          GitSignsAdd = { bold = true },
          GitSignsChange = { bold = true },
          GitSignsDelete = { bold = true },
          GitSignsCurrentLineBlame = { bold = true },
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
    "neovim-treesitter/nvim-treesitter",
    dependencies = {
      "neovim-treesitter/treesitter-parser-registry",
    },

    lazy = false,
    build = ":TSUpdate",

    config = function()
      local ts = require("nvim-treesitter")

      ts.setup()

      local languages = {
        "bash",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "go",
        "javascript",
        "toml",
        "vim",
        "vimdoc",
        "yaml",
      }

      ts.install(languages)

      local filetypes = {}

      for _, lang in ipairs(languages) do
        local ok, fts = pcall(vim.treesitter.language.get_filetypes, lang)
        if ok then
          vim.list_extend(filetypes, fts)
        end
      end

      local group = vim.api.nvim_create_augroup("Treesitter", { clear = true })

      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = filetypes,

        callback = function(ev)
          vim.treesitter.start(ev.buf)

          vim.wo[0].foldmethod = "expr"
          vim.wo[0].foldexpr = "v:lua.vim.treesitter.foldexpr()"

          vim.bo[ev.buf].indentexpr =
            "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = "VeryLazy",

    opts = {
      select = {
        lookahead = true,
      },

      move = {
        set_jumps = true,
      },
    },

    config = function(_, opts)
      require("nvim-treesitter-textobjects").setup(opts)

      local select = require("nvim-treesitter-textobjects.select")
      local move = require("nvim-treesitter-textobjects.move")
      local swap = require("nvim-treesitter-textobjects.swap")

      -- Select
      for _, mode in ipairs({ "x", "o" }) do
        vim.keymap.set(mode, "af", function()
          select.select_textobject("@function.outer", "textobjects", mode)
        end)

        vim.keymap.set(mode, "if", function()
          select.select_textobject("@function.inner", "textobjects", mode)
        end)

        vim.keymap.set(mode, "ac", function()
          select.select_textobject("@class.outer", "textobjects", mode)
        end)

        vim.keymap.set(mode, "ic", function()
          select.select_textobject("@class.inner", "textobjects", mode)
        end)

        vim.keymap.set(mode, "aa", function()
          select.select_textobject("@parameter.outer", "textobjects", mode)
        end)

        vim.keymap.set(mode, "ia", function()
          select.select_textobject("@parameter.inner", "textobjects", mode)
        end)
      end

      -- Move
      vim.keymap.set({ "n", "x", "o" }, "]f", function()
        move.goto_next_start("@function.outer", "textobjects")
      end)

      vim.keymap.set({ "n", "x", "o" }, "[f", function()
        move.goto_previous_start("@function.outer", "textobjects")
      end)

      vim.keymap.set({ "n", "x", "o" }, "]F", function()
        move.goto_next_end("@function.outer", "textobjects")
      end)

      vim.keymap.set({ "n", "x", "o" }, "[F", function()
        move.goto_previous_end("@function.outer", "textobjects")
      end)

      vim.keymap.set({ "n", "x", "o" }, "]c", function()
        move.goto_next_start("@class.outer", "textobjects")
      end)

      vim.keymap.set({ "n", "x", "o" }, "]C", function()
        move.goto_next_end("@class.outer", "textobjects")
      end)

      vim.keymap.set({ "n", "x", "o" }, "[c", function()
        move.goto_previous_start("@class.outer", "textobjects")
      end)

      vim.keymap.set({ "n", "x", "o" }, "[C", function()
        move.goto_previous_end("@class.outer", "textobjects")
      end)

      -- Swap
      vim.keymap.set("n", "<leader>a", function()
        swap.swap_next("@parameter.inner")
      end)

      vim.keymap.set("n", "<leader>A", function()
        swap.swap_previous("@parameter.inner")
      end)
    end,
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

  {
      "chrisgrieser/nvim-origami",
      event = "VeryLazy",
      opts = {
        foldKeymaps = { setup = false, },
        pauseFoldsOnSearch = false,
      },
  },

  {
    'lcheylus/overlength.nvim',
     opts = {
       highlight_to_eol = false,
       disable_ft = { 'GV', 'help', 'helpdoc' }
     },
  },

  -- GIT
  {
    'tpope/vim-fugitive',
  },

  {
    "junegunn/gv.vim",
    dependencies = { "tpope/vim-fugitive" },
    init = function()
      vim.api.nvim_create_user_command("GVA", function(opts)
        vim.cmd({ cmd = "GV", args = { "--all" }, bang = opts.bang })
      end, {
        bang = true,
      })
    end,
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "GV",
        callback = function()
          vim.opt_local.listchars:remove("trail")
        end,
      })
    end,
  },

  {
    'sindrets/diffview.nvim',
    opts = {},
  },

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

        map('n', '[h', function()
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

  -- SESSIONS
  {
    "mhinz/vim-startify",
    lazy = false,

    init = function()
        vim.g.startify_lists = {
            { type = "sessions",  header = { "   Sessions" } },
            { type = "commands",  header = { "   Commands" } },
            { type = "files",     header = { "   MRU" } },
            { type = "dir",       header = { "   MRU " .. vim.fn.getcwd() } },
            { type = "bookmarks", header = { "   Bookmarks" } },
        }

        -- Automatically save the current session when quitting or
        -- before loading another session.
        vim.g.startify_session_persistence = 1

        -- Store sessions outside projects.
        vim.g.startify_session_dir =
            vim.fn.stdpath("state") .. "/sessions"

        vim.fn.mkdir(vim.g.startify_session_dir, "p")

        -- Show newest sessions first.
        vim.g.startify_session_sort = 1

        -- Keep more sessions.
        vim.g.startify_session_number = 20

        -- Keep existing buffers when restoring.
        vim.g.startify_session_delete_buffers = 0

        vim.g.startify_session_before_save = {
            'echo "Saving session..."',
        }

        -- Optional
        vim.g.startify_relative_path = 1
        vim.g.startify_update_oldfiles = 1
    end,
  },

})
