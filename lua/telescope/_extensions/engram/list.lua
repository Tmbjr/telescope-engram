local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local teleconfig = require('telescope.config').values

local test = function(opts)
    opts = opts or {}
    pickers.new(opts, {
        prompt_title = "Search a Term",
        finder = finders.new_table {
            results = { "this", "is", "a", "test"}
        },
        sorter = teleconfig.generic_sorter(opts),
    }):find()
end


test(require("telescope.themes").get_dropdown {})

