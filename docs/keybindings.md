# Keybinding Comparison: Hyprland vs macOS (skhd/yabai)

## Key Modifier Mapping

| System | Primary Modifier | Notes |
|--------|-----------------|-------|
| **Hyprland** | `SUPER` (Windows/Meta key) | Linux standard |
| **macOS Final** | `Option` (⌥ / Alt) | Avoids all macOS conflicts |

## Final Keybindings Summary

After testing for conflicts, we chose **Option (Alt)** as the primary modifier to preserve all macOS system shortcuts.

### Window Focus/Navigation

| Action | Hyprland | macOS (Final) | Notes |
|--------|----------|---------------|-------|
| Focus left | `SUPER + ←` | `Alt + h` or `Alt + ←` | ✅ No conflicts |
| Focus down | `SUPER + ↓` | `Alt + j` or `Alt + ↓` | ✅ No conflicts |
| Focus up | `SUPER + ↑` | `Alt + k` or `Alt + ↑` | ✅ No conflicts |
| Focus right | `SUPER + →` | `Alt + l` or `Alt + →` | ✅ No conflicts |

**Why not Cmd?**
- `Cmd + h` = Hide Window (system)
- `Cmd + arrows` = Text navigation (universal)

### Window Movement/Swapping

| Action | Hyprland | macOS (Final) | Notes |
|--------|----------|---------------|-------|
| Swap left | `SUPER + Shift + ←` | `Shift + Alt + h` or `Shift + Alt + ←` | ✅ No conflicts |
| Swap down | `SUPER + Shift + ↓` | `Shift + Alt + j` or `Shift + Alt + ↓` | ✅ No conflicts |
| Swap up | `SUPER + Shift + ↑` | `Shift + Alt + k` or `Shift + Alt + ↑` | ✅ No conflicts |
| Swap right | `SUPER + Shift + →` | `Shift + Alt + l` or `Shift + Alt + →` | ✅ No conflicts |

### Window Resizing

| Action | Hyprland | macOS (Final) | Notes |
|--------|----------|---------------|-------|
| Resize left | `SUPER + -` | `Ctrl + Alt + h` or `Ctrl + Alt + ←` | ✅ No conflicts |
| Resize right | `SUPER + =` | `Ctrl + Alt + l` or `Ctrl + Alt + →` | ✅ No conflicts |
| Resize up | `SUPER + Shift + -` | `Ctrl + Alt + k` or `Ctrl + Alt + ↑` | ✅ No conflicts |
| Resize down | `SUPER + Shift + =` | `Ctrl + Alt + j` or `Ctrl + Alt + ↓` | ✅ No conflicts |

**Notes:**
- Hyprland uses +/- keys, macOS uses directional (hjkl)
- Both hjkl and arrow keys supported for flexibility

### Workspace/Space Switching

| Action | Hyprland | macOS (Final) | Notes |
|--------|----------|---------------|-------|
| Switch to workspace 1-9 | `SUPER + 1-9` | `Alt + 1-9` | ✅ No conflicts |
| Next workspace | `SUPER + Tab` | `Alt + Tab` | Cmd+Tab is app switcher |
| Previous workspace | `SUPER + Shift + Tab` | `Shift + Alt + Tab` | ✅ No conflicts |

**Why not Cmd?**
- `Cmd + 1-9` = Browser tabs, app shortcuts (critical)
- `Cmd + Tab` = App switcher (system, cannot override)

### Move Window to Workspace/Space

| Action | Hyprland | macOS (Final) | Notes |
|--------|----------|---------------|-------|
| Move to workspace 1-9 | `SUPER + Shift + 1-9` | `Shift + Alt + 1-9` | ✅ No conflicts |
| Move and follow 1-9 | N/A | `Ctrl + Shift + Alt + 1-9` | Bonus feature |

**Why not Cmd?**
- `Shift + Cmd + 1-9` could conflict with some apps

### Window Actions

| Action | Hyprland | macOS (Final) | Notes |
|--------|----------|---------------|-------|
| Close window | `SUPER + w` | `Cmd + w` (native) | System default works |
| Toggle floating | `SUPER + t` | `Shift + Alt + Space` | Avoids Cmd+t (New Tab) |
| Fullscreen | `SUPER + f` | `Alt + f` | Avoids Cmd+f (Find) |
| Toggle split | `SUPER + j` | `Alt + s` | Avoids Cmd+s (Save) |
| Rotate tree | N/A | `Alt + r` | yabai-specific |
| Balance windows | N/A | `Alt + e` | yabai-specific |

**Critical Conflicts Avoided:**
- ❌ `Cmd + f` = Find (universal)
- ❌ `Cmd + t` = New Tab (browsers, terminals)
- ❌ `Cmd + s` = Save (universal, muscle memory)

### Terminal Launch

