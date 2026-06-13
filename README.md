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
2. Walk to the dock and spawn the Dockside Dinghy.
3. Sail to Coconut Cay.
4. Open a treasure chest.
5. Earn gold.
6. Spend gold on a better weapon or ship upgrade.

Right now, Play mode builds a simple visible prototype world with an ocean, Old Harbor, a dock, Coconut Cay, a treasure chest, and a starter ship placeholder.

## Starter Game Data

- Islands: Old Harbor, Coconut Cay, Skull Reef.
- Ships: Dockside Dinghy, Swift Sloop, Storm Brigantine.
- Weapons: Rusty Cutlass, Boarding Axe, Flintlock Pistol, Captain's Saber.

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
