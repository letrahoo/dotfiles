-- Installed as iTerm2's AutoLaunch.scpt on machines using this hotkey profile.
-- Never substitute an ordinary window, even if it has the same profile name.
on run
    set wanted to "Hotkey Window (Everforest)"
    tell application id "com.googlecode.iterm2"
        repeat with w in windows
            if is hotkey window of w then
                if (hotkey window profile of w) is wanted then
                    reveal hotkey window w
                    return
                end if
            end if
        end repeat
        create hotkey window with profile wanted
    end tell
end run
