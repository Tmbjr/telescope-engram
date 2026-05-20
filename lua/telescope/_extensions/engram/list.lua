local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local previewers = require('telescope.previewers')
local teleconfig = require('telescope.config').values

local utils = require('telescope._extensions.engram.utils')
local json_data = utils.read_json('/Users/tmbjr/workspace/github.com/tmbjr/engram/data/test.json')

local DIVIDER = string.rep("_", 80)

local engram = function(opts)
    opts = opts or {}
    pickers.new(opts, {
        prompt_title = "Engram",
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
                local function add_lines(table_lines, text)
                    for _, line in ipairs(vim.split(text, '\n')) do
                        table.insert(table_lines, line)
                    end
                end

                add_lines(lines, "" .. data.name)
                add_lines(lines, DIVIDER)
                add_lines(lines, "")
                add_lines(lines, "Signatures")
                for _, sig in ipairs(data.signatures) do
                    add_lines(lines, "\t" .. sig)
                    add_lines(lines, "")
                end
                add_lines(lines, DIVIDER)
                add_lines(lines, "")
                add_lines(lines, "Description")
                for _, desc in ipairs(data.description) do
                    add_lines(lines, "\t" .. desc)
                    add_lines(lines, "")
                end
                add_lines(lines, DIVIDER)
                add_lines(lines, "")
                add_lines(lines, "Parameters")
                for _, param in ipairs(data.parameters) do
                    add_lines(lines, "\t" .. param)
                    add_lines(lines, "")
                end
                add_lines(lines, DIVIDER)
                add_lines(lines, "")
                add_lines(lines, "Return Value")
                for _, ret in ipairs(data["return value"]) do
                    add_lines(lines, "\t" .. ret)
                end
                add_lines(lines, DIVIDER)
                add_lines(lines, "")
                add_lines(lines, "Complexity")
                for _, comp in ipairs(data.complexity) do
                    add_lines(lines, "\t" .. comp)
                end
                add_lines(lines, DIVIDER)
                add_lines(lines, "")
                add_lines(lines, "Exceptions")
                for _, ex in ipairs(data.exceptions) do
                    add_lines(lines, "\t" .. ex)
                end
                add_lines(lines, DIVIDER)
                add_lines(lines, "")
                add_lines(lines, "Notes")
                for _, note in ipairs(data.notes) do
                    add_lines(lines, "\t" .. note)
                end

                vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
                vim.wo[status.preview_win].wrap = true
            end
        }),
    }):find()
end


engram()

