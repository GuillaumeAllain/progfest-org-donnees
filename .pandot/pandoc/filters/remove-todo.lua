function remove_todo_blocks (doc)

  local body_blocks = {}
  local top_header_level = 60
  local looking_at_todo = false

  for _, block in ipairs(doc.blocks) do
      if block.t == 'Header' then
          if block.content[1].text=='TODO' or block.content[1].text=='DONE' then
              looking_at_todo = true
              if top_header_level == 60 then
                  top_header_level = block.level
              end
          elseif looking_at_todo and block.level>top_header_level then
          else
              looking_at_todo = false
              body_blocks[#body_blocks + 1] = block
              top_header_level = 60
          end
      elseif not looking_at_todo then 
          if (block.c[1].text~='TODO' 
              and block.c[1].text~='DONE') then
              body_blocks[#body_blocks + 1] = block
          else 
              -- body_blocks[#body_blocks + 1] = block
          end
      end
  end

  return pandoc.Pandoc(body_blocks,doc.meta)
end


return {{
    Pandoc = remove_todo_blocks,
}}
