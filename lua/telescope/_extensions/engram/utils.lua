
local function read_json(path)
    local file = io.open(path, "r")
    if not file then return nil end

    local content = file:read("*a")
    file:close()
    return vim.json.decode(content)

end


return {
    read_json = read_json
}
