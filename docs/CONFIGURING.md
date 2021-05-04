Configuring
===========

Camera settings
---------------

The freecam accepts a few configuration values. These can be changed
programmatically like so:

```lua
local Freecam = exports['fivem-freecam']
Freecam:SetCameraSetting('EASING_DURATION', 2500)
```

Full list of camera settings and their default values:

```lua
--Camera
FOV = 45.0

-- On enable/disable
ENABLE_EASING = true
EASING_DURATION = 1000

-- Keep position/rotation
KEEP_POSITION = false
KEEP_ROTATION = false
```

> **Note:** FOV is applied upon entering the freecam. To change the FOV when
> the camera is already active, use [SetFov](EXPORTS.md#setfov).

- [SetCameraSetting](EXPORTS.md#setcamerasetting)
- [SetFov](EXPORTS.md#setfov)

Control mapping
---------------

It's possible to change the controls of the freecam. Controls are defined for
keyboards and gamepads and can be changed individually:

```lua
local Freecam = exports['fivem-freecam']
Freecam:SetKeyboardControl('MOVE_X', INPUT_MOVE_LR)
Freecam:SetGamepadControl('MOVE_Y', INPUT_MOVE_UD)
```

> Input names are taken from the [FiveM docs][fivem-docs].
> Use their corresponding control ID in your own code.

- [SetKeyboardControl](EXPORTS.md#setkeyboardcontrol)
- [SetGamepadControl](EXPORTS.md#setgamepadcontrol)


Adjustable **keyboard** mapping and their default controls:

```lua
-- Rotation
LOOK_X = INPUT_LOOK_LR
LOOK_Y = INPUT_LOOK_UD

-- Position
MOVE_X = INPUT_MOVE_LR
MOVE_Y = INPUT_MOVE_UD
MOVE_Z = { INPUT_PARACHUTE_BRAKE_LEFT, INPUT_PARACHUTE_BRAKE_RIGHT }

-- Multiplier
MOVE_FAST = INPUT_SPRINT
MOVE_SLOW = INPUT_CHARACTER_WHEEL
```

Adjustable **gamepad** mapping and their default controls:

```lua
-- Rotation
LOOK_X = INPUT_LOOK_LR
LOOK_Y = INPUT_LOOK_UD

-- Position
MOVE_X = INPUT_MOVE_LR
MOVE_Y = INPUT_MOVE_UD
MOVE_Z = { INPUT_PARACHUTE_BRAKE_RIGHT, INPUT_PARACHUTE_BRAKE_LEFT }

-- Multiplier
MOVE_FAST = INPUT_VEH_ACCELERATE
MOVE_SLOW = INPUT_VEH_BRAKE
```

Control settings
----------------

Control settings such as move speed multipliers and camera move sensitivity can
also be changed through settings:

```lua
local Freecam = exports['fivem-freecam']
Freecam:SetKeyboardSetting('LOOK_SENSITIVITY_X', 5)
Freecam:SetGamepadSetting('LOOK_SENSITIVITY_X', 2)
```

- [SetKeyboardSetting](EXPORTS.md#setkeyboardsetting)
- [SetGamepadSetting](EXPORTS.md#setgamepadsetting)

Adjustable **keyboard** settings and their default values:

```lua
-- Rotation
LOOK_SENSITIVITY_X = 5
LOOK_SENSITIVITY_Y = 5

-- Position
BASE_MOVE_MULTIPLIER = 1
FAST_MOVE_MULTIPLIER = 10
SLOW_MOVE_MULTIPLIER = 10
```

Adjustable **gamepad** settings and their default values:

```lua
-- Rotation
LOOK_SENSITIVITY_X = 2
LOOK_SENSITIVITY_Y = 2

-- Position
BASE_MOVE_MULTIPLIER = 1
FAST_MOVE_MULTIPLIER = 10
SLOW_MOVE_MULTIPLIER = 10
```

[fivem-docs]: https://docs.fivem.net/game-references/controls/