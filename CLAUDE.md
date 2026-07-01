# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project: Samosbor Game (Godot 4)

A side-view game where the player controls a supernatural entity ("Samosbor") infiltrating and conquering an infinite Soviet apartment building (Gigakhrushchyovka) through psychological influence, biomass growth, and eventually takeover.

**Team:** 2 people | **Timeline:** Flexible (spare time) | **Target:** PC, potentially mobile

---

## Core Game Mechanics

### Three Development Trees
1. **Mentality (Ментальность):** Influence, stealth, manipulation of human psyche
2. **Biomass (Биомасса):** Creating agents, physical manifestation, mutations
3. **Development (Развитие):** Core protection, integration of conquered floors, evolution

### Two Game Modes
- **Story Mode:** Conquest of 100 floors with narrative progression
- **Infinite Mode:** Procedurally generated floors, no end goal

### Five Game Phases (per floor)
1. **Infiltration:** Stealth entry into a new floor
2. **Silent Influence:** Psychological manipulation, agent creation
3. **Detection:** Liquidators discover the anomaly
4. **Takeover:** Active conquest with visible manifestations
5. **Stabilization:** Integration of conquered floor

---

## Lore Foundation

The game is based on the **Samosbor Universe** — a collaborative fictional worldbuilding project from Russian imageboards (2ch, 4ch) starting May 2018.

**Core Elements:**
- **Samosbor:** A destructive anomaly (purple fog, raw meat smell) that kills or mutates people
- **Gigakhrushchyovka:** An infinite Soviet-style apartment building with unknown boundaries
- **Liquidators (Ликвидаторы):** Military force that cleans up after Samosbor events using rakes

**Atmosphere:** Soviet cyberpunk + creepy post-apocalypse + dark absurdist humor. No grand narrative—flexibility and community-driven interpretation is canonical.

