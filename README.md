# The Friends (`ui-vn`)

An interactive 2D branching visual novel built with **Godot Engine 4.7 (GDScript)** for the *User Interface Design* course at Universidad del Valle.

The story follows **Shae**, a 22-year-old relocated to a new city, navigating the tension between facing the awkwardness of real-world human connections and retreating into the frictionless comfort of an AI companion (**Alexa**).

---

## Features

- **Complete Branching Narrative (`S01`–`S14`):**
  - **3 Core Decisions:** Choose between real-life effort (going to the gym, meeting an old friend, sketching in the park) or staying in with Alexa.
  - **Score-Based Endings:** Accumulated choices (`score_human` vs. `score_ia`) dynamically determine the outcome after a critical family event (**F02: In-Person Reconnection** vs. **F01: Digital Isolation**).
  - **Reflective Closing:** Includes Plato's Allegory of the Cave monologue (`S13`) and an interactive 4-option reflection prompt (`S14`).
- **Scene & Character Presentation:**
  - 8 illustrated 16:9 scenario backgrounds (`bg_apartment.png`, `bg_gym.png`, `bg_office.png`, `bg_hotel.png`, `bg_cafe.png`, `bg_park.png`, `bg_chapel.png`, `bg_cave.png`) plus night/bedroom backdrops.
  - Character sprites for **Connie** (`character_a.png`), **Alexa** (`character_b.png`), and a custom vector **smartphone sprite** (`character_phone_call.svg`) for phone-call scenes, while keeping the protagonist off-screen.
- **Navigation & History Stack:**
  - Advance (`>`) and Back (`<`) controls with full state restoration across dialogue lines, branching choices, and accumulated scores.
- **In-Game Settings Menu:**
  - Accessible via the gear icon or `Esc`, featuring **Resume**, **Fullscreen: On/Off** (centered `1280×720` windowed fallback), **Minimize**, and **Quit Game**.

---

## Requirements

- **Godot Engine 4.7+** (Standard / GL Compatibility build — tested on `v4.7.2-stable`)

### Installing Godot on Windows (via `winget`)

```powershell
winget install --id GodotEngine.GodotEngine --accept-package-agreements --accept-source-agreements
```

Or download directly from [godotengine.org/download](https://godotengine.org/download).

---

## How to Run

### 1. Clone the repository

```bash
git clone https://github.com/Drytec/ui-vn.git
cd ui-vn
git checkout DFMR
```

### 2. Run from Godot Editor

1. Open **Godot Engine**.
2. Click **Import** and select `project.godot` inside the cloned folder.
3. Click **Import & Edit**, wait for assets to finish importing, and press **`F5`** (or the Play button) to start the visual novel.

### 3. Run from Command Line

**Windows (PowerShell):**

```powershell
# First-time headless asset import (if not already imported via the editor)
godot --headless --editor --quit --path .

# Launch the visual novel
godot --path .
```

**macOS / Linux:**

```bash
godot --headless --editor --quit --path .
godot --path .
```

---

## Controls

| Control | Action |
| :--- | :--- |
| **`>` (Next)** | Advance to the next line or scene |
| **`<` (Back)** | Rewind to the previous line, scene, or decision |
| **Choice Buttons** | Select a branching narrative option or closing reflection |
| **Settings Icon / `Esc`** | Open/close the **Settings** menu (`Resume`, `Fullscreen`, `Minimize`, `Quit Game`) |

---

## Project Structure

```text
ui-vn/
├── dialogue/
│   └── story.json            # Full S01–S14 branching narrative graph
├── fonts/                    # Typography assets (Bebas Neue, EB Garamond, Lora, Roboto)
├── icons/                    # UI control SVG icons (settings, history, back, forward)
├── images/                   # Scenario backgrounds & character sprites (PNG / SVG)
├── scenes/
│   ├── game.tscn             # Main visual novel scene, UI layout, and Settings overlay
│   ├── icon_button.tscn      # Reusable icon button scene
│   └── option_button.tscn    # Reusable styled choice/menu button scene
├── scripts/
│   ├── file_functions.gd     # JSON loading helpers
│   └── game.gd               # Narrative state machine, history stack, and settings logic
├── project.godot             # Godot 4.7 project configuration
└── LICENSE
```

---

## Authors & Course

- **Authors:** Dylan Morales, Javier Humberto Grijalba Camayo
- **Course:** User Interface Design (*Diseño de interfaces de usuario*) — Universidad del Valle
- **Instructor:** Paola Rodriguez

---

## License

This project is licensed under the terms of the [LICENSE](LICENSE) file.
