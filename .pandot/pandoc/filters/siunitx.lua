local number_pattern = "%d+%.?%d*[eE]?[+-]?%d*"
local function replace_si(inlinetype, mathtype, sistring)
    local sipattern = "("..number_pattern.."){(.+)}"
    local number = sistring:gsub(sipattern, "%1")
    local unit = sistring:gsub(sipattern, "%2")
    local si_object = nil

    if inlinetype=="Str" or inlinetype=="RawInline" then
        if FORMAT=='latex' then
            si_object=pandoc.RawInline ('latex', "\\SI{"..number.."}{"..unit.."}")
        elseif FORMAT=="html" or FORMAT=="html5" then
            si_object=pandoc.RawInline('html','<span class="phy-quantity"><span class="phy-number">'..number..'</span><span class="phy-unit">'..unit..'</span></span>')
        else
            si_object=pandoc.Str(number.." "..unit)
        end
    elseif inlinetype=='Math' then
        if FORMAT=='latex' then
            si_object=pandoc.Math (mathtype, "\\SI{"..number.."}{"..unit.."}")
        else
            si_object=pandoc.Math(mathtype,number.."; \\text{"..unit.."}")
        end
    end
    return si_object
end

local function replace_around( inlinetype, inlineformat, around_string )
    local around_object = nil

    if inlinetype=='Math' then
        around_object = pandoc.Math (inlineformat,around_string)
    elseif inlinetype=='RawInline' then
        around_object = pandoc.RawInline (inlineformat,around_string)
    else
        around_object = pandoc.Str (around_string)
    end

    return around_object
end


local function catch_and_replace_si (inlines)
    local in_pattern = "(.-%s-)("..number_pattern.."{.*)"
    local out_pattern = "(.-%})(.*)"
    local full_pattern = "(.-%s-)("..number_pattern.."){(.-)}(.*)"
    local block_inlines = {}
    local looking_at_unit = false
    local unit_backup = {}
    local unit_string = ''
    local valid_inline = {Str=true, RawInline=true, Math=true}
    local stringformat = ''
    for _, inline in ipairs(inlines) do
            if valid_inline[inline.t] then

                if inline.t=="Str" then
                    stringformat = ""
                elseif inline.t=="RawInline" then
                    stringformat = inline.format
                elseif inline.t=="Math" then
                    stringformat = inline.mathtype
                else
                    stringformat = ""
                end

                if looking_at_unit then
                    if looking_at_unit then
                        if inline.text:find(out_pattern) then
                            unit_string = unit_string..inline.text:gsub(out_pattern,"%1")
                            -- CATCHED
                            block_inlines[#block_inlines+1] = replace_si (inline.t,stringformat,unit_string)
                            -- Post unit
                            block_inlines[#block_inlines+1] = replace_around (inline.t,stringformat,inline.text:gsub(out_pattern,"%2"))
                            unit_string = ""
                            unit_backup = {}
                            looking_at_unit = false
                        else
                            unit_string = unit_string..inline.text
                            unit_backup[#unit_backup+1] = inline
                        end

                    else
                        block_inlines[#block_inlines+1] = inline
                    end
                elseif inline.text:find(full_pattern) then

                    -- Pre Unit
                    block_inlines[#block_inlines+1] =replace_around (inline.t, stringformat, inline.text:gsub(full_pattern,"%1"))

                    -- CATCHED
                    block_inlines[#block_inlines+1] = replace_si (inline.t,stringformat,inline.text:gsub(full_pattern,"%2{%3}"))

                    -- POST unit
                    block_inlines[#block_inlines+1] =replace_around (inline.t, stringformat, inline.text:gsub(full_pattern,"%4"))
                elseif inline.text:find(in_pattern) then

                    -- Pre unit
                    block_inlines[#block_inlines+1] =replace_around (inline.t, stringformat, inline.text:gsub(in_pattern,"%1"))
                    -- being siunit
                    unit_string = unit_string..inline.text:gsub(in_pattern,"%2")
                    unit_backup[#unit_backup+1] = inline
                    looking_at_unit = true
                else 
                    block_inlines[#block_inlines+1] = inline
                end
            elseif inline.t=="Space" then
                if looking_at_unit then
                    unit_string = unit_string.." "
                    unit_backup[#unit_backup+1] = inline
                else 
                    block_inlines[#block_inlines+1] = inline
                end
            else 
                block_inlines[#block_inlines+1] = inline
            end
    end
    if looking_at_unit then
        for _,v in ipairs(unit_backup) do
            table.insert(block_inlines, v)
        end
    end

    return block_inlines
end


return {{
    Inlines = catch_and_replace_si,
}}