**Resources:**
- Community wikis: [Samosbor Viki](https://samosbors8878.fandom.com/ru/wiki/), [Wikireality](https://wikireality.ru/wiki/%D0%A1%D0%B0%D0%BC%D0%BE%D1%81%D0%B1%D0%BE%D1%80)
- Existing games: Samosbor (Steam), Reigns of Samosbor: П747, КЛЕТЬ

---

## Technical Stack

**Engine:** Godot 4.x (open-source, well-suited for 2D procedural generation and side-view mechanics)

**Language:** GDScript

**Key Systems:**
- FastNoiseLite (Godot built-in) for procedural floor generation
- Node2D for side-view rendering
- CustomUI layers for HUD/skill tree overlay
- AI state machines for NPC and Liquidator behavior

---

## Architecture Notes

### Project Structure
```
scenes/
  ├── main/ (game loop, floor setup, camera)
  ├── npc/ (civilian, liquidator, official behavior)
  ├── player/ (Samosbor entity, influence fields, abilities)
  └── effects/ (purple fog, tentacles, mutations)

scripts/
  ├── game_manager.gd (global state, floor progression)
  ├── influence_system.gd (psychological spread, agent spawning)
  ├── skill_system.gd (three development trees)
  ├── procedural_generation/ (floor layout, NPC spawning)
  ├── ai/ (NPC pathfinding, Liquidator patrols, detection)
  └── data/ (skill data, floor presets, NPC templates)
```

### Key Design Principles
- **Modular floors:** Each floor is self-contained; procedural generation builds from reusable modules (residential, barracks, labs, storage)
- **Real-time simulation:** NPC schedules, Liquidator patrols, influence spread all happen continuously
- **Gating mechanics:** Player starts with detection risk; skill tree unlocks passive ability to hide, reduce detection, expand influence reach
- **Two-person workflow:** Clear separation between programming (core systems) and art (sprites, UI, effects, sound)

---

## Code Style

**GDScript conventions (Godot 4):**
- snake_case for variables/functions, PascalCase for classes
- Explicit types (avoid `:=` on mixed-type operations)
- Use `@export` (not `export`), `@onready` (not `onready`), `await` (not `yield`)
- Signals for decoupling: children emit up, parents connect down
- Keep scripts under 300 lines; split large features into separate nodes
- Disconnect signals in `_exit_tree()` for autoload connections

**No comments unless the WHY is non-obvious.** Code should be self-documenting (clear function names, signal names). Gotchas only: hidden constraints, workarounds for Godot bugs, non-standard patterns.

---

## Development Workflow

### Git/Version Control
- Feature branches for each major system (e.g., `feature/influence-system`, `feature/floor-generation`)
- Commit messages: "Add X, fix Y, refactor Z" — focus on what changed, not why (that goes in PR description)
- Merge to main only after playtesting key features

### Testing & Iteration
- Playtest frequently: Does the influence mechanic feel rewarding? Are Liquidators a credible threat?
- Adjust NPC detection ranges, Liquidator patrol speed, skill costs based on playtesting
- Use Godot's built-in debug tools: print() for quick checks, breakpoints for complex AI

### Asset Pipeline
- Sprites: Aseprite/Krita → PNG, commit to `assets/sprites/`
- Animations: AnimationPlayer in Godot, save as .anim
- Sound: Audacity → WAV/MP3, store in `assets/audio/`
- Data: Use `.gd` resource files or JSON for floor layouts, NPC templates, skill trees

---

## Known Constraints & Gotchas

1. **Procedural generation complexity:** Start with fixed floors, add randomization after core loop works
2. **NPC pathfinding in tight corridors:** Use simple A* or waypoint-based movement; full pathfinding can bottleneck with 100+ NPCs
3. **Influence spread can be expensive:** Use spatial hashing (quadtree) to avoid O(n²) detection checks per frame
4. **Godot 3 vs 4 differences:** This is Godot 4 only (no yield, use await; connect uses callable, not string signals)
5. **Mobile optimization:** 2D performance is good up to ~500 active nodes; beyond that, use object pooling and node culling

---

## Important for AI Collaboration

### Before Implementing
- Ask if unclear: Does this system belong in a single script or split into multiple nodes? Should this be a Signal or a direct function call?
- Propose architecture for complex systems (influence spread, procedural generation) before coding

### Code Review Priorities
- **Correctness:** Does NPC behavior match the design? Do Liquidators actually detect anomalies?
- **Performance:** For loops over large NPC arrays—use spatial queries, not brute force
- **Clarity:** Function names should make intent obvious (e.g., `apply_influence_to_npc()` vs `update_guy()`)

### Testing
- Unit tests for isolated systems (influence calculation, skill cost)
- Integration tests for floor generation (does every floor have at least one residential block?)
- Manual playtesting for feel (is the game fun? Do abilities feel powerful?)

---

## Communication & Decision-Making

- **Design decisions:** If a feature is ambiguous, propose two approaches with tradeoffs (not a survey of all options)
- **Scope creep:** Stick to the three development trees + two game modes for MVP; cosmetic features and story polish come later
- **Flexibility:** The Samosbor lore is intentionally vague; interpret creatively but stay true to the mood (bleak, absurd, unstoppable)

---

## Resources

### Samosbor Lore
- [Research Report (local)](./RESEARCH_REPORT.md) — compiled info on the universe, factions, atmosphere
- [Samosbor Viki (Fandom)](https://samosbors8878.fandom.com/ru/wiki/)
- Existing games (Samosbor on Steam, Reigns of Samosbor) for gameplay reference

### Godot 4 Docs
- [Godot 4 Manual](https://docs.godotengine.org/en/stable/)
- [GDScript Docs](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/index.html)
- Procedural generation with Noise: see `FastNoiseLite` in official docs

### Game Architecture
- [Development Plan (local)](./DEVELOPMENT_PLAN.md) — detailed technical breakdown, sprints, recommended project structure

---

## Quick Start

1. **Init Godot:** Create new project (Godot 4.1+), set physics to 2D
2. **Project settings:** Disable 3D (save memory), set canvas stretch mode to fit
3. **First scene:** Create `scenes/main/game_scene.tscn` with a Node2D root
4. **First script:** `scripts/game_manager.gd` to manage floor progression and game state
5. **Reference:** Check `DEVELOPMENT_PLAN.md` for full directory structure and script templates

---

## Next Steps

Awaiting:
1. Your text document with "разгоны" (ideas/sketches) — will integrate specific mechanics and lore from your version
2. Clarification on any mechanics not covered here
3. Asset/art pipeline setup (who handles sprites, animations, sound?)

This CLAUDE.md is a living document—update it as the design evolves.
