local file = "conf.txt"
local text = "WheelsPosition = {"
local i = 1
local veh = nil
local skip = false

local vehicleIds = {400, 401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 411, 412, 413, 414, 415,
	416, 417, 418, 419, 420, 421, 422, 423, 424, 425, 426, 427, 428, 429, 430, 431, 432, 433,
	434, 435, 436, 437, 438, 439, 440, 441, 442, 443, 444, 445, 446, 447, 448, 449, 450, 451,
	452, 453, 454, 455, 456, 457, 458, 459, 460, 461, 462, 463, 464, 465, 466, 467, 468, 469,
	470, 471, 472, 473, 474, 475, 476, 477, 478, 479, 480, 481, 482, 483, 484, 485, 486, 487,
	488, 489, 490, 491, 492, 493, 494, 495, 496, 497, 498, 499, 500, 501, 502, 503, 504, 505,
	506, 507, 508, 509, 510, 511, 512, 513, 514, 515, 516, 517, 518, 519, 520, 521, 522, 523,
	524, 525, 526, 527, 528, 529, 530, 531, 532, 533, 534, 535, 536, 537, 538, 539, 540, 541,
	542, 543, 544, 545, 546, 547, 548, 549, 550, 551, 552, 553, 554, 555, 556, 557, 558, 559,
	560, 561, 562, 563, 564, 565, 566, 567, 568, 569, 570, 571, 572, 573, 574, 575, 576, 577,
	578, 579, 580, 581, 582, 583, 584, 585, 586, 587, 588, 589, 590, 591, 592, 593, 594, 595,
	596, 597, 598, 599, 600, 601, 602, 603, 604, 605, 606, 607, 608, 609, 610, 611
}

sx, sy = guiGetScreenSize()
px, py = sx/1920, sy/1080

function drawProgress ()
	dxDrawProgressBar (sx/2-400*px, sy-70*py, 800*px, 50*py, i/#vehicleIds, tocolor (0, 180, 0, 200), tocolor(0, 0, 0, 100))
end

function hideComp (veh)
	local getComponent = getVehicleComponents(veh)
	for k in pairs (getComponent) do
		setVehicleComponentVisible(veh, k, false)
	end
end

addEvent ("startWriteWheels", true)
addEventHandler ("startWriteWheels", resourceRoot, function()
	text = "WheelsPosition = {\n"
	addCar()
	addEventHandler ("onClientRender", root, drawProgress)
end)

function addCar ()
	if not isElement(veh) then
		local x, y, z = getElementPosition (localPlayer)
		veh = createVehicle (vehicleIds[i], x, y + 15, z + 15)
		veh.frozen = true
		veh.alpha = 0
		hideComp (veh)
		setTimer (addCar, 200, 1) 
		return
	end
	if veh.model ~= vehicleIds[i] then
		setElementModel (veh, vehicleIds[i])
		hideComp (veh)
		veh.frozen = true
	end
	
	if veh.vehicleType ~= "Automobile" then 
		if i + 1 == #vehicleIds then
			i = #vehicleIds
			text = text.."\n}"
			resaveFile ()
			return
		else
			setTimer (addCar, 10, 1) 
			i = i + 1 
			return 
		end
	end
	
	
	
	local text1 = ""
	
	local x1, y1, z1 = getVehicleComponentPosition (veh, "wheel_lf_dummy")
	local x2, y2, z2 = getVehicleComponentPosition (veh, "wheel_rf_dummy")
	local x3, y3, z3 = getVehicleComponentPosition (veh, "wheel_lb_dummy")
	local x4, y4, z4 = getVehicleComponentPosition (veh, "wheel_rb_dummy")
	
	text1 = string.format ([[
	[%s] = {
        wheel_lf_dummy = {%s, %s, %s},
        wheel_rf_dummy = {%s, %s, %s},
        wheel_lb_dummy = {%s, %s, %s},
        wheel_rb_dummy = {%s, %s, %s},
	},
	]], vehicleIds[i], x1 or 0, y1 or 0, z1 or 0, x2 or 0, y2 or 0, z2 or 0, x3 or 0, y3 or 0, z3 or 0, x4 or 0, y4 or 0, z4 or 0)
	text = text..text1
	if i == #vehicleIds then
		text = text.."\n}"
		resaveFile ()
	else
		setTimer (addCar, 10, 1)
		i = i + 1
	end
end



function resaveFile ()
	removeEventHandler ("onClientRender", root, drawProgress)
	triggerServerEvent ("resavewheels", resourceRoot, text)
	destroyElement (veh)
	outputChatBox ("Машины прописаны!", 0, 255, 0)
	i = 1
	veh = nil
	collectgarbage()
end