th.git = th.git or {}
th.git.modified = ui.Style():fg("yellow")
th.git.deleted = ui.Style():fg("red")
th.git.added = ui.Style():fg("green")
th.git.ignored = ui.Style():fg("white")
th.git.untracked = ui.Style():fg("blue")

require("git"):setup()

require("full-border"):setup {
    -- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
    type = ui.Border.ROUNDED,
}
