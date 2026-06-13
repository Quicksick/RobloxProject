# RobloxProject

A small Roblox project set up for collaboration with Git, GitHub, Rojo, and Roblox Studio.

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
- `src/ReplicatedStorage` is for shared modules and assets.
- `src/ServerScriptService` is for server-only scripts.
- `src/StarterPlayer/StarterPlayerScripts` is for player/client scripts.

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
