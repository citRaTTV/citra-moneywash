Config = {}
Config.maxLaunderedPerCycle = 2000 -- The max amount of marked bills that can be processed per player / character.
Config.payoutPercentage = 0.25 -- The percentage of the marked bills to give to the player. 1.0 would give them 100% of the value.
Config.blipEnabled = true -- Enable / disable blip on the ped (will not show up for LEOs)
Config.ped = 'g_f_y_vagos_01'
Config.pedVoice = "G_F_Y_VAGOS_01_LATINO_MINI_01"
Config.washAnimation = {
    dict = 'anim@mp_player_intupperraining_cash',
    anim = 'idle_a',
    prop = {
        model = joaat('prop_anim_cash_pile_01'),
        bone = '60309',
        coords = {x = 0.0, y = 0.0, z = -0.09},
        rotation = {x = 180.0, y = 0.0, z = 70.0}
    },
}
Config.washLocations = {
        vector4(1130.02, -989.24, 45.97, 92.0),
        vector4(-44.82, 6447.89, 31.48, 139.75),
        vector4(1643.62, 4859.31, 42.01, 97.06),
        vector4(10.07, 3686.53, 39.63, 203.94),
        vector4(403.33, 2586.32, 43.52, 88.5),
        vector4(-205.92, -1586.59, 38.05, 78.6),
        vector4(199.23, -2003.19, 18.86, 228.72),
        vector4(913.01, -1274.18, 27.11, 28.56),
}
Config.washTime = function()
    return math.random(15000, 25000)
end
Config.markedCash = {
    ['name'] = 'markedcash',
    ['label'] = 'Stack of Marked Money',
    ['weight'] = 1,
    ['type'] = 'item',
    ['image'] = 'markedcash.png', -- Be sure to add this image to qb-inventory (or your preferred inventory script)
    ['unique'] = false,
    ['useable'] = false,
    ['shouldClose'] = true,
    ['combinable'] = nil,
    ['description'] = 'Money?'
}
