# 🕹️ Ping Pong Game – Assembly Language Project

This is a **2-player console-based Ping Pong game** built using **x86 Assembly Language**, developed as part of a low-level systems programming project. The game runs in **text mode** using direct video memory access and BIOS interrupts, providing a hands-on experience with low-level hardware interaction and graphics rendering.

---

## 🎮 Game Features

- ⚙️ Developed in pure **Assembly Language (x86)**
- 🎾 Real-time 2-player gameplay using keyboard:
  - Player 1: `u` (up), `d` (down)
  - Player 2: `o` (up), `l` (down)
- 🧠 Simple AI logic for ball movement and collision detection
- 🧱 Ball bounces off paddles and screen borders
- 📊 Live score tracking with victory detection
- 🖥️ Visual display rendered using **VGA text-mode graphics**
- 🕹️ Runs directly on **DOSBox** or compatible x86 emulators
- ❌ No external libraries — low-level hardware interaction only

---

## 🚀 How to Run

### 1. Clone the Repository
```bash
git clone https://github.com/NIMRAH-S/Ping-Pong-Assembly-Game.git
cd Ping-Pong-Assembly-Game

2. Compile the Game (Using NASM)
nasm -f bin game.asm -o game.com

💡 game.asm must follow 16-bit real mode format to run properly in DOSBox or similar emulators.

3. Run the Game (Recommended: DOSBox)
# In DOSBox
mount c path\to\Ping-Pong-Assembly-Game
c:
game.com
```
---

### 📝 Controls
- 🎮 Move your paddle using defined keys (check the top of game.asm for configuration)
- 🏓 The ball will bounce on the paddle and screen edges
- ❌ Game ends if you miss the ball
  
  ---

### 👨‍💻 Contributors
- Nimrah Shahid
- Saman Mahwish
