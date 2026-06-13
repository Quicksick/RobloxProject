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
3. Equip the axe and chop down trees.
4. Collect enough wood.
5. Repair the broken starter raft.
6. Use the repaired raft to begin sailing toward nearby islands.

Right now, Play mode builds a simple visible prototype world with an ocean, Old Harbor, a dock, Coconut Cay, a treasure chest, a broken starter raft, trees, and First Mate Finn on the starter island.

Run to First Mate Finn and press `E` to get a Wooden Axe. Equip it, click near trees to chop them down, collect wood, then press `E` at the broken raft to repair it.

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
