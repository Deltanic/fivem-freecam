Exports
=======

`IsActive`
----------
Returns wether the freecam is currently active or not.

```
bool isActive = exports.freecam:IsActive()
```

`SetActive`
-----------
Enters or exits the freecam.

```
void exports.freecam:SetActive(bool active)
```

`IsFrozen`
----------
Returns wether the freecam position is currently frozen.

```
bool isFrozen = exports.freecam:IsFrozen()
```

`SetFrozen`
----------
Sets the freecam frozen. When frozen, controls do not update the position or
rotation anymore but [SetPosition](#setposition)/[SetRotation](#setrotation) will.

```
void exports.freecam:SetFrozen(bool frozen)
```

`GetFov`
--------
Returns the field of view of the freecam.

```
float fov = exports.freecam:GetFov()
```

`SetFov`
--------
Sets the current field of view of the freecam. This does NOT update the default
FOV for the freecam. Use [SetCameraSetting](#setcamerasetting) for that.

```
void exports.freecam:SetFov(float fov)
```

`GetPosition`
-------------
Returns the current position of the freecam.

```
vector3 position = exports.freecam:GetPosition()
```

`SetPosition`
-------------
Sets a new position for the freecam.

```
void exports.freecam:SetPosition(float posX, float posY, float posZ)
```

`GetRotation`
-------------
Returns the current rotation of the freecam.

```
vector3 rotation = exports.freecam:GetRotation()
```

`SetRotation`
-------------
Sets a new position for the freecam.

```
void exports.freecam:SetRotation(float rotX, float rotY, float rotZ)
```

`GetMatrix`
-----------
Returns the current view matrix of the freecam.

```
vector3 vecX, vector3 vecY, vector3 vecZ, vector3 pos = exports.freecam:GetMatrix()
```

`GetTarget`
-----------
Returns the position the freecam is looking at from the given distance.

```
vector3 target = exports.freecam:GetTarget(float distance)
```

`GetPitch`
----------
Returns the current pitch (rotX) of the freecam.

```
float pitch = exports.freecam:GetPitch()
```

`GetRoll`
---------
Returns the current roll (rotY) of the freecam.

```
float roll = exports.freecam:GetRoll()
```

`GetYaw`
--------
Returns the current yaw (rotZ) of the freecam.

```
float yaw = exports.freecam:GetYaw()
```

`GetCameraSetting`
------------------
Returns the value of a camera setting.
See [CONFIGURING](CONFIGURING.md#camera-settings) for details.

```
mixed value = exports.freecam:GetCameraSetting(string key)
```

`SetCameraSetting`
------------------
Sets the value of a camera setting.
See [CONFIGURING](CONFIGURING.md#camera-settings) for details.

```
void exports.freecam:SetCameraSetting(string key, mixed value)
```

`GetKeyboardControl`
------------------
Returns the value of a keyboard control.
See [CONFIGURING](CONFIGURING.md#control-mapping) for details.

```
mixed value = exports.freecam:GetKeyboardControl(string key)
```

`SetKeyboardControl`
------------------
Sets the value of a keyboard control.
See [CONFIGURING](CONFIGURING.md#control-mapping) for details.

```
void exports.freecam:SetKeyboardControl(string key, int value)
void exports.freecam:SetKeyboardControl(string key, table value)
```

`GetGamepadControl`
------------------
Returns the value of a gamepad control.
See [CONFIGURING](CONFIGURING.md#control-mapping) for details.

```
mixed value = exports.freecam:GetGamepadControl(string key)
```

`SetGamepadControl`
------------------
Sets the value of a gamepad control.
See [CONFIGURING](CONFIGURING.md#control-mapping) for details.

```
void exports.freecam:SetGamepadControl(string key, int value)
void exports.freecam:SetGamepadControl(string key, table value)
```

`GetKeyboardSetting`
------------------
Returns the value of a keyboard setting.
See [CONFIGURING](CONFIGURING.md#control-settings) for details.

```
mixed value = exports.freecam:GetKeyboardSetting(string key)
```

`SetKeyboardSetting`
------------------
Sets the value of a keyboard setting.
See [CONFIGURING](CONFIGURING.md#control-settings) for details.

```
void exports.freecam:SetKeyboardSetting(string key, mixed value)
```

`GetGamepadSetting`
------------------
Returns the value of a gamepad setting.
See [CONFIGURING](CONFIGURING.md#control-settings) for details.

```
mixed value = exports.freecam:GetGamepadSetting(string key)
```

`SetGamepadSetting`
------------------
Sets the value of a gamepad setting.
See [CONFIGURING](CONFIGURING.md#control-settings) for details.

```
void exports.freecam:SetGamepadSetting(string key, mixed value)
```