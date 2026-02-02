# Personal Development Preferences

## Planning Documents

For small advanced development teams, omit performative bureaucracy:

**Omit:**
- Time estimates (weeks/days are meaningless measures)
- File lists to create or modify
- Testing checklists or example test scripts
- Test strategies
- Scalability and performance considerations
- Rollout and rollback plans
- Success metrics or business case analysis
- Monitoring, observability, and error reporting sections
- Phase breakdowns (unless things must be built on top of each other)
- Migration examples (unless technically complex)

**Include:**
- Core architecture and technical decisions
- Implementation code patterns with examples
- Critical gotchas with specific technical solutions
- Build order (only if dependencies exist between components)
- Migration approach (low/medium/high risk ordering with principles)

**Principles:**
- Never implement things that will be thrown out later
- Assume advanced developers who understand basics
- Focus on what's technically interesting or tricky
- Document the "why" and the gotchas, not the "how to write a test"

## Code Style

Best Practices:
- When using importmaps, vendor libraries instead of serving from a CDN

## Common Patterns

[Add patterns you frequently use across projects]
