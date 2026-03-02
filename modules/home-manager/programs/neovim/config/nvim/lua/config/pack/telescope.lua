return {
  'nvim-telescope/telescope.nvim',
  lazy = false,

  deps = {
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    { 'folke/trouble.nvim' },
  },
  config = function()
    local telescope = require('telescope')
    local actions = require('telescope.actions')
    local builtin = require('telescope.builtin')

    telescope.setup({
      defaults = {
        vimgrep_arguments = {
          'rg',
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
          '--smart-case',
        },
        prompt_prefix = '     ',
        selection_caret = '  ',
        entry_prefix = '  ',
        multi_icon = ' + ',
        initial_mode = 'insert',
        selection_strategy = 'reset',
        sorting_strategy = 'ascending',
        layout_strategy = 'vertical',
        layout_config = {
          -- width = 0.75,
          -- prompt_position  "bottom",
          -- preview_cutoff = 90,
          horizontal = {
            mirror = false,
          },
          vertical = {
            -- width = 0.5,
            mirror = true,
            prompt_position = 'top',
          },
        },
        file_sorter = require('telescope.sorters').get_fuzzy_file,
        file_ignore_patterns = { 'node_modules' },
        generic_sorter = require('telescope.sorters').get_generic_fuzzy_sorter,
        winblend = 0,
        border = {},
        borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
        color_devicons = true,
        use_less = true,
        set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
        file_previewer = require('telescope.previewers').vim_buffer_cat.new,
        grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
        qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,

        -- Developer configurations: Not meant for general override
        buffer_previewer_maker = require('telescope.previewers').buffer_previewer_maker,

        mappings = {
          i = {
            ['<C-q>'] = actions.send_to_qflist,
            ['<C-n>'] = false,
            ['<C-p>'] = false,
            ['<C-j>'] = actions.move_selection_next,
            ['<C-k>'] = actions.move_selection_previous,
            ['<C-t>'] = function(...) require('trouble.sources.telescope').open(...) end,
            ['<esc>'] = actions.close,
          },
        },
      },
      pickers = {
        colorscheme = {
          enable_preview = true,
        },
      },
    })

    -- Lazy extension loader — loads extensions on first picker invocation
    -- so async clones have time to finish
    local extensions_loaded = false
    local function ensure_extensions()
      if extensions_loaded then return end
      pcall(telescope.load_extension, 'fzf')
      pcall(telescope.load_extension, 'pretty_pickers')
      pcall(telescope.load_extension, 'ui-select')
      extensions_loaded = true
    end

    local function pretty(method, opts)
      ensure_extensions()
      local ok, pp = pcall(require, 'telescope._extensions.pretty_pickers')
      if ok then
        telescope.extensions.pretty_pickers[method](opts)
      else
        -- Fallback to builtin if pretty_pickers isn't available yet
        vim.notify('telescope-pretty-pickers not available, using builtin', vim.log.levels.WARN)
        if method == 'files' then
          builtin[opts.picker or 'find_files'](opts.options or {})
        elseif method == 'grep' then
          builtin[opts.picker or 'live_grep'](opts.options or {})
        elseif method == 'workspace_symbols' then
          builtin.lsp_workspace_symbols(opts)
        elseif method == 'document_symbols' then
          builtin.lsp_document_symbols(opts)
        elseif method == 'lsp_references' then
          builtin.lsp_references(opts)
        elseif method == 'grapple' then
          vim.notify('Grapple picker requires pretty_pickers', vim.log.levels.WARN)
        end
      end
    end

    -- Define custom pickers
    local recent_files = function()
      local utils = require('utils')

      pretty('files', {
        picker = 'oldfiles',
        options = {
          prompt_title = 'Recent Files',
          cwd = utils.get_root(),
          cwd_only = true,
        },
      })
    end

    local project_files = function()
      local opts = {}

      if vim.uv.fs_stat('.git') then
        opts.show_untracked = true
        opts.prompt_title = 'Git Files'

        pretty('files', {
          picker = 'git_files',
          options = opts,
        })
      else
        local client = vim.lsp.get_clients()[1]

        if client then opts.cwd = client.config.root_dir end

        pretty('files', {
          prompt_title = 'Project Files',
          picker = 'find_files',
          options = opts,
        })
      end
    end

    local config_files = function()
      pretty('files', {
        picker = 'find_files',
        options = { prompt_title = 'Config Files', cwd = vim.fn.stdpath('config'), cwd_only = true },
      })
    end

    local find_text = function()
      pretty('grep', {
        picker = 'live_grep',
      })
    end

    local grapple_pick = function()
      pretty('grapple', {
        prompt_title = 'Pinned Files',
      })
    end

    -- LSP related pickers
    local workspace_symbols = function()
      pretty('workspace_symbols', {
        prompt_title = 'Workspace Goodies',
      })
    end

    local document_symbols = function()
      pretty('document_symbols', {
        prompt_title = 'Document Goodies',
      })
    end

    local lsp_references = function()
      pretty('lsp_references', {
        prompt_title = 'Language Server References',
      })
    end

    -- Custom commands
    vim.api.nvim_create_user_command('FindFiles', project_files, {})
    vim.api.nvim_create_user_command('RecentFiles', recent_files, {})
    vim.api.nvim_create_user_command('FindText', find_text, {})
    vim.api.nvim_create_user_command('GrapplePick', grapple_pick, {})
    vim.api.nvim_create_user_command('ConfigFiles', config_files, {})

    -- Mappings
    --
    -- File search
    vim.keymap.set('n', '<leader>f', project_files, { desc = 'Find files' })
    vim.keymap.set('n', '<leader>r', recent_files, { desc = 'Recent files' })
    vim.keymap.set('n', '<leader>/', find_text, { desc = 'Global search' })
    vim.keymap.set('n', '<leader><leader>', grapple_pick, { desc = 'Pick from Grapple' })

    -- LSP search
    vim.keymap.set('n', '<leader>ws', workspace_symbols, { desc = 'Workspace symbols' })
    vim.keymap.set('n', '<leader>ds', document_symbols, { desc = 'Document symbols' })
    vim.keymap.set('n', 'gr', lsp_references, { desc = 'LSP references' })

    -- Utils
    vim.keymap.set('n', "<leader>'", builtin.resume, {
      desc = 'Resume the last opened telescope prompt',
    })
  end,
}
