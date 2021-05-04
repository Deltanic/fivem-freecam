Events
======

`freecam:onEnter`
-----------------

Called upon entering the freecam after `Freecam:SetActive(true)`. Useful to
detect state changes of the freecam.

```lua
AddEventHandler('freecam:onEnter', function ()
  -- Plays an effect upon entering the freecam.
  StartScreenEffect('SuccessNeutral', 500, false)
  PlaySoundFrontend(-1, 'Hit_In', 'PLAYER_SWITCH_CUSTOM_SOUNDSET', 1)
end)
```

`freecam:onExit`
----------------

Called upon exiting the freecam after `Freecam:SetActive(false)`. Useful to
detect state changes of the freecam.

```lua
AddEventHandler('freecam:onExit', function ()
  -- Plays an effect upon exiting the freecam.
  StartScreenEffect('SuccessNeutral', 500, false)
  PlaySoundFrontend(-1, 'Hit_Out', 'PLAYER_SWITCH_CUSTOM_SOUNDSET', 1)
end)
```

`freecam:onTick`
----------------

Called every tick for as long as the freecam is active. Calls after any
positional or rotational updates so anything attached to the freecam stays
in sync. Not called when the freecam is inactive.

No values are passed to this event.

```lua
local Freecam = exports['fivem-freecam']
AddEventHandler('freecam:onTick', function ()
  -- Gets the current target position of the freecam.
  -- You could attach the player to this, or an object.
  local target = Freecam:GetTarget(50)
  print(target)
end)
```
