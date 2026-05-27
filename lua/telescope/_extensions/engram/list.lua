local action_state = require('telescope.actions.state')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local previewers = require('telescope.previewers')
local teleconfig = require('telescope.config').values
local actions = require('telescope.actions')

local utils = require('telescope._extensions.engram.utils')

local plugin_root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h:h:h:h")
local json_path = plugin_root .. '/data/test.json'

local json_data = utils.read_json(json_path)

local engram = function(opts)
    opts = opts or {}
    pickers.new(opts, {
        prompt_title = 'Engram',
        finder = finders.new_table {
            results = json_data,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = entry.name,
                    ordinal = entry.name,
                }
            end
        },

        sorter = teleconfig.generic_sorter(opts),
        previewer = previewers.new_buffer_previewer({
            define_preview = function(self, entry, status)
                local lines = {}
                local data = entry.value

                local headers, dividers = utils.build_page(data, lines)

                vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
                utils.highlight(headers, dividers, self.state.bufnr)


                vim.wo[status.preview_win].wrap = true
            end
        }),
        attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
                local entry = action_state.get_selected_entry()
                actions.close(prompt_bufnr)

                local buf = vim.api.nvim_create_buf(false, true)
                local lines = {}
                local data = entry.value

                local headers, dividers = utils.build_page(data, lines)

                vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

                utils.highlight(headers, dividers, buf)

                vim.bo[buf].modifiable = false
                vim.keymap.set('n', 'q', function()
                    vim.api.nvim_buf_delete(buf, {force = true})
                end, {buffer = buf, silent = true})
                vim.api.nvim_buf_set_name(buf, "Engram: 'q' to exit")
                vim.api.nvim_set_current_buf(buf)

                local win = vim.api.nvim_get_current_win()
                vim.wo[win].wrap = true
                vim.wo[win].linebreak = true


            end)
            return true
        end
    }):find()
end


return engram

