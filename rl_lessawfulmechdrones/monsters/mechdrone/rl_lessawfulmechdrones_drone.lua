local previous_init = init
function init()
  local conf = root.assetJson(
    "/monsters/mechdrone/rl_lessawfulmechdrones.config"
  )
  self.targetablePassiveMonsters = conf.targetablePassiveMonsters or {}
  self.targetablePassiveNpcTypes = conf.targetablePassiveNpcTypes or {}

  previous_init()
end

-- Replaces the drone's base game `findTarget` function, which targets
-- all monsters and NPCs not on the "friendly" damage team, including
-- passive monsters and neutral NPCs. This function limits targeting to
-- aggressive monsters and NPCs.
function findTarget()
  local pos = mcontroller.position()
  local candidates = world.entityQuery(pos, self.targetRange, self.targetQueryParameters)

  for _, candidate in ipairs(candidates) do
    if world.entityCanDamage(self.parentEntity, candidate) and (
      world.entityAggressive(candidate) or (
        world.isMonster(candidate) and
        self.targetablePassiveMonsters[world.entityTypeName(candidate)]
      ) or (
        world.isNpc(candidate) and
        self.targetablePassiveNpcTypes[world.npcType(candidate)]
      )
    ) then
      local canPos = world.entityPosition(candidate)
      if not world.lineTileCollision(pos, canPos) then
        local toTarget = world.distance(canPos, pos)
        local toTargetAngle = vec2.angle(toTarget)
        setRotation(toTargetAngle)

        return
      end
    end
  end

  -- no target found, don't shoot
  self.fireTimer = self.gunConfig.fireTime

  local idleAngle = vec2.angle(world.distance(world.entityPosition(self.parentEntity), mcontroller.position())) + math.pi
  setRotation(idleAngle)
end
