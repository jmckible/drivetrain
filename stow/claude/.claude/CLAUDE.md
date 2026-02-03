# Global Preferences

Assume an advanced developer. Skip explanations of basics.

## Planning & Documentation

Omit performative bureaucracy: time estimates, file lists, test checklists, test strategies, scalability sections, rollout/rollback plans, success metrics, monitoring sections, phase breakdowns (unless dependencies require sequencing), migration examples (unless technically complex).

Focus on: core architecture decisions, implementation patterns with code examples, critical gotchas with solutions, build order (only when dependencies exist).

Principle: never implement throwaway scaffolding. Document the "why" not the "how."

## Code Preferences

- Vendor libraries locally when using importmaps (no CDN)
