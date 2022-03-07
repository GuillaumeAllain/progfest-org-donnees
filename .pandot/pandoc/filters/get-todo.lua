local function get_todo_blocks(doc)

    local body_blocks = {}
    local top_header_level = 60
    local looking_at_todo = false

    for _, block in ipairs(doc.blocks) do
        if block.t == 'Header' then
            if block.content[1].text=='TODO' or block.content[1].text=='DONE' then
                looking_at_todo = true
                body_blocks[#body_blocks + 1] = pandoc.Header(block.level, block.content, pandoc.Attr())
                if top_header_level == 60 then
                    top_header_level = block.level
                end
            elseif looking_at_todo and block.level>top_header_level then
                body_blocks[#body_blocks + 1] = pandoc.Header(block.level, block.content, pandoc.Attr())
            else
                looking_at_todo = false
                top_header_level = 60
                -- body_blocks[#body_blocks + 1] = block
            end
        elseif looking_at_todo then
            if block.c[1].text=='TODO' or block.c[1].text=='DONE' then
                -- print(block.content[2:])
                body_blocks[#body_blocks + 1] = pandoc.Header(top_header_level+1, block.content, pandoc.Attr())
            else
                body_blocks[#body_blocks + 1] = block
            end

        elseif block.t == 'Para' then
            if block.c[1].text=='TODO' or block.c[1].text=='DONE' then
                body_blocks[#body_blocks + 1] = pandoc.Header(1, block.content, pandoc.Attr())
                -- body_blocks[#body_blocks + 1] = block
            end
        end
    end

    return pandoc.Pandoc(body_blocks,doc.meta)
end


return {
    {Pandoc = get_todo_blocks}
}
