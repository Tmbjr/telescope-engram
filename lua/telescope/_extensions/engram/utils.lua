local ns = vim.api.nvim_create_namespace('engram')
local width = vim.api.nvim_win_get_width(0)
local DIVIDER = string.rep('_', width - 7)

local function read_json(path)
    local file = io.open(path, "r")
    if not file then return nil end

    local content = file:read("*a")
    file:close()
    return vim.json.decode(content)

end

local function add_lines(table_lines, text)
    for _, line in ipairs(vim.split(text, '\n')) do
        table.insert(table_lines, line)
    end
end


local function build_page(data, lines)

    local headers = {}
    local dividers = {}


    add_lines(lines, '' .. data.name)
    add_lines(lines, DIVIDER)
    table.insert(dividers, #lines - 1)
    add_lines(lines, '')
    add_lines(lines, 'Signatures')
    table.insert(headers, #lines - 1)
    for _, sig in ipairs(data.signatures) do
        add_lines(lines, '\t' .. sig)
        add_lines(lines, '')
    end
    add_lines(lines, DIVIDER)
    table.insert(dividers, #lines - 1)
    add_lines(lines, '')
    add_lines(lines, 'Description')
    table.insert(headers, #lines - 1)
    for _, desc in ipairs(data.description) do
        add_lines(lines, '\t' .. desc)
        add_lines(lines, '')
    end
    add_lines(lines, DIVIDER)
    table.insert(dividers, #lines - 1)
    add_lines(lines, '')
    add_lines(lines, 'Parameters')
    table.insert(headers, #lines - 1)
    for _, param in ipairs(data.parameters) do
        add_lines(lines, '\t' .. param)
        add_lines(lines, '')
    end
    add_lines(lines, DIVIDER)
    table.insert(dividers, #lines - 1)
    add_lines(lines, '')
    add_lines(lines, 'Return Value')
    table.insert(headers, #lines - 1)
    for _, ret in ipairs(data['return value']) do
        add_lines(lines, '\t' .. ret)
    end
    add_lines(lines, DIVIDER)
    table.insert(dividers, #lines - 1)
    add_lines(lines, '')
    add_lines(lines, 'Complexity')
    table.insert(headers, #lines - 1)
    for _, comp in ipairs(data.complexity) do
        add_lines(lines, '\t' .. comp)
    end
    add_lines(lines, DIVIDER)
    table.insert(dividers, #lines - 1)
    add_lines(lines, '')
    add_lines(lines, 'Exceptions')
    table.insert(headers, #lines - 1)
    for _, ex in ipairs(data.exceptions) do
        add_lines(lines, '\t' .. ex)
    end
    add_lines(lines, DIVIDER)
    table.insert(dividers, #lines - 1)
    add_lines(lines, '')
    add_lines(lines, 'Notes')
    table.insert(headers, #lines - 1)
    for _, note in ipairs(data.notes) do
        add_lines(lines, '\t' .. note)
    end
    return headers, dividers
end


local function highlight(headers, dividers, buf)
    vim.hl.range(buf, ns, 'Error', {0, 0}, {0, -1})

    for _, lnum in ipairs(headers) do
        vim.hl.range(buf, ns, 'String', {lnum, 0}, {lnum, -1})
    end

    for _, lnum in ipairs(dividers) do
        vim.hl.range(buf, ns, 'Keyword', {lnum, 0}, {lnum, -1})
    end
end


return {
    read_json = read_json,
    build_page = build_page,
    highlight = highlight,
}
