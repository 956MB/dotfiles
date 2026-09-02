tell application "Ghostty"
    activate

    set linecastDir to "/Users/bays/Hoard/Forks/linecast"

    set moonCfg to new surface configuration
    set initial working directory of moonCfg to linecastDir
    # set command of moonCfg to "/opt/homebrew/bin/fish -lc 'uv run linecast moon --live'"
    set command of moonCfg to "/opt/homebrew/bin/fish -lc 'uv run linecast maps --no-labels --no-lines --view now --background stars --rotate --legacy-colors'"

    set radarCfg to new surface configuration
    set initial working directory of radarCfg to linecastDir
    set command of radarCfg to "/opt/homebrew/bin/fish -lc 'uv run linecast radar --theme dusk --zoom 14 --layers wind --live'"

    set weatherCfg to new surface configuration
    set initial working directory of weatherCfg to linecastDir
    set command of weatherCfg to "/opt/homebrew/bin/fish -lc 'uv run linecast weather --live --classic-colors'"

    set sunshineCfg to new surface configuration
    set initial working directory of sunshineCfg to linecastDir
    set command of sunshineCfg to "/opt/homebrew/bin/fish -lc 'uv run linecast sunshine --live'"

    set tidesCfg to new surface configuration
    set initial working directory of tidesCfg to linecastDir
    set command of tidesCfg to "/opt/homebrew/bin/fish -lc 'uv run linecast moon --live'"
    # set command of tidesCfg to "/opt/homebrew/bin/fish -lc 'uv run linecast tides --station 8779768 --live'"

    set win to new window with configuration moonCfg
    set moonPane to terminal 1 of selected tab of win

    set radarPane to split moonPane direction left with configuration radarCfg
    set weatherPane to split radarPane direction down with configuration weatherCfg

    set sunshinePane to split moonPane direction down with configuration sunshineCfg
    set tidesPane to split sunshinePane direction right with configuration tidesCfg

    perform action "resize_split:down,380" on sunshinePane

    focus moonPane
end tell
