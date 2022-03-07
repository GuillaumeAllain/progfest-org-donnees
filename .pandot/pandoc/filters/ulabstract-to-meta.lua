--[[
ulabstract-to-meta – move an "ulabstract" section into document metadata

Copyright: © 2017–2020 Albert Krewinkel
License:   MIT – see LICENSE file for details
]]
local ulabstract = {}

--- Extract ulabstract from a list of blocks.
function ulabstract_from_blocklist (blocks)
  local body_blocks = {}
  local looking_at_ulabstract = false

  for _, block in ipairs(blocks) do
    if block.t == 'Header' and block.level == 1 then
      if block.identifier == 'ulabstract' then
        looking_at_ulabstract = true
      else
        looking_at_ulabstract = false
        body_blocks[#body_blocks + 1] = block
      end
    elseif looking_at_ulabstract then
      ulabstract[#ulabstract + 1] = block
    else
      body_blocks[#body_blocks + 1] = block
    end
  end

  return body_blocks
end

if PANDOC_VERSION >= {2,9,2} then
  -- Check all block lists with pandoc 2.9.2 or later
  return {{
      Blocks = ulabstract_from_blocklist,
      Meta = function (meta)
        if not meta.ulabstract and #ulabstract > 0 then
          meta.ulabstract = pandoc.MetaBlocks(ulabstract)
        end
        return meta
      end
  }}
else
  -- otherwise, just check the top-level block-list
  return {{
      Pandoc = function (doc)
        local meta = doc.meta
        local other_blocks = ulabstract_from_blocklist(doc.blocks)
        if not meta.ulabstract and #ulabstract > 0 then
          meta.ulabstract = pandoc.MetaBlocks(ulabstract)
        end
        return pandoc.Pandoc(other_blocks, meta)
      end,
  }}
end
