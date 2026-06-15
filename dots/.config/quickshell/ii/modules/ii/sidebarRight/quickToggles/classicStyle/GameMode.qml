import qs.modules.common
import qs.modules.common.widgets
import qs.services
import Quickshell
import Quickshell.Io

QuickToggleButton {
    id: root
    buttonIcon: "gamepad"
    toggled: false

    function runGameModeCommand(enableGameMode) {
        const command = enableGameMode ? `hyprctl eval 'hl.config({
    animations = {
        enabled = false
    },
    decoration = {
        shadow = {
            enabled = false
        },
        blur = {
            enabled = false
        },
        rounding = 0
    },
    general = {
        gaps_in = 0,
        gaps_out = 0,
        border_size = 1,
        allow_tearing = true
    }
})'` : `hyprctl reload`

        Quickshell.execDetached(["bash", "-lc", command])
    }

    onClicked: {
        const enableGameMode = !root.toggled
        root.toggled = enableGameMode
        root.runGameModeCommand(enableGameMode)
    }

    Process {
        id: fetchActiveState
        running: true
        command: ["bash", "-c", `test "$(hyprctl -j getoption animations:enabled | jq -r ".bool")" = "false"`]
        onExited: (exitCode, exitStatus) => {
            root.toggled = exitCode === 0
        }
    }

    StyledToolTip {
        text: Translation.tr("Game mode")
    }
}
