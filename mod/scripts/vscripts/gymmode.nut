global function GymMode_Init
global function GymMode_Changes

struct {
    bool enabled
    int midHealth
    int maxHealth
    int minHealth
    int healthChange
    bool showMaxHealth

    table<entity, int> playerMaxHealths
} file

void function GymMode_Init()
{
    file.enabled = GetConVarBool("gymmode_enabled")
    if (!file.enabled) {
        Log("GymMode is disabled")
        return
    }

    file.midHealth = GetConVarInt("gymmode_mid_health")
    file.maxHealth = GetConVarInt("gymmode_max_health")
    file.minHealth = GetConVarInt("gymmode_min_health")
    file.healthChange = GetConVarInt("gymmode_health_change")
    file.showMaxHealth = GetConVarBool("gymmode_show_max_health")

    AddCallback_OnClientConnected(OnClientConnected)
    AddCallback_OnPlayerRespawned(OnPlayerRespawned)
    AddCallback_OnPlayerKilled(OnPlayerKilled)
    AddCallback_OnClientDisconnected(OnClientDisconnected)

    Log("GymMode is enabled")
}

array<string> function GymMode_Changes()
{
    string change1 = format("1. you gain %d maximum HP per death", file.healthChange)
    string change2 = format("2. you lose %d maximum HP per kill", file.healthChange)
    string change3 = format("3. minimum HP is %d, and maximum HP is %d", file.minHealth, file.maxHealth)
    string change4 = format("4. kraber and charge rifle do 120 damage")

    return [change1, change2, change3, change4]
}

void function OnClientConnected(entity player)
{
    file.playerMaxHealths[player] <- file.midHealth
}

void function OnPlayerRespawned(entity player)
{
    int maxHealth = file.playerMaxHealths[player]
    player.SetMaxHealth(maxHealth)
    ShowMaxHealth(player)
}

void function OnPlayerKilled(entity victim, entity attacker, var damageInfo)
{
    // ignore suicides
    if (victim == attacker || !victim.IsPlayer() || !attacker.IsPlayer() || GetGameState() != eGameState.Playing) {
        return
    }

    AddMaxHealth(victim)
    ReduceMaxHealth(attacker)

    ShowMaxHealth(victim)
    ShowMaxHealth(attacker)
}

void function OnClientDisconnected(entity player)
{
    if (player in file.playerMaxHealths) {
        delete file.playerMaxHealths[player]
    }
}

// victims get new max health after respawn
void function AddMaxHealth(entity victim)
{
    int currentMaxHealth = file.playerMaxHealths[victim]
    int newMaxHealth = minint(currentMaxHealth + file.healthChange, file.maxHealth)
    file.playerMaxHealths[victim] <- newMaxHealth
}

// attackers get new max health right away
void function ReduceMaxHealth(entity attacker)
{
    int currentMaxHealth = file.playerMaxHealths[attacker]
    int newMaxHealth = maxint(currentMaxHealth - file.healthChange, file.minHealth)
    file.playerMaxHealths[attacker] <- newMaxHealth
    attacker.SetMaxHealth(newMaxHealth)
}

void function ShowMaxHealth(entity player)
{
    if (!file.showMaxHealth) {
        return
    }

    int maxHealth = file.playerMaxHealths[player]
    string message = format("Max. HP: %d", maxHealth)
    SendHudMessage(player, message, -0.925, 0.4, 220, 224, 255, 255, 0.15, 9999, 1)
}

void function Log(string s)
{
    print("[GymMode] " + s)
}
