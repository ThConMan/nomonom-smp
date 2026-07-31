# Notice — what's in this repo and what isn't

## Status: cleared for public viewing

This repository is a **configuration archive**. It is deliberately not a
redistribution of anything: no plugin jars, no server binaries, no worlds, no
credentials, and no third-party model, texture or sound packs.

You can read what Nomonom ran and how it was tuned. You cannot obtain the
software from here — that was the point.

The complete backup, including worlds and vendor assets, is retained offline by
the owner. Nothing was deleted from it to build this.

## Third-party content

Config files for **paid plugins have been removed entirely** — 962 files across
29 plugins. Their config formats and default scaffolding are the vendors'
product, and separating our tuning from their defaults is not cleanly possible
without the original jars. Rather than guess, they are out.

Each of those folders keeps a `NOT-SHARED.md` naming the plugin, explaining that
it is paid, and describing **what it actually did on Nomonom** — so the stack is
still legible even where the configs are gone.

What remains under `smp/plugins/`, `hub/plugins/` and `proxy/plugins/` is config
for free and open-source plugins, plus our own tuning of them. Nothing here
grants you rights to any third-party plugin.

## Deliberately excluded

Not in this repo, and not by accident:

- **Plugin and server jars** — 97 plugin jars plus Paper/Velocity binaries.
  Many are paid. Redistribution would be piracy.
- **World data** — ~62 GB across `mortal_realm`, its nether and end, `void`,
  `dreamrealm`, `dungeons`, `mapworldf`, `ascended_realm`, and the hub /
  personalworld worlds. Too large for git and not useful as a template.
- **Databases** — Prism action logs (1.8 GB), AxInventoryRestore snapshots,
  LuckPerms and QuickShop stores. Bulk plus player data.
- **Player data** — everything that identifies the people who played here.
  `ops.json`, `whitelist.json`, ban lists, `usercache.json`, DiscordSRV
  `accounts.aof`, and all plugin *runtime state*: CMI/CMILib `Saves/`,
  Jobs `blockOwnerShips.yml` (UUIDs mapped to build coordinates), Citizens
  `saves.yml`, MythicMobs and MythicDungeons per-player data, SkinsRestorer
  player records, Vulcan punishment logs, and a VeloFlame autowhitelist that
  mapped usernames to home IP addresses. Region member lists and skin-GUI
  UUIDs were redacted in place so the surrounding config still reads.

  The rule applied: **configuration stays, runtime state goes.** Anything a
  plugin generated about a person is out.
- **Secrets** — Discord bot token, Discord webhooks, `forwarding.secret`, SSH
  private keys, MySQL credentials. Scrubbed and replaced with placeholders.
- **Bloat** — a 2.6 GB JVM heap dump, 151 MB of spark profiles, `libraries/`
  Maven caches, `.paper-remapped/`, logs, crash reports, `versions/`.
- **Vendor asset packs (5,619 files)** — ModelEngine blueprints and its resource
  pack, the Nexo pack including bundled ItemsAdder / SkeletonMobs / archmage
  assets, MythicMobs `gamitamodels` packs, CustomNameplates' resource pack, and
  AdvancedPets skin packs. Purchased 3D models, textures and sounds by other
  creators. The configs that *reference* them are kept, so you can see how they
  were wired up — you just have to buy the assets yourself.

- **Schematics (81 files)** — every `.schem` / `.schematic` build across
  FastAsyncWorldEdit, WorldEdit, PlotSquared and PhoenixDuels. Builds are not
  configuration, some were made by other builders, and they are not ours to
  hand out. Excluded entirely.

## Credentials — ROTATE THESE

Eight live credentials were found in the source backup. All are replaced with
`REPLACE_ME_*` placeholders here, but they sat in a cloud-synced folder long
before this repo existed. **Treat every one as compromised and rotate it at the
source** — scrubbing this copy does not un-leak them.

| Credential | Was in |
|---|---|
| Discord bot token | `smp/plugins/DiscordSRV/config.yml` |
| Discord bot token ×4 | `smp/plugins/voicechat-discord/config.yml` |
| Discord webhook URL | `smp/plugins/AuctionHouse/config.yml` |
| Velocity forwarding secret | `smp/config/paper-global.yml` |
| Votifier token | `smp/plugins/VotifierPlus/config.yml` |

The Velocity forwarding secret matters most operationally — it's what authorises
backend servers to the proxy. Generate a fresh one and set it in both
`proxy/` and every backend's `config/paper-global.yml`.

Also in the wider backup but **never copied into this repo**: SSH private keys
under `other/migrate/Nomonom Keys` and `other/home-dotfiles/.ssh`.

A further 146 secret-shaped values (mostly unused MySQL defaults like `admin` /
`password123`) were replaced with placeholders. Every credential-shaped value in
this repo is a placeholder. Fill in your own.

### Verification

The scrub was checked byte-for-byte against the source: across 7,902 config
files, the only lines that differ are the redacted ones. All 2,638 YAML files
were parsed before and after — the scrub introduced zero parse regressions.
(189 files fail strict YAML parsing in the original too; Bukkit's parser is
laxer than the spec about control characters. Those are untouched and unchanged.)
