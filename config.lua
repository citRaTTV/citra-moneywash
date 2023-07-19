Config = {}
Config.maxLaunderedPerCycle = 2000 -- The max amount of marked bills that can be processed per player / character.
Config.payoutPercentage = 0.25 -- The percentage of the marked bills to give to the player. 1.0 would give them 100% of the value.
Config.ped = 'g_f_y_vagos_01'
Config.pedVoice = "G_F_Y_VAGOS_01_LATINO_MINI_01"
Config.useQBTarget = false -- Currently not implemented
Config.washAnimation = {
    dict = 'anim@mp_player_intupperraining_cash',
    anim = 'idle_a',
    prop = {
        model = GetHashKey('prop_anim_cash_pile_01'),
        bone = '60309',
        coords = {x = 0.0, y = 0.0, z = -0.09},
        rotation = {x = -80.0, y = 0.0, z = 0.0}},
}
Config.washLocations = {
    {
        coords = vector4(1130.02, -989.24, 45.97, 92.0),
        ped = nil, -- Don't modify. Used to track peds
    },
    {
        coords = vector4(-44.82, 6447.89, 31.48, 139.75),
        ped = nil, -- Don't modify. Used to track peds
    },
}
Config.washTime = function()
    return math.random(15000, 25000)
end
Config.markedCash = {
    ['name'] = 'markedcash',
    ['label'] = 'Stack of Marked Money',
    ['weight'] = 10,
    ['type'] = 'item',
    ['image'] = 'markedcash.png', -- Be sure to add this image to qb-inventory (or your preferred inventory script)
    ['unique'] = false,
    ['useable'] = false,
    ['shouldClose'] = true,
    ['combinable'] = nil,
    ['description'] = 'Money?'
}
