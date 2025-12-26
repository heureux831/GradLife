# GradLife: The Thesis

A 2D pixel art life simulation game about graduate school and thesis writing, built with Godot 4.x.

## About

Navigate the challenges of graduate school life: manage your time, maintain your sanity, and write your thesis. Similar to Stardew Valley, but with research, deadlines, and academic challenges instead of farming.

## Development Status

**Phase 1: Prototype** ✅

Currently implemented:
- [x] Player with 8-direction top-down movement
- [x] Simple dorm room with collision detection
- [x] Interactable object system (press E to interact)
- [x] Global systems (TimeSystem, PlayerStats, GlobalSignals)
- [x] Test object that prints "Hello"

## Getting Started

### Prerequisites

- Godot 4.x ([Download](https://godotengine.org/download))

### Running the Project

1. Open Godot Engine
2. Click "Import" and select this project's `project.godot` file
3. Click "Run" (F5) to start the game

### Controls

- **WASD / Arrow Keys**: Move the player
- **E**: Interact with objects
- **ESC** (Debug builds): Show debug stats in console

### Project Structure

```
res://
├── assets/          # Sprites, audio, fonts
├── scenes/          # Game scenes (.tscn)
│   ├── main/        # Entry scenes
│   ├── characters/  # Player and NPCs
│   ├── world/       # Maps and rooms
│   ├── objects/     # Interactive objects
│   └── ui/          # UI elements
├── src/             # Scripts (.gd)
│   ├── autoload/    # Global singletons
│   ├── characters/  # Character logic
│   ├── interaction/ # Interaction system
│   └── world/       # World management
└── data/            # Game data (.tres)
```

## Architecture

### Core Systems

**TimeSystem** - Manages in-game time progression
- 1 real second = 1 game minute
- Emits signals for time changes

**PlayerStats** - Manages player statistics
- Energy, Sanity, Thesis Progress, Knowledge
- Game over conditions

**GlobalSignals** - Event hub for decoupled communication
- Dialogs, minigames, UI updates

**Interaction System**
- InteractableObject base class
- InteractionManager for proximity detection
- Press E to interact

## Next Development Phase

**Phase 2: Core Systems**
- [ ] TimeSystem UI display
- [ ] PlayerStats UI (energy/sanity bars)
- [ ] Sleep cycle implementation
- [ ] Multiple rooms and scene transitions

**Phase 3: World Building**
- [ ] Laboratory and canteen scenes
- [ ] Door transitions
- [ ] Computer work mini-game
- [ ] Bed interaction

**Phase 4: NPCs and Narrative**
- [ ] NPC characters
- [ ] Dialogue system
- [ ] Schedule-based NPC movement
- [ ] Story progression

## Design Document

See `INFORMATION.md` for the complete game design specification.

## CLAUDE.md

See `CLAUDE.md` for detailed guidance for Claude Code (AI assistant).

## License

This project is in development.
