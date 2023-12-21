setAmbientSoundEnabled( "general", false )
setAmbientSoundEnabled( "gunfire", false )

local BLOCKED_SOUNDS = {
    { 0, 0 },
    { 0, 29 },
    { 0, 30 },

	{ 14, 0 }, 	-- стоящий автомобиль
	{ 14, 1 }, 	-- стоящий автомобиль
	{ 19, 1 }, 	-- начало движения автомобиля
	{ 19, 21 }, 	-- движения автомобиля (гул)
	{ 7, 1 }, 		-- стоящий скутер
	{ 7, 0 }, 		-- скутер в воздухе
    { 19, 10 },
    { 19, 11 },
    { 19, 14 },
    { 19, 26 },

	{ 40 },
	{ 12 },

	-- 550
	{ 13, 0 },
	{ 13, 1 },

	-- 492
	{ 9, 0 },
	{ 9, 1 },

	-- ?
	{ 10, 0 },
	{ 10, 1 },

	-- ?
	{ 11, 0 },
	{ 11, 1 },

	-- ?
	{ 12, 0 },
	{ 12, 1 },

	-- ?
	{ 8, 0 },
	{ 8, 1 },

	-- ?
	{ 16, 0 },
	{ 16, 1 },

	-- Hunter
	{ 18, 0 },
	{ 18, 1 },

	-- Maverick
	{ 19, 3 },
	{ 19, 5 },
	{ 19, 18 },
    { 19, 23 },

    -- Старт машин
    { 15, 0 },
    { 15, 1 },

    -- Пиздёж персонажей
    { 20 },
    { 21 },
    { 22 },
    { 23 },
    { 24 },
    { 25 },
    { 26 },
    { 27 },
    { 28 },
    { 29 },
}

Element.GetID = function( self )
	local element_id = getElementID( self )
	return element_id and tonumber( string_sub( element_id, 2, -1 ) ) or element_id
end

Player.GetUniqueDimension = function( self, increment )
	local increment = tonumber(increment) or 1000
	local diff = 65535 - increment

	local element_id = self:GetID()
	if not element_id then
		return false
	end

	return increment + element_id % diff
end

for i, v in pairs( BLOCKED_SOUNDS ) do
    if not v[2] then
		setWorldSoundEnabled( v[1], false, true )
	else
		setWorldSoundEnabled( v[1], v[2], false, true )
	end
end

function table.copy( obj, seen )
    if type( obj ) ~= 'table' then
        return obj;
    end;

    if seen and seen[ obj ] then
        return seen[ obj ];
    end;

    local s         = seen or {};
    local res       = setmetatable( { }, getmetatable( obj ) );
    s[ obj ]        = res;

    for k, v in pairs( obj ) do
        res[ table.copy(k, s) ] = table.copy( v, s );
    end

    return res;
end


