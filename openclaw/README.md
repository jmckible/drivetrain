# OpenClaw

AI gateway running in Docker. Secrets managed via 1Password CLI (`op`).

## Architecture

- **Upstream repo:** `~/dev/openclaw` — pull and rebuild image here
- **Config (this dir):** `~/dev/drivetrain/openclaw/` — docker-compose, env template, config
- **Runtime state:** `~/.openclaw/` — config (deployed via `deploy.sh`), devices, logs
- **Agent workspace:** Docker volume `openclaw-workspace` — isolated from host filesystem

## Files

| File | Purpose |
|---|---|
| `docker-compose.yml` | Gateway + CLI services |
| `.env.tpl` | 1Password `op://` references (safe to commit) |
| `openclaw.json` | Config template with `${VAR}` substitution |
| `deploy.sh` | Copies `openclaw.json` to `~/.openclaw/` |

## Quick Reference

All commands use the `oc` alias (defined in `.bashrc`):

```bash
oc up                               # Start gateway
oc down                             # Stop gateway
oc restart openclaw-gateway         # Restart
oc logs -f openclaw-gateway         # Follow logs
oc run --rm openclaw-cli dashboard --no-open  # Get dashboard URL + token
```

The `oc` script (`~/.local/bin/oc`) wraps `op run ... docker compose`.
`oc up` defaults to `-d openclaw-gateway`; all other commands pass through.

## Access

- **Local:** http://localhost:18789/
- **Tailscale:** http://100.121.74.67:18789/
- Paste the dashboard token into Control UI Settings on first connect.

## Startup Behavior

Docker is enabled on boot. The gateway container uses `restart: unless-stopped`,
so it survives reboots as long as it was running at shutdown. Secrets injected by
`op run` are retained in the container environment across restarts.

A `docker compose down` + `up` cycle requires `op run` (the `oc` alias handles this).

## Updating

```bash
cd ~/dev/openclaw
git pull
docker build -t openclaw:local .
oc up           # Recreates with new image
```

## Config Changes

Edit `openclaw.json` in this directory, then deploy:

```bash
./deploy.sh
oc restart openclaw-gateway
```

Note: the gateway rewrites `~/.openclaw/openclaw.json` at runtime (resolves `${VAR}`,
adds metadata). The copy in this directory is the source of truth.

## Secrets (1Password)

Vault: **OpenClaw**

| Item | Field | Used For |
|---|---|---|
| Gateway | credential | Gateway auth token |
| Claude | credential | Anthropic API key |
| Discord | credential | Discord bot token |

## Discord

Currently disabled in config (`channels.discord.enabled: false`). The bot token requires
**Message Content Intent** enabled in the Discord Developer Portal before re-enabling.

## Troubleshooting

Gateway won't start after reboot:
```bash
oc up
```

Control UI shows "disconnected":
- Check logs: `oc logs --tail=30 openclaw-gateway`
- The `allowInsecureAuth` setting is required because Docker routes Control UI
  traffic through the bridge network (172.x), not localhost.

Reset device pairing state:
```bash
echo '{}' > ~/.openclaw/devices/pending.json
echo '{}' > ~/.openclaw/devices/paired.json
oc restart openclaw-gateway
```
