# Plugin manifest — Nomonom

Every plugin that ran on the network, with the exact version in use when the box
was decommissioned (2026-05-20). **No plugin jars are in this repo** — see
[NOTICE.md](NOTICE.md). This file is the answer to "what did you use?"

Counts: **77** on SMP, **12** on hub, **8** on the Velocity proxy.

---

## Written in-house

These are ours. Source lives in separate repos.

| Plugin | Notes |
|---|---|
| `shroud` | Anti-xray / packet obfuscation. Source: [ThConMan/shroud](https://github.com/ThConMan/shroud) |
| `MobGrab` | Mob-grabbing mechanic. Gradle project, own git history. |
| `NomonomStore` | Store / donation integration, ties into Tebex. |
| `AscendedForge` | Custom forge/crafting system. |
| `mirage` | Anti-xray engine (predecessor to shroud). Own git history. |
| `landofsmiles` | Event/minigame plugin. |
| `wither-storm-plugin` | Boss encounter. |
| `nomonom-chat` | Node.js chat relay service (not a Bukkit plugin). |

## Paid / premium — explicitly licensed

Jars and bundled assets for these are **excluded from this repo**. Buy them from
the vendor; our configs assume the versions listed.

| Plugin | Version |
|---|---|
| MythicMobs Premium | 5.12.0-SNAPSHOT |
| MythicDungeons | 2.0.1-SNAPSHOT |
| MythicLib | 1.7.1 |
| MMOItems | 6.10.1 |
| CMI | 9.8.4.11 (hub: 9.7.15.5) |
| CMILib | 1.5.8.7 |
| PlotSquared Premium | 7.5.12 |
| Lib's Disguises Premium | 11.0.14 |
| AdvancedEnchantments | 9.22.7 |
| AdvancedEnderchest | — |
| AuctionHouse | 2.156.0 |
| EconomyShopGUI Premium | 6.0.2 |
| ChatGames Premium | 1.9.9 |
| AxKoth | 2.20.0 |
| AxInventoryRestore | 3.11.3 |
| Vulcan (anticheat) | 2.9.7.11 |
| PhoenixCrates | 4.2.10-SNAPSHOT-16 |
| PhoenixDuels | 3.0.8 |
| MCPets | 4.1.6 |
| ClickVillagers | 1.6.2 |
| eShulkerBox | 0.8.3 |
| DonutRTPzone | 2.0.2 |
| MobFarmManager | 3.0.4.5 |
| UltimateAutoRestart | 2025.12 |
| UltraBounty | 2.0.5 |
| PerformanceSuite | 1.1.3 |

## Third-party — free / open

| Plugin | Version |
|---|---|
| Advanced Portals | 2.5.0 |
| Chunky | 1.4.40 |
| Citizens | — |
| CustomNameplates | 3.0.37 |
| DeluxeMenus | 1.14.1 |
| DiscordSRV | 1.30.4 |
| FastAsyncWorldEdit | 2.15.1-SNAPSHOT-1291 |
| Guilds | 2.1.0 |
| ItemRenamerReloaded | — |
| ItsMyConfig | 4.3.0 |
| Jobs | 5.2.6.5 |
| LuckPerms | 5.5.24 |
| ModelEngine | R4.1.0 |
| Multiverse-Core | 5.5.0 |
| Nexo (+ NexoAddon) | 1.17 / 1.15.0 |
| NoteBlockAPI | 1.7.0 |
| item-nbt-api | 2.15.6 |
| PacketEvents | 2.12.0 |
| PlaceholderAPI | 2.12.2 |
| PlayerParticles | 8.11 |
| Prism | paper-v4.2 |
| ProtocolLib | — |
| PvPManager | 4.1.52 |
| RoseStacker | 1.5.39 |
| SkBee | 3.18.3 |
| Skript (+ skript-gui) | 2.14.3 / 1.3.2 |
| SkinsRestorer | — |
| spark | 1.10.159 |
| Tebex | 2.2.1 |
| TerraformGenerator | 25.0.1 |
| UltraCosmetics | 3.15-DEV-b1 |
| Vault | 1.7.4 |
| ViaVersion | 5.8.1 |
| Simple Voice Chat (+ discord bridge) | 2.6.11 / 3.1.2 |
| VotifierPlus / VotingPlugin | 1.4.3 / 7.0 |
| VoidWorldGenerator | 1.3.11 |
| WorldEdit Selection Visualizer | 2.1.9 |
| WorldGuard (+ ExtraFlags) | 7.0.16 |
| PixelLibs | — |
| ghastmaster | 1.3.7 |
| BungeeCommands (+ backend addon) | 1.4-Free |

## Proxy (Velocity)

Geyser-Velocity, floodgate-velocity, ViaVersion 5.9.1, ViaBackwards 5.9.1,
SkinsRestorer, spark 1.10.156, BungeeCommands 1.4-Free, CMIV 1.0.2.3.

Bedrock clients connected through Geyser/floodgate on 19132.

---

## Platform

- **SMP / hub** — Paper (Java 21+), launched via `start.sh` under `tmux`
- **personalworld** — Paper 1.16.5 running Drehmal v2.1.1, Java 11
- **proxy** — Velocity, with `forwarding.secret` (excluded here — generate your own)
- **web** — Caddy serving the site; a Node donator-stats service alongside

Operational note carried over from the original runbook: never `restart` from
inside the SMP tmux console — use `stop`.
