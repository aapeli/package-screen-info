gl.setup(NATIVE_WIDTH, NATIVE_HEIGHT)

local font = resource.load_font "Ubuntu-C.ttf"
local json = require "json"

local serial = sys.get_env "SERIAL"
local location = "<ladataan…>"
local description = "<…>"

local res = util.resource_loader{
    "device_details.png";
}

local logo = resource.create_colored_texture(0,0,0,0)
local white = resource.create_colored_texture(1,1,1,1)

util.file_watch("config.json", function(raw)
    local config = json.decode(raw)
    logo = resource.load_image(config.logo.asset_name)
end)

util.data_mapper{
    ["device_info"] = function(info)
        info = json.decode(info)
        location = info.location
        description = info.description
    end
}

local function draw_info()
    local s = HEIGHT/10
    font:write(s, s*0.5, "Bom Screen Player", s, 1,1,1,1)
    white:draw(0, s*1.6-2, WIDTH, s*1.6+2, 0.2)

    local width_of_player_number = font:width(description, s)
    font:write(WIDTH-width_of_player_number-s, s*0.5, description, s, 1,1,.5,1)

    font:write(s, s*1.75, "S/N "..serial, s, 1,1,1,1)    
    
    font:write(s, s*3.75, location, s, 1,1,1,1)
    if res.device_details then
        res.device_details:draw(s, s*5, s*5.5, s*9.5)
    end
    util.draw_correct(logo, WIDTH-s*5.5, s*5, WIDTH-s, s*9.5)
end

function node.render()
    gl.clear(0,0,0,1)
    draw_info()
end
