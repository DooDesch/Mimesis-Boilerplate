# MIMESIS - Boilerplate

> 🛟 **Need help or found a bug?** Get support at [support.doodesch.de/boilerplate](https://support.doodesch.de/boilerplate).


> A starter template for MelonLoader mods for MIMESIS. Clone it, run the rename script, and you have a ready-to-build mod skeleton that already matches the project conventions.

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![Game](https://img.shields.io/badge/game-MIMESIS-purple)
![MelonLoader](https://img.shields.io/badge/MelonLoader-0.7.3%2B-green)
![Status](https://img.shields.io/badge/status-template-lightgrey)

This is a developer template, not a player-facing feature mod. Installing it does nothing in game - it just logs that it initialized. Use it as the starting point for a new Mimesis mod.

## Features

- **Minimal MelonMod entry point** (`Core.cs`): on `OnInitializeMelon` it initializes preferences, calls `HarmonyInstance.PatchAll()`, and logs `Boilerplate initialized. Enabled={value}`. No game behavior is patched.
- **MelonPreferences config scaffold** (`Config/BoilerplatePreferences.cs`): an idempotent `Initialize()` plus a typed `CreateEntry<T>` helper that demonstrates the standard preferences pattern.
- **Harmony patch stub** (`Patches/ExamplePatch.cs`): a fully commented-out example of the `[HarmonyPatch(typeof(Class), "Method")]` + Prefix/Postfix pattern. It is not compiled (its `<Compile Include>` line is commented out in the `.csproj`).
- **One-command setup script** (`setup_mod.sh`, POSIX sh): prompts for a PascalCase mod name, renames the `.csproj`, replaces every `Boilerplate` occurrence across `.cs`/`.csproj`/`.md`/`.json`/`.yml`/`.gitignore`, renames the preferences file, and deletes `.git` so you do not push back to the template.
- **GitHub Actions release workflow** (`.github/workflows/build-and-release.yml`): on a `v*` tag it checks out a private Workspace repo, verifies the tag matches the csproj `<Version>`, builds Release, publishes a GitHub Release with the DLL, and uploads the package to Thunderstore.
- **PostBuild auto-copy**: the built DLL is copied to the configured `ModsDirectory`; commented-out helpers exist for copying `MimicAPI.dll` and auto-launching the game after a build.
- **Optional MimicAPI integration pre-wired but disabled**: a commented `MelonOptionalDependencies("MimicAPI")` in `Core.cs` and a commented `ProjectReference` (`Private=false`) plus `MimicAPIPath` in the `.csproj`. Uncomment to enable.

## Requirements

| Component | Version |
|---|---|
| MIMESIS | 0.3.0 (current Steam build) |
| MelonLoader | 0.7.3+ |
| .NET SDK | for building (target framework `netstandard2.1`) |
| Workspace/lib | game DLLs (`lib/game`) + `MelonLoader.dll` / `0Harmony.dll` (`lib/melonloader`) |

> The published `thunderstore/manifest.json` still declares `LavaGang-MelonLoader-0.7.1`. The supported runtime target is MelonLoader 0.7.3+.

## Configuration

Stored in `UserData/MelonPreferences.cfg` under the `Boilerplate` category.

| Option | Description | Default | Values/Range |
|---|---|---|---|
| `Enabled` | Enable Boilerplate functionality. When disabled, the mod will not modify game behavior. The template only logs this value - new mods are expected to gate their patches on it. | `true` | boolean (true/false) |

## Usage

There is no in-game usage and no keybinds - this is a developer template. Workflow for starting a new mod:

1. Clone or copy this folder.
2. Run `./setup_mod.sh` and enter a PascalCase mod name. The script renames the `.csproj`, replaces all `Boilerplate` strings, renames the Config preferences file, and removes `.git`.
3. Optionally rename the folder to match.
4. Re-init Git (`git init && git add . && git commit -m "Initial commit"`).
5. Edit the new `.csproj`: set `ModsDirectory` and `GameExePath` to your install, and confirm `WorkspaceLibPath` points at your `Workspace/lib` (default `$(MSBuildThisFileDirectory)../Workspace/lib`).
6. Build with `dotnet build -c Release` in the mod folder. PostBuild copies the DLL into `MIMESIS/Mods`.

To use the patch example, uncomment `Patches/ExamplePatch.cs` and add its `<Compile Include>` line in the `.csproj`.

To use MimicAPI, uncomment the `MelonOptionalDependencies` attribute in `Core.cs` and the `ProjectReference` in the `.csproj`, then build the Workspace `MimicAPI` project.

## Compatibility

Built for Mimesis 0.3.0 / MelonLoader 0.7.3.

## Building (developers)

```sh
dotnet build -c Release
```

References resolve through `Workspace/lib/game` (game DLLs) and `Workspace/lib/melonloader` (`MelonLoader.dll`, `0Harmony.dll`). The PostBuild target copies the built DLL into `MIMESIS/Mods`. The GitHub Actions workflow pins the build SDK to 8.0.x; the local environment uses a newer SDK.

## Credits / License

Author: DooDesch. Licensed under the MIT License (see `LICENSE.md`).

Repository: <https://github.com/DooDesch/Mimesis-Boilerplate>

## AI disclosure

The mod icon is AI-generated. Code and configuration are hand-written.
