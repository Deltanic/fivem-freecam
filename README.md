FiveM Freecam
=============

Simple freecam API for FiveM.

Features
--------

- Easy to use freecam API
- Improved state accuracy over native GTA
- Moves with the minimap
- Adjustable moving speed
- Support for keyboard and gamepads
- Fully configurable

Controls
--------

These are the default controls for the freecam. Keep in mind controls may be
different depending on your game settings or keyboard layout.

> Controls can be customized by [configuring the freecam](docs/CONFIGURING.md#control-mapping).

### Keyboard

- Mouse to look around
- W and S to move forward and backward
- A and D to move left and right
- Q and E to move up and down
- Alt to slow down
- Shift to speed up

### Gamepad

- Left joystick to move around
- Right joystick to look around
- Left button to move down
- Right button to move up
- Left trigger to slow down
- Right trigger to speed up

Usage
-----

In your `fxmanifest.lua`:
```lua
dependency 'fivem-freecam'
client_script 'script.lua'
```

In your `script.lua`:
```lua
local Freecam = exports['fivem-freecam']

-- Toggles the freecam by pressing F5
Citizen.CreateThread(function ()
  while true do
    Citizen.Wait(0)
    if IsDisabledControlJustPressed(0, 166) then
      local isActive = Freecam:IsActive()
      Freecam:SetActive(not isActive)
    end
  end
end)
```

Documentation
-------------

- [Configuring](docs/CONFIGURING.md)
- [Functions](docs/EXPORTS.md)
- [Events](docs/EVENTS.md)