local POLYGONS = { }
local AUDIO_ZONES = {
    {
        id = "countryside",
        condition = function( self )
            return localPlayer.interior == 0 and localPlayer.dimension == 0
        end,
        poly = {
            { x = -1366.877, y = -1989.216 },
            { x = -1338.805, y = -1201.724 },
            { x = -901.534, y = 393.641 },
            { x = -1991.322, y = 1024.65 },
            { x = -3097.561, y = -289.623 },
            { x = -3024.487, y = -2265.6 },
            { x = -1356.161, y = -2213.171 },
            { x = -1366.877, y = -1989.216 },
            
        },
        max_volume = 1.0,
        file = "sfx/ambient_suburb.ogg",
    },
    {
        id = "park_woodcutter",
        poly = {
            { x = 1887.7095, y = 38.6047 },
            { x = 2071.6464, y = 375.3009 },
            { x = 2149.1638, y = 537.2777 },
            { x = 2047.1535, y = 778.7336 },
            { x = 1539.1501, y = 454.3103 },
            { x = 1602.2211, y = 235.908 },
            { x = 1570.317, y = 19.4699 },
            { x = 1887.7095, y = 38.6047 },
        },
        max_volume = 1.0,
        file = "sfx/ambient_suburb.ogg",
        condition = function( self )
            return localPlayer.interior == 0 and localPlayer.dimension == 0
        end,
    },
    {
        id = "mountaints",
        poly = {
            { x = 1241.3353, y = -2835.4075 },
            { x = 1407.3314, y = -2395.4833 },
            { x = 1442.176, y = -1610.0837 },
            { x = 1265.0777, y = -1175.8244 },
            { x = 879.0974, y = -998.0716 },
            { x = 458.0408, y = -1098.354 },
            { x = 480.9191, y = -1584.3072 },
            { x = 707.7287, y = -1597.3825 },
            { x = 840.04, y = -1747.3024 },
            { x = 770.9125, y = -1970.4929 },
            { x = 642.1453, y = -2788.4475 },
            { x = 1241.3353, y = -2835.4075 },
            
        },
        max_volume = 1.0,
        file = "sfx/ambient_suburb.ogg",
        condition = function( self )
            return localPlayer.interior == 0
        end,
    },
    {
        id = "rublevka_island_1",
        poly = {
            { x = -677.8551, y = 929.5834 },
            { x = -1039.4112, y = 1080.1907 },
            { x = -1120.3455, y = 774.0573 },
            { x = -977.1364, y = 607.426 },
            { x = -1053.4348, y = 499.4362 },
            { x = -1440.6437, y = 713.2821 },
            { x = -1874.3472, y = 1033.2271 },
            { x = -1378.5388, y = 1300.5314 },
            { x = -491.8182, y = 1295.2224 },
            { x = -531.2658, y = 1118.3524 },
            { x = -677.8551, y = 929.5834 },
        },
        max_volume = 1.0,
        file = "sfx/ambient_suburb.ogg",
        condition = function( self )
            return localPlayer.interior == 0
        end,
    },
    {
        id = "rublevka_island_2",
        poly = {
            { x = 624.0998, y = 196.7753 },
            { x = -1.8192, y = 815.9378 },
            { x = -34.6956, y = 1146.8243 },
            { x = 1209.5545, y = 1135.6979 },
            { x = 1201.5324, y = 903.2339 },
            { x = 1044.8316, y = 121.0379 },
            { x = 834.2973, y = 120.5087 },
            { x = 624.0998, y = 196.7753 },
        },
        max_volume = 1.0,
        file = "sfx/ambient_suburb.ogg",
        condition = function( self )
            return localPlayer.interior == 0
        end,
    },
    {
        id = "gorki_mountaints",
        poly = {
            { x = 1500.7904, y = -1778.1114 },
            { x = 1910.527, y = -1803.1765 },
            { x = 2292.9824, y = -1895.5541 },
            { x = 2607.6762, y = -1809.382 },
            { x = 2657.9675, y = -682.6012 },
            { x = 2598.4648, y = -436.5925 },
            { x = 2019.9295, y = -119.939 },
            { x = 2424.229, y = 143.8187 },
            { x = 2914.5944, y = -88.7557 },
            { x = 2926.4865, y = -2092.8408 },
            { x = 2445.5446, y = -2803.072 },
            { x = 1427.8691, y = -2567.7396 },
            { x = 1500.7904, y = -1778.1114 },
        },
        max_volume = 1.0,
        file = "sfx/ambient_suburb.ogg",
        condition = function( self )
            return localPlayer.interior == 0
        end,
    },
    {
        id = "city",
        condition = function( self )
            local dimension = localPlayer.dimension
            local uniquet_dimension = localPlayer:GetUniqueDimension( )
            return localPlayer.position.z < 100 and not localPlayer.inWater and localPlayer.interior == 0 and ( dimension == 0 or not uniquet_dimension or dimension == uniquet_dimension )
        end,
        file = "sfx/ambient_city.ogg",
        max_volume = 1.0,
    },
    {
        id = "casino",
        poly = {
            { x = -98.5210, y = -508.1313  },
            { x = -98.7815, y = -476.2350  },
            { x = -34.0361, y = -476.2350  },
            { x = -34.0361, y = -508.1313  },
            { x = -98.5210, y = -508.1313  },
        },
        max_volume = 1.0,
        file = "sfx/amb_casino.ogg",
        condition = function( self )
            return localPlayer.interior == 1 and localPlayer.dimension == 1
        end,
    },

    {
        id = "casino_moscow",
        poly = {
            { x = 2452.4377, y = -1338.2269  },
            { x = 2459.4772, y = -1259.9085  },
            { x = 2343.8083, y = -1244.2005  },
            { x = 2331.5043, y = -1339.8381  },
            { x = 2452.4377, y = -1338.2269  },
        },
        max_volume = 0.4,
        file = "sfx/amb_casino_moscow.ogg",
        condition = function( self )
            return localPlayer.interior == 4 and localPlayer.dimension == 1
        end,
    },
}

