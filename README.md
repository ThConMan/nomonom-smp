# Nomonom — server configuration archive

The full configuration of the **Nomonom** Minecraft network, preserved from the
server it ran on before that box was reclaimed (2026-05-20).

A Paper SMP behind a Velocity proxy, with a hub, Bedrock crossplay via Geyser,
97 plugins, and a stack of in-house plugins. This repo is the *configuration* —
the part that took years to tune. It is not a redistribution of the software.

**Looking for what we actually ran? → [PLUGINS.md](PLUGINS.md)** — every plugin,
every version, grouped by in-house / paid / free.

> **All rights reserved — readable, not reusable.** No license is granted. You
> may read this to see how the server was built; you are not granted rights to
> reuse it. Third-party plugin configs remain under their vendors' terms. See
> [NOTICE.md](NOTICE.md).

## Layout

```
smp/      Paper SMP — server.properties, bukkit/spigot/paper configs,
          start + backup scripts, and plugin configs under plugins/
hub/      Lobby server configs
proxy/    Velocity — velocity.toml, server routing, Geyser/floodgate
```

## What is not here

World data (~62 GB), plugin jars, server binaries, databases, player data, logs,
credentials, and third-party model/texture/sound packs. [NOTICE.md](NOTICE.md)
has the full accounting and the reasoning for each.

The short version: this repo is ~0.1% of the 68.77 GB backup, and it's the part
that carries the actual decisions. There is deliberately nothing here you could
run a server from without buying the plugins yourself.

## Standing one up from this

You cannot boot this directly — no jars, no worlds. As a starting point:

1. **Get Paper and Velocity.** Paper on Java 21+ for `smp` and `hub`; Velocity
   for `proxy`. `PLUGINS.md` lists the versions these configs expect.
2. **Acquire the plugins.** Free ones from their project pages, paid ones from
   their vendors. Configs for a plugin you don't have will be ignored, so it's
   fine to start with a subset.
3. **Fill in every placeholder.** Search the tree for `REPLACE_ME` — Discord bot
   token, webhooks, database credentials. Nothing here is a working credential.
4. **Generate a new proxy secret.** `proxy/forwarding.secret` is excluded. Create
   your own and set the matching value in each backend's Paper config, or players
   will be unable to connect.
5. **Fix host-specific values.** `server-ip` / bound addresses in
   `proxy/velocity.toml` and each `server.properties` still point at the old
   host's networking.
6. **Open the ports.** 25565, the proxy port, and 19132/udp for Bedrock.
7. **Create the worlds.** World names in the configs (`mortal_realm`,
   `dreamrealm`, `void`, …) won't exist. Either generate fresh worlds under those
   names or rename to match what you have.

Launch each server in its own `tmux` session. **Never `restart` from inside the
SMP console — use `stop`.** That was true on the original box and it's still the
one rule worth carrying forward.

## Provenance

Pulled from the `_BACKUP` tree of the decommissioned server. The original backup —
worlds, jars, databases and all — is retained separately offline; nothing in this
repo replaces it, and nothing was deleted from it to build this.
