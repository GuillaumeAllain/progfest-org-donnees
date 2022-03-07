--[[
ulresume-to-meta – move an "ulresume" section into document metadata

Copyright: © 2017–2020 Albert Krewinkel
License:   MIT – see LICENSE file for details
]]
local ulresume = {}

--- Extract ulresume from a list of blocks.
function ulresume_from_blocklist (blocks)
  local body_blocks = {}
  local looking_at_ulresume = false

  for _, block in ipairs(blocks) do
    if block.t == 'Header' and block.level == 1 then
      if block.identifier == 'ulresume' then
        looking_at_ulresume = true
      else
        looking_at_ulresume = false
        body_blocks[#body_blocks + 1] = block
      end
    elseif looking_at_ulresume then
      ulresume[#ulresume + 1] = block
    else
      body_blocks[#body_blocks + 1] = block
    end
  end

  return body_blocks
end

if PANDOC_VERSION >= {2,9,2} then
  -- Check all block lists with pandoc 2.9.2 or later
  return {{
      Blocks = ulresume_from_blocklist,
      Meta = function (meta)
        if not meta.ulresume and #ulresume > 0 then
          meta.ulresume = pandoc.MetaBlocks(ulresume)
        end
        return meta
      end
  }}
else
  -- otherwise, just check the top-level block-list
  return {{
      Pandoc = function (doc)
        local meta = doc.meta
        local other_blocks = ulresume_from_blocklist(doc.blocks)
        if not meta.ulresume and #ulresume > 0 then
          meta.ulresume = pandoc.MetaBlocks(ulresume)
        end
        return pandoc.Pandoc(other_blocks, meta)
      end,
  }}
end
