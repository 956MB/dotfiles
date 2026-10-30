function appearance_sync --description 'Sync appearance-dependent env vars (BAT_THEME, DELTA_FEATURES, LG_CONFIG_FILE) with the OS light/dark setting'
    # The tools behind these variables cannot detect light/dark themselves:
    #   BAT_THEME      bat + delta syntax theme (delta uses BAT_THEME when --syntax-theme is unset)
    #   DELTA_FEATURES delta feature name, applied after the [delta] features from git config, so it
    #                  overrides the syntax theme AND the diff washes per appearance
    #   LG_CONFIG_FILE lazygit config file list — the light file only overrides gui.theme
    # Re-detecting costs one short subprocess, so the result is cached for a few seconds and
    # refreshed on startup and before each prompt (hook at the bottom of this file).
    set -l cache_seconds 5
    set -l now (date +%s)

    if set -q __appearance_checked_at
        and test (math "$__appearance_checked_at + $cache_seconds") -gt $now
        return
    end

    set -g __appearance_mode (command "$HOME/dotfiles/scripts/appearance")
    set -g __appearance_checked_at $now

    if test "$__appearance_mode" = light
        set -gx BAT_THEME greyscale-light
        set -gx DELTA_FEATURES greyscale-light
        set -gx LG_CONFIG_FILE "$HOME/dotfiles/lazygit/config.yml,$HOME/dotfiles/lazygit/greyscale-light.yml"
    else
        set -gx BAT_THEME greyscale
        set -gx DELTA_FEATURES greyscale
        set -gx LG_CONFIG_FILE "$HOME/dotfiles/lazygit/config.yml"
    end
end

# Refresh before every prompt so a flip in the OS appearance reaches the next bat/delta/lazygit.
if not functions -q __appearance_prompt_hook
    function __appearance_prompt_hook --on-event fish_prompt
        appearance_sync
    end
end
