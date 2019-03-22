FiveM Freecam
=============

Simple freecam API for FiveM.

Features
--------

- Easy to use freecam API
- Improved state accuracy over native GTA
- Moves with the minimap
- Adjustable moving speed

Usage
-----

In your `__resource.lua`:
```lua
dependency 'freecam'
client_script 'script.lua'
```

In your `script.lua`:
```lua
-- Toggles the freecam by pressing F5
Citizen.CreateThread(function ()
  local Freecam = exports.freecam
  while true do
    Citizen.Wait(0)
    if IsDisabledControlJustPressed(0, 166) then
      local isActive = Freecam:IsActive()
      Freecam:SetActive(not isActive)
    end
  end
end)
```

Controls
--------

Movement:
- W and S to move forward and backward
- A and D to move left and right
- Q and E to move up and down

Modifiers:
- Shift to move faster
- Alt to move slower


Exports
-------

### IsActive
### SetActive
### IsFrozen
### SetFrozen
### GetFov
### SetFov
### GetTarget
### GetPosition
### SetPosition
### GetRotation
### SetRotation
### GetPitch
### GetRoll
### GetYaw

Events
------

### freecam:onFreecamUpdate
