# Project Setup Guide

## Prerequisites

### System Requirements
- **OS:** Windows 10+, macOS 10.14+, or Linux (Ubuntu 18.04+)
- **RAM:** 4GB minimum
- **Disk Space:** 2GB for Godot + project files

### Required Software

1. **Godot 4.1+**
   - Download: https://godotengine.org/download
   - Recommended: 4.3 or latest stable
   - Version check: File → Project Settings → check Godot version in output console

2. **Git**
   - Download: https://git-scm.com/
   - Verify: `git --version` in terminal

3. **Text Editor** (recommended)
   - VS Code: https://code.visualstudio.com/
   - With GDScript extension: search "GDScript" in Extensions

## Step-by-Step Setup

### 1. Clone the Repository

```bash
# Navigate to your projects directory
cd ~/Projects  # or similar

# Clone the repository
git clone https://github.com/YOUR_USERNAME/samosbor-game.git
cd samosbor-game

# Check structure
ls -la
# You should see: CLAUDE.md, README.md, GAME_DESIGN_DOCUMENT.md, godot/, archive/
```

### 2. Open in Godot

**Method A: GUI**
1. Open Godot 4.x
2. Click "Open Project"
3. Navigate to `samosbor-game/godot/`
4. Click "Select Folder" (or double-click `project.godot`)
5. Click "Open & Edit"

**Method B: Command Line**
```bash
cd samosbor-game/godot
godot --editor
# Or if godot is not in PATH:
/path/to/godot/Godot_v4.3_stable --editor
```

### 3. Verify Installation

1. In Godot editor, navigate to: **Scene → Open Scene → scenes/main/game_scene.tscn**
2. Click the play button (▶️ F5) to run
3. You should see console output:
   ```
   Game Manager initialized
   Floor: 1 | Phase: accumulation | Biomass: 50 | Terror: 30
   ```

### 4. Configure Git (One-time)

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Verify
git config --global user.name
```

### 5. Set Up IDE (Optional but Recommended)

**VS Code + GDScript:**

1. Install VS Code
2. Open VS Code
3. Go to Extensions (Ctrl+Shift+X / Cmd+Shift+X)
4. Search: "GDScript for Visual Studio Code"
5. Click Install (by Geequlim)
6. Open folder: `samosbor-game`
7. VS Code will auto-detect Godot and configure

## Project Structure

```
samosbor-game/
├── godot/                           # Godot 4 project (open this in Godot)
│   ├── project.godot                # Project config
│   ├── scenes/
│   │   └── main/
│   │       └── game_scene.tscn      # Main game scene
│   ├── scripts/
│   │   └── game_manager.gd          # Global game state
│   └── assets/
│       ├── sprites/                 # PNG files (not yet)
│       ├── audio/                   # WAV/MP3 files (not yet)
│       └── data/                    # JSON/GD data files (not yet)
│
├── CLAUDE.md                        # AI collaboration guide
├── GAME_DESIGN_DOCUMENT.md          # Full GDD
├── DEVELOPMENT_PLAN_V2.md           # Sprint roadmap
├── SETUP.md                         # This file
├── README.md                        # Project overview
│
└── archive/                         # Research & devlog
    └── legend/
        └── DEVLOG.md
```

## Common Tasks

### Running the Game

```bash
cd samosbor-game/godot
godot
# Then click Play (F5) or Scene → Play Scene
```

### Creating a New Branch (for features)

```bash
git checkout -b feature/my-feature
# Make changes...
git add .
git commit -m "Add: my feature description"
git push origin feature/my-feature
# Create Pull Request on GitHub
```

### Updating from Remote

```bash
git pull origin main
```

### Viewing Game Output

In Godot Editor:
1. Click "Output" tab (bottom panel)
2. Run game (F5)
3. Check console for `print()` statements from scripts

## Troubleshooting

### Godot won't open project.godot

**Issue:** Error like "Failed to load resource"

**Solution:**
1. Ensure you're opening the `godot/` folder, NOT the root `samosbor-game/` folder
2. If using command line: `cd godot` BEFORE opening Godot

### Git won't recognize repository

**Issue:** `git status` shows "not a git repository"

**Solution:**
```bash
cd samosbor-game  # Must be in root of cloned folder
git status        # Should show branch info
```

### "Failed to create scene" error

**Issue:** game_scene.tscn can't load

**Solution:**
1. Check File → Project Settings → Auto Reload Scripts = enabled
2. Re-save scene: Ctrl+S in scene editor
3. Restart Godot

### GDScript errors about missing classes

**Issue:** Script shows red squiggles

**Solution:**
1. File → Project Settings → Debug → GD Script
2. Restart Godot
3. Wait for editor to reindex (watch status bar)

## Development Workflow

### Daily Workflow

1. **Start:** Pull latest changes
   ```bash
   git pull origin main
   ```

2. **Develop:** Create feature branch
   ```bash
   git checkout -b feature/my-task
   ```

3. **Test:** Run game in Godot (F5) and verify changes

4. **Commit:** Save changes
   ```bash
   git add .
   git commit -m "Add: description"
   ```

5. **Push & PR:** Upload changes
   ```bash
   git push origin feature/my-task
   # Create PR on GitHub for review
   ```

### Before Pushing

1. ✅ Code runs without errors (check console)
2. ✅ Syntax is valid (no red squiggles in editor)
3. ✅ Commit message is clear and describes changes

## Additional Resources

- **[Godot Docs](https://docs.godotengine.org/)** — Official documentation
- **[GDScript Cheatsheet](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/basics.html)**
- **[Godot Community](https://godotengine.org/community)** — Forums, Discord, etc.

## Getting Help

- **GitHub Issues:** Create an issue if you find bugs
- **CLAUDE.md:** Review architecture notes before major refactors
- **GAME_DESIGN_DOCUMENT.md:** Reference for mechanical questions

---

**Last Updated:** July 2, 2026

Happy coding! 🎮
