# Less Awful Mech Drones Modding Guide

This guide covers how to configure a mech drone to use the improved targeting provided by this mod, and how to add a passive monster type to the targeting allow-list.

Regardless of whether you do one or both tasks, you'll need to add this mod (`rl_lessawfulmechdrones`) to the `requires` list of your mod's `_metadata` file.

## Improving Mech Drone Targeting

Mech drones are implemented as special types of monsters. To use the improved targeting provided by this mod, first you must check that the drone is compatible with this targeting. Check the drone's `monstertype` file. The file must define the `/baseParameters/scripts` list to include the `/monsters/mechdrone/drone.lua` script. If this is not the script used by the drone, it probably isn't compatible with this improved targeting.

If the mech drone belongs to your mod, you can simply append the `/monsters/mechdrone/rl_lessawfulmechdrones_drone.lua` script to the `monstertype` file's `/baseParameters/scripts` list.

If the mech drone belongs to someone else's mod, or you want to provide compatibility separately, you'll need to make a compatibility mod and patch the `monstertype` file. Assuming the mech drone's monster file exists at `/monsters/mechdrone/foobardrone/foobardrone.monstertype`, then you'd add a patch file in your compatibility mod at `/monsters/mechdrone/foobardrone/foobardrone.monstertype.patch` and the contents will be something like:

```
[
  { "op" : "test",
    "path" : "/baseParameters/scripts/0",
    "value" : "/monsters/mechdrone/drone.lua"
  },
  { "op" : "add",
    "path" : "/baseParameters/scripts/-",
    "value" : "/monsters/mechdrone/rl_lessawfulmechdrones_drone.lua"
  }
]
```

## Adding Passive Monster Types to the Targeting Allow-List

By default, drones using the improved targeting provided by this mod will not target passive monsters. However, some passive monster types should be targeted by mech drones. An example in the base game is the [Rustick](https://starbounder.org/Rustick). Adding another passive monster type to the targeting allow-list is a simple matter of patching the `/monsters/mechdrone/rl_lessawfulmechdrones.config` file.

In your mod, add a file at `/monsters/mechdrone/rl_lessawfulmechdrones.config.patch`. Now, assuming the monster type you wish to add to the allow-list is called `foobar`, the patch would look like:

```
[
  {
    "op" : "add",
    "path" : "/targetablePassiveMonsters/foobar",
    "value" : true
  }
]
```

If you wish to add multiple monster types to the targeting allow-list, you must include a separate "add" object to your patch for each monster type. Keep in mind that in the vast majority of cases, you shouldn't want mech drones to target passive monsters, so only add monster types to the allow-list if you're certain that they ought to be targeted unconditionally.
