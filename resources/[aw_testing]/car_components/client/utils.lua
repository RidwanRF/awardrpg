function isResourceRunning(resName)
    local res = getResourceFromName(resName)
    return (res) and (getResourceState(res) == "running")
end

function table.copy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[table.copy(orig_key)] = table.copy(orig_value)
        end
        setmetatable(copy, table.copy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function rotatePointAroundPointOnXY(pivot, point, angle)
	return {
		x = pivot.x + (point.x-pivot.x)*math.cos(angle) - (point.y-pivot.y)*math.sin(angle),
		y = pivot.y + (point.y-pivot.y)*math.cos(angle) + (point.x-pivot.x)*math.sin(angle),
		z = point.z,
	}
end

function rotatePointAroundPointOnYZ(pivot, point, angle)
	return {
		x = point.x,
		y = pivot.y + (point.y-pivot.y)*math.cos(angle) - (point.z-pivot.z)*math.sin(angle),
		z = pivot.z + (point.z-pivot.z)*math.cos(angle) + (point.y-pivot.y)*math.sin(angle),
	}
end
