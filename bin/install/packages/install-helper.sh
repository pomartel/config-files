# Package install helper with optional post-install callback
# Usage:
#   install_pkg <package> <description> [callback_function_name]

install-pkg() {
    local pkg="$1"
    local desc="$2"
    local callback="$3"

    if omarchy-pkg-missing "$pkg"; then
        echo "Installing $desc..."
        if sudo pacman -S --noconfirm "$pkg"; then
            # If a callback function name was provided, call it
            # You can choose to accept pkg/desc as arguments in the callback
            if [[ -n "$callback" ]]; then
                "$callback"
            fi
        else
            echo "Failed to install $pkg" >&2
            return 1
        fi
    else
        echo "$desc is already installed."
    fi
}