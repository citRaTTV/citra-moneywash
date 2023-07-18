# citra-moneywash
A simple script for QBCore to clean dirty money, marked bills, and marked stacks of cash. Based off of [apolo_moneywash](https://github.com/ApoloManCz/apolo_moneywash-QB) by [TG_Development](https://forum.cfx.re/u/tg_development/summary). Huge thanks to them for their work and allowing me to share this modified version with the community!

## Installation
Installation is as simple as adding `citra-moneywash` to your resource folder and adding `ensure citra-moneywash` to your `server.cfg`.

## Configuration
All customization can be done in `config.lua`.
#### Options
* Config.maxLaunderedPerCycle: The total amount of dirty / marked money that can be laundered per restart.
* Config.payoutPercentage: The percentage of actual cash that the player receives. This value should be between 0.0 (0%) and 1.0 (100%).
* Config.ped: The ped stationed at the washing locations. A list of peds can be found [here](https://docs.fivem.net/docs/game-references/ped-models/).
* Config.pedVoice: The voice for the ped to use. A list of ped voices can be found [here](https://gist.githubusercontent.com/alexguirre/0af600eb3d4c91ad4f900120a63b8992/raw/3d7e8e30ad4ce6f361c9e1b41e0a57c8f939a30a/Speeches.txt)
* Config.useQBTarget: Not implemented yet.
* Config.washAnimation: Animation arguments passed to `progressbar`. This animation will be played while laundering money.
* Config.washLocations: Where to spawn peds and launder money. Format should be as follows:
    ```lua
        {
            coords = vector4(X, Y, Z, W),
            ped = nil, -- Don't modify. Used to track peds
        },
    ```
* Config.washTime: A random amount of time (in ms) for laundering to take. Format is `math.random(MIN, MAX)`. Can be set to a static time:
    ```lua
        Config.washtime = 20000 -- 20 seconds
    ```
