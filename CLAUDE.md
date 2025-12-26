# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**GradLife: The Thesis** is a Godot 4.x 2D pixel art life simulation game similar to Stardew Valley, but focused on graduate school life and thesis writing. The core gameplay combines top-down 2D exploration with narrative elements and time/resource management mechanics.

## Technology Stack

- **Engine:** Godot 4.x
- **Language:** GDScript (.gd files)
- **Architecture:** Autoload singletons for global systems, Signal Bus for decoupled communication
- **Scene Structure:** .tscn files (Godot scenes)
- **Resources:** .tres files (Godot resources)

## Project Structure (Godot `res://` paths)

The codebase follows a strict naming convention:
- **Folders:** snake_case (e.g., `src/autoload/`, `scenes/characters/`)
- **Scenes and Classes:** PascalCase (e.g., `Player.gd`, `TimeSystem.gd`)

### Key Directories

```
res://
├── assets/              # Raw art and audio resources
│   ├── sprites/         # Character sprites, environment tiles, items, UI
│   ├── audio/           # Sound effects and music
│   └── fonts/           # Pixel font files (.ttf/.otf)
├── scenes/              # All .tscn scene files
│   ├── characters/      # Character scenes (Player.tscn, NPC_Tutor.tscn)
│   ├── world/           # Map scenes (Dorm.tscn, Lab.tscn, Canteen.tscn)
│   ├── objects/         # Interactive objects (Bed.tscn, Computer.tscn)
│   ├── ui/              # UI scenes (HUD.tscn, DialogBox.tscn, PhoneMenu.tscn)
│   └── main/            # Entry scenes (Main.tscn, TitleScreen.tscn)
├── src/                 # All .gd script files
│   ├── autoload/        # Global singleton scripts
│   ├── characters/      # Character logic (Player.gd, NPC.gd, StateMachine.gd)
│   ├── interaction/     # Interaction system logic
│   ├── ui/              # UI controller scripts
│   └── resources/       # Custom resource definitions
└── data/                # Game data resources (.tres)
    ├── dialogs/         # Dialogue files
    ├── schedules/       # NPC schedules
    └── items/           # Item properties
```

## Core Architecture

### Autoload Singletons (Global Systems)

Registered in Project Settings -> Globals:

1. **TimeSystem.gd**
   - **Purpose:** Manages game time progression
   - Key variables: `current_day`, `current_hour`, `current_minute`, `game_speed`
   - Logic: 1 real second = 1 game minute
   - Signals: `time_tick`, `hour_changed`, `day_started`, `day_ended`

2. **PlayerStats.gd**
   - **Purpose:** Manages player RPG statistics
   - Key variables:
     - `energy`: Used for movement and work; reaching 0 causes fainting
     - `sanity`: Mental state; high pressure causes negative events
     - `thesis_progress`: Core game completion metric (0-100%)
     - `knowledge`: Used to unlock advanced thesis chapters
   - Methods: `change_energy(amount)`, `check_game_over()`

3. **GlobalSignals.gd**
   - **Purpose:** Central event hub for decoupled communication
   - Common signals: `dialog_requested(dialog_id)`, `minigame_started`, `scene_change_requested`

### Interaction System

The core gameplay mechanic uses an interface/inheritance pattern:

- **Base Class:** `InteractableObject` (registered with `class_name`)
- **Core Method:** `interact(player_ref)` - Called when player presses E key
- **Implementation Examples:**
  - `Bed` -> Opens sleep confirmation UI -> Calls `TimeSystem.skip_to_next_day()`
  - `Computer` -> Pauses world -> Opens research mini-game UI
  - `NPC` -> Pauses world -> Opens dialogue UI

### NPC Behavior System

NPCs have daily schedules and navigation:

- **Data Structure:** `NPCSchedule` resource stores time-based location data
- **Navigation:** Uses `NavigationRegion2D` (map nav mesh) + `NavigationAgent2D` (NPC pathfinding)
- **Logic:** `TimeSystem` emits `hour_changed` -> NPC checks schedule -> Moves if location differs

## Common Development Commands