for i, v in pairs( AUDIO_ZONES ) do
    if v.poly then
        local poly_args = { }
        for k, n in pairs( v.poly ) do
            table.insert( poly_args, n.x )
            table.insert( poly_args, n.y )
        end
        POLYGONS[ v.id ] = ColShape.Polygon( unpack( poly_args ) )
    end
end

local CURRENT_ZONE

function CreateZone( self )

    self = table.copy( self )

    self.sound = playSound( self.file, true )
    self.sound.volume = 0

    self.Fade = function( self, mode, time )
        if self.is_fading then return end
        self.is_fading = mode
        self.fade_tick = getTickCount()
        if mode == "in" then
            self.fade_from = self.sound.volume
            self.fade_to = self.max_volume or 0.25
        else
            self.fade_from = self.sound.volume
            self.fade_to = 0
        end
        self.fade_duration = time or 5000
        removeEventHandler( "onClientRender", root, self.RenderFade )
        addEventHandler( "onClientRender", root, self.RenderFade )
    end

    self.RenderFade = function()
        local progress = math.min( 1, math.max( 0, ( getTickCount() - self.fade_tick ) / self.fade_duration ) )
        self.sound.volume = interpolateBetween( self.fade_from, 0, 0, self.fade_to, 0, 0, progress, "InQuad" )
        if progress >= 1 then
            self:FadeStop()
        end
    end

    self.FadeStop = function( self )
        self.is_fading = nil
        removeEventHandler( "onClientRender", root, self.RenderFade )
        if self.destroy_on_fade then
            self:destroy()
        end
    end

    self.destroy = function( self )
        removeEventHandler( "onClientRender", root, self.RenderFade )
        if isElement( self.sound ) then
            self.sound:destroy()
        end
        setmetatable( self, nil )
    end

    return self
end

function CheckAudioZones(state)
    local x, y, z = getCameraMatrix()

    local matching_zone
    if state == true then
        for i, v in pairs( AUDIO_ZONES ) do
            match = { }

            -- Любая проверка
            table.insert( match, not v.condition or v:condition( ) )

            -- Проверка по шейпу
            local colshape = POLYGONS[ v.id ]
            if isElement( colshape ) then
                table.insert( match, isInsideColShape( colshape, x, y, z ) )
            end

            local quit = false
            for i, v in pairs( match ) do
                if not v then quit = true break end
            end

            if not quit then
                matching_zone = v
                break
            end
        end


        local matching_zone_id = matching_zone and matching_zone.id
        local current_zone_id = CURRENT_ZONE and CURRENT_ZONE.id

        if matching_zone_id ~= current_zone_id then
            if CURRENT_ZONE then
                if CURRENT_ZONE.is_fading == "in" then
                    CURRENT_ZONE:FadeStop()
                end
                CURRENT_ZONE.destroy_on_fade = true
                CURRENT_ZONE:Fade( "out", 5000 )
                CURRENT_ZONE = nil
            end

            if matching_zone then 
                CURRENT_ZONE = CreateZone( matching_zone )
                CURRENT_ZONE:Fade( "in", 5000 )
            end
        end
    elseif state == false then
        if match then
            table.remove(match)
            matching_zone = nil
            CURRENT_ZONE:Fade( "out", 5000 )
            CURRENT_ZONE.destroy_on_fade = true
            CURRENT_ZONE = nil
        end
    end
end
addEvent("CheckAudioZones", true)
addEventHandler("CheckAudioZones", resourceRoot, CheckAudioZones)

if #AUDIO_ZONES > 0 then
    CheckAudioZones( )
    Timer( CheckAudioZones, 2000, 0 )
end