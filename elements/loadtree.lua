
--[[

Loads all lua files in the given folder,
using love filesystem.


]]

local function default_lua(full_path)
    --[[
        `full_path` is the full path of the file.
    ]]
    local ending = full_path:sub(-4,-1)
    if ending == ".lua" then
        local path = full_path:gsub("/","."):sub(1, -5)
        return require(path)
    end
end


local function remove_exten(fname)
    return fname:gsub("(.*)%..*$","%1")
end



function load_tree(path, shover, func)
    func = func or default_lua

    local directory = love.filesystem.getDirectoryItems(path)

    shover = shover or {}

    for _,fname in ipairs(directory) do
        if fname:sub(1,1) ~= "_" then
            local full_path = path.."/"..fname
            local info = love.filesystem.getInfo(full_path)

            if info.type == "directory" then
                load_tree(full_path, shover, func)
            else
                local proper_name = remove_exten(fname)
                if not shover[proper_name] then
                    shover[proper_name] = func(full_path)
                end
            end
        end
    end

    return shover
end



return load_tree