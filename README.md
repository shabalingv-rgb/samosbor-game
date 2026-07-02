# Самосбор: Обратная сторона обоев

![Status: Early Development](https://img.shields.io/badge/status-Early%20Development-yellow)
![Godot 4](https://img.shields.io/badge/godot-4.x-blue)
![License: TBD](https://img.shields.io/badge/license-TBD-gray)

A strategic management horror game where you control **Samosbor**, a mysterious entity born from a Soviet mega-structure, attempting to infiltrate and consume a 100-floor tower block through psychological manipulation, resource management, and strategic mutation.

## 🎮 Game Overview

**Genre:** Management Strategy, Real-Time Indirect Control Simulator, Psychological Horror  
**Inspirations:** Plague Inc, Beholder, Cultist Simulator

### Core Concept

Samosbor is not human. Not fully understood. It emerges from the Gigakhrushchyovka—an infinite Soviet apartment building—but exists separate from it. Your goal: **consume the tower, replace its architecture, understand yourself through expansion.**

### Key Features

- **Two-Phase Cycle:** Alternate between hidden accumulation (spreading influence) and active outbreak (consuming the population)
- **Dual Resource Economy:** Biomass (physical) and Terror (psychological)
- **Emergent Storytelling:** Environmental clues, NPC records, and procedurally-varied conflicts reveal the world through multiple perspectives
- **Strategic Depth:** Mutate your capabilities, manage Liquidators, create cults, transport your nest, survive
- **Unique Art:** Hand-drawn on Soviet wallpaper texture with pencil sketch aesthetic

## 📋 Project Status

**Current Phase:** Sprint 0 (Godot MVP + Documentation)  
**ETA to Playable Build:** 12-17 weeks

### Development Roadmap

- [x] Game Design Document
- [x] Technical Planning (with AI recommendations)
- [x] Godot Project Structure
- [ ] Sprint 1: Base Systems (resources, phases, basic UI)
- [ ] Sprint 2: NPC & Enemy Basics
- [ ] Sprint 3: Ventilation & Infection
- [ ] Sprint 4: Cultist System & Behavior Trees
- [ ] Sprint 5: Mutation Trees & Progression
- [ ] Sprint 6: Procedural Generation
- [ ] Sprint 7: Full Phase 1 Playability
- [ ] Sprint 8: Phase 2 & Combat
- [ ] Sprint 9: Narrative Events & Polish
- [ ] Sprint 10+: Final Polish & Testing

## 🛠️ Getting Started

### Requirements

- **Godot 4.1+** ([Download](https://godotengine.org/))
- **Git** (for version control)
- **Text Editor** (VS Code recommended with GDScript extension)

### Setup Instructions

See [SETUP.md](./SETUP.md) for detailed instructions.

**Quick Start:**
```bash
# 1. Clone the repository
git clone https://github.com/YOUR_USERNAME/samosbor-game.git
cd samosbor-game

# 2. Open Godot and select the /godot/ folder as project
# File → Open Project → navigate to /godot/

# 3. Press F5 to run game_scene.tscn
```

### Project Structure

```
├── godot/                      # Godot 4 project
│   ├── scenes/                 # .tscn files
│   │   └── main/
│   │       └── game_scene.tscn
│   ├── scripts/                # .gd files
│   │   └── game_manager.gd
│   ├── assets/                 # Sprites, audio, data
│   └── project.godot           # Godot config
│
├── CLAUDE.md                   # AI collaboration guidelines
├── GAME_DESIGN_DOCUMENT.md     # Complete GDD
├── DEVELOPMENT_PLAN_V2.md      # Technical roadmap + AI models
├── SETUP.md                    # Project setup guide
├── README.md                   # This file
│
└── archive/                    # Research documents & devlog
    ├── legend/
    │   └── DEVLOG.md          # Development log
    └── [research papers]
```

## 📖 Documentation

- **[GAME_DESIGN_DOCUMENT.md](./GAME_DESIGN_DOCUMENT.md)** — Full mechanical & narrative design
- **[DEVELOPMENT_PLAN_V2.md](./DEVELOPMENT_PLAN_V2.md)** — Sprint roadmap + AI recommendations
- **[CLAUDE.md](./CLAUDE.md)** — AI collaboration guidelines & architecture notes
- **[SETUP.md](./SETUP.md)** — Environment setup instructions

## 🎨 Visual Style

**Hand-drawn Soviet wallpaper aesthetic** with pencil/marker strokes on faded retro background.

- **Color Palette:** Beige/grey oboe + fiolent/maroon Samosbor + yellow/orange danger indicators
- **Technique:** "Line Boil" effect (trembling lines) to convey alien consciousness
- **Fonts:** Handwritten-style system font mixed with Godot's default

## 🔧 Technology Stack

- **Engine:** Godot 4.x (open-source)
- **Language:** GDScript
- **2D Graphics:** Aseprite / Krita (hand-drawn style)
- **Audio:** Audacity (Soviet ambient, siren, voices)
- **Version Control:** Git + GitHub

## 📋 Game Mechanics Summary

### Resources
- **Biomass:** Generated from consuming bodies, spent on physical mutations
- **Terror:** Generated from fear/sounds/visions, spent on psychological effects

### Phases
1. **Accumulation:** Spread influence via ventilation, infect, create cultists (5-20 min)
2. **Active Outbreak:** Consume isolated population with mutations and creatures (5-15 min)

### Progression
- 100 procedurally-varied floors
- 3 mutation trees: Mentality, Biomass, Development
- 2 game modes: Story (100 floors + narrative) | Infinite (survive until thermobaric weapon)

## 🤝 Collaboration

This project uses **Claude AI** (Opus, Sonnet, Haiku) for collaborative development with human designers.

See [CLAUDE.md](./CLAUDE.md) for guidelines on:
- Architecture decisions
- Code style & review process
- AI model recommendations per task

## 📝 Development Log

Development updates, feature implementations, and screenshots are logged in [archive/legend/DEVLOG.md](./archive/legend/DEVLOG.md).

## 🎯 Vision

We're creating a game that:
- ✅ Tells emergent narratives through game systems (not cutscenes)
- ✅ Makes players uncomfortable with power (you ARE the monster)
- ✅ Respects player intelligence (complex systems, no hand-holding)
- ✅ Celebrates Soviet aesthetic horror (mundane dread > jump scares)
- ✅ Explores what it means to be alive (even for anomalies)

## 📄 License

TBD (to be determined during development)

## 🔗 Resources

**Samosbor Universe:**
- [Samosbor Viki (Fandom)](https://samosbors8878.fandom.com/ru/wiki/)
- [Wikireality](https://wikireality.ru/wiki/)
- Existing games: Samosbor (Steam), Reigns of Samosbor, КЛЕТЬ

**Godot:**
- [Godot 4 Manual](https://docs.godotengine.org/)
- [GDScript Reference](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/)

## 🚀 Next Steps

1. **Sprint 0:** Godot initialization ✅
2. **Sprint 1:** Base systems (resources, phases, UI)
3. Submit feedback via GitHub Issues

---

**Created:** July 2, 2026  
**Status:** Early Development  
**Team:** 2 developers (Programmer + Artist) with AI collaboration
