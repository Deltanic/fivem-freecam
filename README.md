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

Configuring
-----------

The freecam accepts a few configuration values. These can be changed
programmatically like so:

```lua
local Freecam = exports.freecam
Freecam:SetConfig('easingDuration', 2500)
```

Full list of configuration keys and their default values:

```lua
local config = {
  --Camera
  fov = 45.0,

  -- Mouse
  mouseSensitivityX = 5,
  mouseSensitivityY = 5,

  -- Movement
  baseMoveMultiplier = 1,
  fastMoveMultiplier = 10,
  slowMoveMultiplier = 10,

  -- On enable/disable
  enableEasing = true,
  easingDuration = 1000
}
```

> **Note:** FOV is applied upon entering the freecam. To change the FOV when
> the camera is already active, use [SetFov](#SetFov).

Exports
-------

### IsActive
Returns wether the freecam is currently active or not.

```
bool isActive = exports.freecam:IsActive()
```

### SetActive
Enters or exits the freecam.

```
void exports.freecam:SetActive(bool active)
```

### GetConfig
Returns the value of a configuration key.
See [Configuring](#configuring) for details.

```
mixed value = exports.freecam:GetConfig(string key)
```

### SetConfig
Sets the value of a configuration key.
See [Configuring](#configuring) for details.

```
void exports.freecam:SetConfig(string key, mixed value)
```

### IsFrozen
Returns wether the freecam position is currently frozen.

```
bool isFrozen = exports.freecam:IsFrozen()
```

### SetFrozen
Sets the freecam frozen. When frozen, controls do not update the position or
rotation anymore but [SetPosition](#setposition)/[SetRotation](#setrotation) will.

```
void exports.freecam:SetFrozen(bool frozen)
```

### GetFov
Returns the field of view of the freecam.

```
float fov = exports.freecam:GetFov()
```

### SetFov
Sets the field of view of the freecam. This does NOT update the default FOV for
the freecam. Use [SetConfig](#setconfig) for that.

```
void exports.freecam:SetFov(float fov)
```

### GetTarget
Returns the position the freecam is looking at from the given distance.

```
vector3 target = exports.freecam:GetTarget(float distance)
```

### GetPosition
Returns the current position of the freecam.

```
vector3 position = exports.freecam:GetPosition()
```

### SetPosition
Sets a new position for the freecam.

```
void exports.freecam:SetPosition(vector3 position)
void exports.freecam:SetPosition(float posX, float posY, float posZ)
```

### GetRotation
Returns the current rotation of the freecam.

```
vector3 rotation = exports.freecam:GetRotation()
```

### SetRotation
Sets a new position for the freecam.

```
void exports.freecam:SetRotation(vector3 rotation)
void exports.freecam:SetRotation(float rotX, float rotY, float rotZ)
```

### GetPitch
Returns the current pitch (rotX) of the freecam.

```
float pitch = exports.freecam:GetPitch()
```

### GetRoll
Returns the current roll (rotY) of the freecam.

```
float roll = exports.freecam:GetRoll()
```

### GetYaw
Returns the current yaw (rotZ) of the freecam.

```
float yaw = exports.freecam:GetYaw()
```

Events
------

### freecam:onTick

Called every tick for as long as the freecam is active. Calls after any
positional or rotational updates so anything attached to the freecam stays
in sync. Not called when the freecam is inactive.

No values are passed to this event.

```lua
local Freecam = exports.freecam
AddEventHandler('freecam:onTick', function ()
  -- Gets the current target position of the freecam.
  local target = Freecam:GetTarget(50)
end)
