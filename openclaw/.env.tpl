OPENCLAW_CONFIG_DIR=/home/jmckible/.openclaw
OPENCLAW_GATEWAY_PORT=18789
OPENCLAW_BRIDGE_PORT=18790
OPENCLAW_GATEWAY_BIND=lan
OPENCLAW_IMAGE=openclaw:local

# Secrets resolved from 1Password at runtime
OPENCLAW_GATEWAY_TOKEN=op://OpenClaw/Gateway/credential
ANTHROPIC_API_KEY=op://OpenClaw/Claude/credential
DISCORD_BOT_TOKEN=op://OpenClaw/Discord/credential
GITHUB_TOKEN=op://OpenClaw/GitHub/credential
