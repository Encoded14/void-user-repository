#!/usr/bin/env bash
# Void User Repository Helper (vur)
# A script to manage user-contributed Void packages similar to an AUR helper.

set -e

# --- CONFIG ---
USER_DIR="$HOME/void-user-repository"
VOID_PKGS_DIR="$USER_DIR/void-packages"
EXTRA_REPO_URL="https://github.com/Encoded14/void-user-repository.git"
EXTRA_REPO_DIR="$USER_DIR/void-user-repository"
SHLIBS_FILE="$VOID_PKGS_DIR/common/shlibs"
SHLIBS_APPEND_FILE="$EXTRA_REPO_DIR/shlibs_append"
SHLIBS_REMOVE_FILE="$EXTRA_REPO_DIR/shlibs_remove"

# --- FUNCTIONS ---

check_command() {
    if ! command -v "$1" &>/dev/null; then
        echo "ERROR: $1 is not installed. Please install it first."
        exit 1
    fi
}

clone_or_update() {
    local repo_url=$1
    local dir=$2
    local name=$3

    if [ ! -d "$dir" ]; then
        echo "→ Cloning $name..."
        git clone "$repo_url" "$dir"
    else
        echo "→ Updating $name..."
        cd "$dir"
        git fetch origin master
        cd - >/dev/null 
    fi
}

edit_shlibs() {
    echo "=> Updating common/shlibs..."

    # Remove lines listed in shlibs_remove (if exists)
    if [ -f "$SHLIBS_REMOVE_FILE" ]; then
        while IFS= read -r line; do
            [ -z "$line" ] && continue
            grep -vF "$line" "$SHLIBS_FILE" > "$SHLIBS_FILE.tmp" && mv "$SHLIBS_FILE.tmp" "$SHLIBS_FILE"
            echo "   - removed: $line"
        done < "$SHLIBS_REMOVE_FILE"
    fi

    # Append new lines (avoid duplicates)
    if [ -f "$SHLIBS_APPEND_FILE" ]; then
        while IFS= read -r line; do
            [ -z "$line" ] && continue
            if ! grep -qF "$line" "$SHLIBS_FILE"; then
                echo "$line" >> "$SHLIBS_FILE"
                echo "   + added: $line"
            fi
        done < "$SHLIBS_APPEND_FILE"
    fi
}

# --- MAIN ---

check_command git

mkdir -p "$USER_DIR"

clone_or_update "https://github.com/void-linux/void-packages.git" "$VOID_PKGS_DIR" "void-packages"
clone_or_update "$EXTRA_REPO_URL" "$EXTRA_REPO_DIR" "extra templates repo"

cd "$VOID_PKGS_DIR"

# Reset to a pristine, up-to-date master every run
echo "=> Resetting repository to latest master..."
git fetch --prune origin master
git switch -C master origin/master

# Apply custom edits
echo "=> Applying inline edits..."
rm -rf srcpkgs/hyprutils/patches

# Copy templates from your extra repo
echo "=> Copying templates from extra repo..."
cp -r "$EXTRA_REPO_DIR"/srcpkgs/* ./srcpkgs/ 2>/dev/null || true

# Edit common/shlibs
edit_shlibs

# Enable restricted builds
echo "=> Ensuring XBPS_ALLOW_RESTRICTED is enabled..."
CONF_FILE="$VOID_PKGS_DIR/etc/conf"
mkdir -p "$(dirname "$CONF_FILE")"
grep -q "^XBPS_ALLOW_RESTRICTED=yes" "$CONF_FILE" 2>/dev/null || echo "XBPS_ALLOW_RESTRICTED=yes" >> "$CONF_FILE"

# Bootstrap
echo "=> Bootstrapping build environment..."
./xbps-src binary-bootstrap

# Build packages
if [ $# -eq 0 ]; then
    echo "Usage: $0 <package1> [package2 ...]"
    exit 1
fi

for pkg in "$@"; do
    echo "=> Building package: $pkg"
    ./xbps-src pkg "$pkg"
done

# Install built packages
echo "=> Installing built packages..."
sudo xbps-install -S \
    --repository "$VOID_PKGS_DIR/hostdir/binpkgs/" \
    --repository "$VOID_PKGS_DIR/hostdir/binpkgs/nonfree" \
    "$@"

# Clean up changes to keep repo pristine
echo "=> Reverting all local edits..."
git restore . 2>/dev/null || true

echo "=> All done! Packages installed successfully."