| Action | Hyprland | macOS (Final) | Notes |
|--------|----------|---------------|-------|
| Launch terminal | `SUPER + Return` | `Cmd + Return` | ✅ Safe, few conflicts |

## Complete Keybinding Reference

```bash
# Window Management
alt + h/j/k/l              # Focus window (vim-style)
alt + arrows               # Focus window (arrow keys)
shift + alt + h/j/k/l      # Swap windows (vim-style)
shift + alt + arrows       # Swap windows (arrow keys)
ctrl + alt + h/j/k/l       # Resize windows (vim-style)
ctrl + alt + arrows        # Resize windows (arrow keys)

# Workspace Management
alt + 1-9                  # Switch to space 1-9
alt + tab                  # Next space
shift + alt + tab          # Previous space
shift + alt + 1-9          # Move window to space 1-9
ctrl + shift + alt + 1-9   # Move window to space and follow

# Window Actions
shift + alt + space        # Toggle float
alt + f                    # Toggle fullscreen
alt + r                    # Rotate tree 90°
alt + e                    # Balance windows
alt + s                    # Toggle split direction
cmd + w                    # Close window (native macOS)
cmd + return               # Launch Ghostty terminal
```

## macOS Conflicts Avoided

By using Alt (Option) as the primary modifier, all these critical shortcuts continue to work:

| Shortcut | Function | Status |
|----------|----------|--------|
| `Cmd + h` | Hide Window | ✅ Protected |
| `Cmd + f` | Find | ✅ Protected |
| `Cmd + s` | Save | ✅ Protected |
| `Cmd + t` | New Tab | ✅ Protected |
| `Cmd + w` | Close Window | ✅ Protected (and used!) |
| `Cmd + 1-9` | App shortcuts (tabs, etc.) | ✅ Protected |
| `Cmd + arrows` | Text navigation | ✅ Protected |
| `Cmd + Tab` | App switcher | ✅ Protected (system) |
| `Cmd + c/v/x` | Copy/Paste/Cut | ✅ Protected |
| `Cmd + q` | Quit app | ✅ Protected |
| `Cmd + n` | New window | ✅ Protected |

## Hyprland-Specific Features Not in yabai

These Hyprland/Omarchy features don't have direct yabai equivalents:

1. **Scratchpad** - `SUPER + s`
   - Hyprland has a hidden workspace for quick access
   - yabai workaround: Use a dedicated space

2. **Window Grouping** - `SUPER + g`
   - Hyprland has tabbed/stacked window groups
   - yabai doesn't support grouping

3. **Pseudo tiling** - `SUPER + p`
   - Hyprland's dwindle-specific feature
   - yabai uses BSP layout instead

4. **Move workspaces between monitors** - `SUPER + Shift + Alt + arrows`
   - Hyprland can move entire workspaces
   - yabai: limited support

## Vim-style vs Arrow Keys

The configuration supports **both** navigation styles:

| Style | When to Use |
|-------|-------------|
| **hjkl** | If you're a Vim user, keep hands on home row |
| **Arrows** | If you prefer traditional arrow navigation |

Both work identically - use whichever feels natural!

## Quick Reference Card

Print this for easy reference:

```
╔════════════════════════════════════════════════════════╗
║          macOS Tiling Window Manager Keys             ║
║              (Hyprland-inspired)                       ║
╠════════════════════════════════════════════════════════╣
║  FOCUS WINDOW:        Alt + h/j/k/l  or  Alt + arrows ║
║  SWAP WINDOW:    Shift+Alt + h/j/k/l  or  + arrows    ║
║  RESIZE WINDOW:  Ctrl+Alt + h/j/k/l   or  + arrows    ║
╠════════════════════════════════════════════════════════╣
║  SWITCH SPACE:        Alt + 1-9                        ║
║  MOVE TO SPACE:  Shift+Alt + 1-9                       ║
║  NEXT/PREV SPACE:     Alt + Tab / Shift+Alt+Tab        ║
╠════════════════════════════════════════════════════════╣
║  TOGGLE FLOAT:   Shift+Alt + Space                     ║
║  FULLSCREEN:          Alt + f                          ║
║  BALANCE:             Alt + e                          ║
║  ROTATE:              Alt + r                          ║
║  TOGGLE SPLIT:        Alt + s                          ║
╠════════════════════════════════════════════════════════╣
║  TERMINAL:            Cmd + Return                     ║
║  CLOSE WINDOW:        Cmd + w                          ║
╚════════════════════════════════════════════════════════╝
```

## Philosophy

The final configuration prioritizes:

1. **No breaking changes** - All macOS shortcuts work as expected
2. **Consistency** - Alt is the primary modifier throughout
3. **Muscle memory** - Preserves Cmd+s (Save), Cmd+f (Find), etc.
4. **Flexibility** - Both hjkl and arrow keys supported
5. **Hyprland similarity** - Where possible without conflicts

This gives you a powerful tiling window manager that feels like Hyprland, while respecting macOS conventions.
