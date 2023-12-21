handlingLimits = { 
    ["identifier"] = {
        id = 1,
        input = "string",
        limits = { "", "" },
    },
    ["mass"] = {
        id = 2,
        input = "float",
        limits = { "600.0", "3000.0" } -- ЧЕНДЖ
    },
    ["turnMass"] = {
        id = 3,
        input = "float",
        limits = { "600.0", "7000.0" } -- ЧЕНДЖ
    },
    ["dragCoeff"] = {
        id = 4,
        input = "float",
        limits = { "0.0", "5.0" } -- ЧЕНДЖ
    },
    ["centerOfMassX"] = {
        id = 5,
        input = "float",
        limits = { "-1", "1" } -- ЧЕНДЖ
    },
    ["centerOfMassY"] = {
        id = 6,
        input = "float",
        limits = { "-0.4", "0.4" } -- ЧЕНДЖ
    },
    ["centerOfMassZ"] = {
        id = 7,
        input = "float",
        limits = { "-1", "1" } -- ЧЕНДЖ
    },
    ["percentSubmerged"] = {
        id = 8,
        input = "integer",
        limits = { "40", "100" } -- ЧЕНДЖ
    },
    ["tractionMultiplier"] = {
        id = 9,
        input = "float",
        limits = { "0.0", "1.0" } -- ЧЕНДЖ
    },
    ["tractionLoss"] = {
        id = 10,
        input = "float",
        limits = { "0.0", "1.0" } -- ЧЕНДЖ
    },
    ["tractionBias"] = {
        id = 11,
        input = "float",
        limits = { "0.3", "0.7" } -- ЧЕНДЖ
    },
    ["numberOfGears"] = {
        id = 12,
        input = "integer",
        limits = { "1", "5" } -- ЧЕНДЖ
    },
    ["maxVelocity"] = {
        id = 13,
        input = "float",
        limits = { "30.0", "420.0" } -- ЧЕНДЖ
    },
    ["engineAcceleration"] = {
        id = 14,
        input = "float",
        limits = { "0.0", "60.0" } -- ЧЕНДЖ
    },
    ["engineInertia"] = {
        id = 15,
        input = "float",
        limits = { "-1000.0", "1000.0" }
    },
    ["driveType"] = {
        id = 16,
        input = "string",
        limits = { "", "" },
        options = { "f","r","4" }
    },
    ["engineType"] = {
        id = 17,
        input = "string",
        limits = { "", "" },
        options = { "p","d","e" }
    },
    ["brakeDeceleration"] = {
        id = 18,
        input = "float",
        limits = { "0.1", "15.0" } -- ЧЕНДЖ
    },
    ["brakeBias"] = {
        id = 19,
        input = "float",
        limits = { "0.0", "1.0" } -- ЧЕНДЖ
    },
    ["ABS"] = {
        id = 20,
        input = "boolean",
        limits = { "", "" },
        options = { "true","false" }
    },
    ["steeringLock"] = {
        id = 21,
        input = "float",
        limits = { "0.0", "85.0" } -- ЧЕНДЖ
    },
    ["suspensionForceLevel"] = {
        id = 22,
        input = "float",
        limits = { "0.0", "4.0" } -- ЧЕНДЖ
    },
    ["suspensionDamping"] = {
        id = 23,
        input = "float",
        limits = { "0.0", "10.0" } -- ЧЕНДЖ
    },
    ["suspensionHighSpeedDamping"] = {
        id = 24,
        input = "float",
        limits = { "0.0", "4.0" } -- ЧЕНДЖ
    },
    ["suspensionUpperLimit"] = {
        id = 25,
        input = "float",
        limits = { "0", "0" } -- ЧЕНДЖ
    },
    ["suspensionLowerLimit"] = {
        id = 26,
        input = "float",
        limits = { "-0.5", "0" } -- ЧЕНДЖ
    },
    ["suspensionFrontRearBias"] = {
        id = 27,
        input = "float",
        limits = { "0.3", "0.7" } -- ЧЕНДЖ
    },
    ["suspensionAntiDiveMultiplier"] = {
        id = 28,
        input = "float",
        limits = { "0", "1" } -- ЧЕНДЖ
    },
    ["seatOffsetDistance"] = {
        id = 29,
        input = "float",
        limits = { "0.2", "2.0" } -- ЧЕНДЖ
    },
    ["collisionDamageMultiplier"] = {
        id = 30,
        input = "float",
        limits = { "0.5", "1.0" } -- ЧЕНДЖ
    },
    ["monetary"] = {
        id = 31,
        input = "integer",
        limits = { "0", "0" } -- ЧЕНДЖ
    },
    ["modelFlags"] = {
        id = 32,
        input = "hexadecimal",
        limits = { "", "" },
    },
    ["handlingFlags"] = {
        id = 33,
        input = "hexadecimal",
        limits = { "", "" },
    },
    ["headLight"] = {
        id = 34,
        input = "integer",
        limits = { "0", "3" },
        options = { 0,1,2,3 }
    },
    ["tailLight"] = {
        id = 35,
        input = "integer",
        limits = { "0", "3" },
        options = { 0,1,2,3 }
    },
    ["animGroup"] = {
        id = 36,
        input = "integer",
        limits = { "0", "30" }
    }
}

propertyID = {}
for k,v in pairs ( handlingLimits ) do
    propertyID[v.id] = k
end