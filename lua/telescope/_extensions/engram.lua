local has_telescope, telescope = pcall(require, 'telescope')
if not has_telescope then
    error('engram requires nvim-telescope/telescope.nvim')
end

return telescope.register_extension({
    setup = function(ext_config, config)
        local key = (ext_config and ext_config.keympap) or "<leader>en"
        vim.keymap.set("n", key, function()
            require("telescope").extensions.engram.list()
        end, { desc = "Engram: Seach STL Documentation"})
    end,
    exports = {
        list = require("telescope._extensions.engram.list")
    },
})
