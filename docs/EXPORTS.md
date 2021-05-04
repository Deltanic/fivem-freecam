Exports
=======
<!-- C# code blocks are used for convenient syntax highlighting. -->

Exported freecam functions.

> Examples assume you are referencing the freecam exports as such:
> ```lua
> local Freecam = exports['fivem-freecam']
> Freecam:SetActive(true)
> ```

### Getters
- [IsActive](#IsActive)
- [IsFrozen](#IsFrozen)
- [GetFov](#GetFov)
- [GetPosition](#GetPosition)
- [GetRotation](#GetRotation)
- [GetMatrix](#GetMatrix)
- [GetTarget](#GetTarget)
- [GetPitch](#GetPitch)
- [GetRoll](#GetRoll)
- [GetYaw](#GetYaw)
- [GetCameraSetting](#GetCameraSetting)
- [GetKeyboardSetting](#GetKeyboardSetting)
- [GetGamepadSetting](#GetGamepadSetting)
- [GetKeyboardControl](#GetKeyboardControl)

### Setters
- [SetActive](#SetActive)
- [SetFrozen](#SetFrozen)
- [SetFov](#SetFov)
- [SetPosition](#SetPosition)
- [SetRotation](#SetRotation)
- [SetCameraSetting](#SetCameraSetting)
- [SetKeyboardSetting](#SetKeyboardSetting)
- [SetGamepadSetting](#SetGamepadSetting)
- [SetKeyboardControl](#SetKeyboardControl)
- [SetGamepadControl](#SetGamepadControl)

---

`IsActive`
----------
Returns wether the freecam is currently active or not.

```c#
bool isActive = Freecam:IsActive()
```

`SetActive`
-----------
Enters or exits the freecam.

```c#
void Freecam:SetActive(bool active)
```

`IsFrozen`
----------
Returns wether the freecam position is currently frozen.

```c#
bool isFrozen = Freecam:IsFrozen()
```

`SetFrozen`
-----------
Sets the freecam frozen. When frozen, controls do not update the position or
rotation anymore but [SetPosition](#setposition)/[SetRotation](#setrotation) will.

```c#
void Freecam:SetFrozen(bool frozen)
```

`GetFov`
--------
Returns the field of view of the freecam.

```c#
float fov = Freecam:GetFov()
```

`SetFov`
--------
Sets the current field of view of the freecam. This does NOT update the default
FOV for the freecam. Use [SetCameraSetting](#setcamerasetting) for that.

```c#
void Freecam:SetFov(float fov)
```

`GetPosition`
-------------
Returns the current position of the freecam.

```c#
vector3 position = Freecam:GetPosition()
```

`SetPosition`
-------------
Sets a new position for the freecam.

```c#
void Freecam:SetPosition(float posX, float posY, float posZ)
```

`GetRotation`
-------------
Returns the current rotation of the freecam.

```c#
vector3 rotation = Freecam:GetRotation()
```

`SetRotation`
-------------
Sets a new position for the freecam.

```c#
void Freecam:SetRotation(float rotX, float rotY, float rotZ)
```

`GetMatrix`
-----------
Returns the current view matrix of the freecam.

```c#
vector3 vecX, vector3 vecY, vector3 vecZ, vector3 pos = Freecam:GetMatrix()
```

`GetTarget`
-----------
Returns the position the freecam is looking at from the given distance.

```c#
vector3 target = Freecam:GetTarget(float distance)
```

`GetPitch`
----------
Returns the current pitch (rotX) of the freecam.

```c#
float pitch = Freecam:GetPitch()
```

`GetRoll`
---------
Returns the current roll (rotY) of the freecam.

```c#
float roll = Freecam:GetRoll()
```

`GetYaw`
--------
Returns the current yaw (rotZ) of the freecam.

```c#
float yaw = Freecam:GetYaw()
```

`GetCameraSetting`
------------------
Returns the value of a camera setting.
See [CONFIGURING](CONFIGURING.md#camera-settings) for details.

```c#
mixed value = Freecam:GetCameraSetting(string key)
```

`SetCameraSetting`
------------------
Sets the value of a camera setting.
See [CONFIGURING](CONFIGURING.md#camera-settings) for details.

```c#
void Freecam:SetCameraSetting(string key, mixed value)
```

`GetKeyboardSetting`
--------------------
Returns the value of a keyboard setting.
See [CONFIGURING](CONFIGURING.md#control-settings) for details.

```c#
mixed value = Freecam:GetKeyboardSetting(string key)
```

`SetKeyboardSetting`
--------------------
Sets the value of a keyboard setting.
See [CONFIGURING](CONFIGURING.md#control-settings) for details.

```c#
void Freecam:SetKeyboardSetting(string key, mixed value)
```

`GetGamepadSetting`
-------------------
Returns the value of a gamepad setting.
See [CONFIGURING](CONFIGURING.md#control-settings) for details.

```c#
mixed value = Freecam:GetGamepadSetting(string key)
```

`SetGamepadSetting`
-------------------
Sets the value of a gamepad setting.
See [CONFIGURING](CONFIGURING.md#control-settings) for details.

```c#
void Freecam:SetGamepadSetting(string key, mixed value)
```

`GetKeyboardControl`
--------------------
Returns the value of a keyboard control.
See [CONFIGURING](CONFIGURING.md#control-mapping) for details.

```c#
mixed value = Freecam:GetKeyboardControl(string key)
```

`SetKeyboardControl`
--------------------
Sets the value of a keyboard control.
See [CONFIGURING](CONFIGURING.md#control-mapping) for details.

```c#
void Freecam:SetKeyboardControl(string key, int value)
void Freecam:SetKeyboardControl(string key, table value)
```

`GetGamepadControl`
-------------------
Returns the value of a gamepad control.
See [CONFIGURING](CONFIGURING.md#control-mapping) for details.

```c#
mixed value = Freecam:GetGamepadControl(string key)
```

`SetGamepadControl`
-------------------
Sets the value of a gamepad control.
See [CONFIGURING](CONFIGURING.md#control-mapping) for details.

```c#
void Freecam:SetGamepadControl(string key, int value)
void Freecam:SetGamepadControl(string key, table value)
```
