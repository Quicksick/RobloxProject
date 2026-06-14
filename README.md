# RobloxProject

A pirate adventure Roblox project set up for collaboration with Git, GitHub, Rojo, and Roblox Studio.

Players will sail pirate ships to new islands, collect treasure, upgrade weapons, and buy better ships.

## Getting Started

1. Install Roblox Studio.
2. Install Rojo from <https://rojo.space/docs/installation/>.
3. Open this folder in your editor.
4. Start Rojo:

```powershell
rojo serve
```

5. In Roblox Studio, install/open the Rojo plugin and connect to the running Rojo server.

## Project Layout

- `default.project.json` maps local files into Roblox services.
- `src/ReplicatedStorage/Config` stores shared game data for islands, ships, and weapons.
- `src/ServerScriptService/Services` stores server systems such as player data, ships, and quests.
- `src/StarterPlayer/StarterPlayerScripts/Controllers` stores player/client scripts.

## First Playable Goal

Build toward this first loop:

1. Spawn at Old Harbor.
2. Talk to First Mate Finn to get a Wooden Axe.
3. Equip the axe and chop down trees for wood.
4. Click shrubs or press `F` near them to gather plant fibres.
5. Click the raft or press `F` near it to fix the raft with wood and make the sail from plant fibres.
6. Click the repaired raft or press `F` near it to board, then use `W`, `A`, `S`, and `D` to sail.
7. Sail to Driftwood Atoll and Mangrove Isle for more wood and plant fibres.
8. Use the raft upgrade post to upgrade the raft 3 times until it is fully finished.

Right now, Play mode builds a simple visible prototype world with an ocean, Old Harbor, a dock, Coconut Cay, a treasure chest, a broken starter raft, trees, shrubs, and First Mate Finn on the starter island.

Run to First Mate Finn and press `F` to get a Wooden Axe. Equip it, click near trees to chop them down, click shrubs to gather plant fibres, then click the broken raft to repair the hull and sail. Once repaired, click the raft to sit in it and sail with `W`, `A`, `S`, and `D`.

The raft has 3 upgrades. Each upgrade costs more wood and plant fibres, reveals new raft parts, and makes the raft sail faster.

Press `E` to open or close the inventory. It shows Wood, Plant Fibres, and Raft Level.

The ocean is deep. Falling in makes the player swim, drains Swim Stamina, and starts damaging health once stamina is empty. Death respawns the player back at Old Harbor. If Studio was already running, stop Play and start it again after syncing so the generated terrain is rebuilt.

## Starter Game Data

- Islands: Old Harbor, Coconut Cay, Skull Reef.
- Ships: Dockside Dinghy, Swift Sloop, Storm Brigantine.
- Tools/weapons: Wooden Axe, Rusty Cutlass, Boarding Axe, Flintlock Pistol, Captain's Saber.

## Publish To GitHub

If the GitHub CLI is installed and you are signed in, run:

```powershell
gh repo create RobloxProject --private --source=. --remote=origin --push
```

If you create the repository manually on GitHub, run:

```powershell
git remote add origin https://github.com/YOUR_USERNAME/RobloxProject.git
git push -u origin main
```

## Useful Commands

```powershell
git status
git add .
git commit -m "Describe the change"
git push
rojo serve
```
