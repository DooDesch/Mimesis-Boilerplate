#!/usr/bin/env sh

# Simple setup script to turn the Boilerplate into a real mod
# Usage:
#   cd path/to/YourCopiedBoilerplateFolder
#   ./setup_mod.sh

set -eu

OLD_NAME="Boilerplate"

echo "=== Mimesis Mod Setup (${OLD_NAME} template) ==="

# Detect script directory and move to project root (where the .csproj lives)
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cd "$SCRIPT_DIR"

if [ ! -f "${OLD_NAME}.csproj" ]; then
  echo "Error: Expected '${OLD_NAME}.csproj' in $(pwd), but it was not found."
  echo "Make sure you run this script inside a copy of the '${OLD_NAME}' project folder."
  exit 1
fi

CURRENT_DIR_NAME=$(basename "$(pwd)")

printf "Internal mod name (PascalCase, no spaces) [%s]: " "$CURRENT_DIR_NAME"
read MOD_NAME

if [ -z "$MOD_NAME" ]; then
  MOD_NAME="$CURRENT_DIR_NAME"
fi

case "$MOD_NAME" in
  *[!A-Za-z0-9_]*)
    echo "Error: Mod name may only contain letters, numbers and underscores."
    exit 1
    ;;
  *)
    ;;
esac

echo "Using mod name: $MOD_NAME"

sed_inplace() {
  # GNU sed supports --version, BSD/macOS sed does not
  if sed --version >/dev/null 2>&1; then
    sed -i "$@"
  else
    sed -i '' "$@"
  fi
}

echo "Renaming project file..."
if [ -f "${MOD_NAME}.csproj" ] && [ "${MOD_NAME}.csproj" != "${OLD_NAME}.csproj" ]; then
  echo "Warning: '${MOD_NAME}.csproj' already exists, skipping .csproj rename."
else
  mv "${OLD_NAME}.csproj" "${MOD_NAME}.csproj"
fi

echo "Updating occurrences of '${OLD_NAME}' to '${MOD_NAME}'..."

# Update all relevant text files but skip build output
find . \
  -type f \
  ! -path "./.git/*" \
  ! -path "./bin/*" \
  ! -path "./obj/*" \
  \( -name "*.cs" -o -name "*.csproj" -o -name "*.md" -o -name "*.json" -o -name "*.yml" -o -name "*.yaml" -o -name ".gitignore" \) \
  | while IFS= read -r file; do
      # Skip this script itself
      case "$file" in
        ./setup_mod.sh) continue ;;
      esac
      sed_inplace "s/${OLD_NAME}/${MOD_NAME}/g" "$file"
    done

echo "Renaming config class file..."
if [ -f "Config/${OLD_NAME}Preferences.cs" ]; then
  mv "Config/${OLD_NAME}Preferences.cs" "Config/${MOD_NAME}Preferences.cs"
fi

echo
echo "Done!"
echo "Next steps:"
echo "  - (Optional) Rename the folder '$CURRENT_DIR_NAME' to '$MOD_NAME' in your filesystem."
echo "  - Open '${MOD_NAME}.csproj' and update 'ModsDirectory' and 'GameExePath' to match your setup."
echo "  - Start coding your mod in 'Core.cs', 'Config/${MOD_NAME}Preferences.cs' and 'Patches/'."
echo
echo "You can now build and run your mod as usual."