Since this is a Godot project, development happens within the Godot Editor. However, for CI/CD and automation:

```bash
# Run Godot headless (for CI/headless testing)
godot --headless --path . --script export_presets.cfg

# Export project (requires export_presets.cfg)
godot --headless --export-release "Windows Desktop" builds/gradlife.exe

# Validate project (check for errors)
godot --headless --check-only --script res://main.gd

# Run with debug (if using command line runner)
godot --path . --debug
```

**Note:** For development, use the Godot Editor (godot editor executable). Common workflows:
- Press F6 to run the current scene
- Press F5 to run the project from Main.tscn
- Use the Debugger panel to inspect variables and signals
- Use the Remote tab to inspect the scene tree while running

## Gameplay Loop

### Macro Loop (Daily)
1. Morning (8:00): Wake up in dorm, restore energy
2. Planning: Check phone/schedule, decide daily goals
3. Movement: Travel to locations, consume game time
4. Work/Social: Interact to gain thesis progress/knowledge, consume energy
5. Evening: Free time or deadline crunch (high risk, high reward)
6. Sleep: Must sleep by 2:00 AM or face penalties next day

### Micro Loop (Research Work)
1. **Literature Review (Knowledge gain):**
   - Mini-game: Card matching or memory game
   - Cost: -20 energy, +2 hours
   - Reward: +5 knowledge points

2. **Code/Experiments (Progress gain):**
   - Mini-game: Progress bar QTE or puzzle mechanics
   - Risk: Possible bugs (progress loss) or errors (sanity loss)

3. **Group Meeting (Boss Fight):**
   - Format: Dialogue choices based on knowledge level
   - Outcome: Correct answers increase advisor relationship, wrong answers reduce sanity

## UI/UX Architecture

### HUD (Always Visible)
- Top-left: Time (clock icon), Date (Week X, Day Y)
- Top-right: Energy bar (green), Sanity bar (purple)
- Bottom-left: Phone icon (menu access)

### Dialogue Box
- Displays NPC avatar, name, typewriter-effect text
- Supports branching choices (A/B options) with callback functions

### Phone Interface
- App-style menu system:
  - "WeChat": NPC messages
  - "Notes": Current quest objectives
  - "Alipay": Balance (for food, coffee)

## Development Roadmap

The project is currently in **Phase 1: Prototype**:

**Phase 1: Prototype**
- [ ] Establish folder structure
- [ ] Create Player with 8-direction top-down movement
- [ ] Create simple TileMap room (dorm) with collision and Y-Sort
- [ ] Implement Interactable base class with test object

**Phase 2: Core Systems**
- [ ] Implement TimeSystem with UI time display
- [ ] Implement PlayerStats with UI stat bars
- [ ] Complete sleep cycle: E key -> next day -> energy restore

**Phase 3: World Building**
- [ ] Create multiple scenes (dorm, lab)
- [ ] Implement scene transitions via doorways
- [ ] Complete computer work: energy cost -> thesis progress

**Phase 4: NPCs and Narrative**
- [ ] Create NPC prefabs
- [ ] Implement dialogue system (Dialogue Manager plugin or custom JSON)
- [ ] Implement NPC schedule-based movement

## Key Resources

- **Design Document:** `INFORMATION.md` - Contains the complete game design specification
- **Engine Documentation:** https://docs.godotengine.org/en/stable/
- **GDScript Reference:** https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/

## Working with This Repository

1. **Always reference the design document:** `INFORMATION.md` contains the canonical specification for all game systems
2. **Maintain naming conventions:** snake_case for folders, PascalCase for scenes/classes
3. **Use Signal Bus pattern:** Avoid direct node references; use signals for communication
4. **Autoload for globals:** TimeSystem, PlayerStats, and GlobalSignals are the only global state
5. **Test interactions early:** The interaction system is the core gameplay loop

## Notes

- The project is in early development; most files may not exist yet
- Focus on following the architecture defined in INFORMATION.md
- When implementing new features, ensure they align with the gameplay loop described above
- All code should be GDScript 2.0 (Godot 4.x syntax)
