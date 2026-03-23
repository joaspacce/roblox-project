# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **Roblox game development project** using **Rojo** for filesystem-based development. The project features a speed boat simulation with realistic physics, dynamic lighting systems, and a clean client-server architecture.

## Build System

**Rojo 7.6.1** (managed via Aftman)

```bash
# Build place file
rojo build -o "roblox-project.rbxlx"

# Start development server (hot-reload into Roblox Studio)
rojo serve
```

## Project Structure

```
src/
├── ReplicatedStorage/      # Shared between server and client
│   └── Speed Boat/         # Main boat system
│       └── Body/Main_Model/
│           ├── BoatScriptServer.server.lua   # Physics & control logic
│           ├── DriveSeat/
│           │   ├── InitializeBoatScripts.server.lua
│           │   └── HelmGUI/                  # Boat control UI
│           └── qPerfectionWeld.server.lua    # Auto-welding utility
├── Workspace/              # In-game world (lighting system)
├── client/                 # Root client scripts
├── server/                 # Root server scripts
└── shared/                 # Shared modules
```

## Architecture Patterns

### Client-Server Communication
- All game logic runs on server (`.server.lua` files)
- Client handles UI and input (`.client.lua` files)
- RemoteEvents for communication: `ToggleEngine`, `Steer`, `Throttle`, `ToggleSound`, `Thrusters`

### File Naming Conventions
- `*.server.lua` / `*.server.luau` - Server-side scripts
- `*.client.lua` / `*.client.luau` - Client-side scripts
- `*.lua` / `*.luau` without suffix - ModuleScripts
- `init.meta.json` - Rojo metadata for instance configuration

### State Management
- Uses Roblox Value objects (`IntValue`, `BoolValue`, etc.) for reactive state
- Configuration via nested Value objects under `Values/` folders

## Key Systems

### Speed Boat Physics
- MaxSpeed: 70 units
- Uses BodyVelocity, BodyGyro, BodyPosition for physics
- Controls: T (engine), Q/E (thrusters), H (horn), G (hook)

### Dynamic Lighting
- Time-based activation (17:30-6:15)
- Fade animations with configurable brightness, range, and color

## Development Notes

- No external package manager - pure Lua/Luau
- Avoid client-side physics calculations (server authority pattern)
- Use `spawn()` for async operations to prevent blocking
- Recursive traversal pattern via `CallOnChildren()` for model hierarchies
