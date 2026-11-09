WestPlay 2.2.2 custom build (UNOFFICIAL)
========================================

This is a modified version of WestPlay (https://github.com/enes-less/WestPlay) by aroxzr.
It is NOT made or supported by WestPlay's author: please don't report its problems to them.
Source code: https://github.com/aroxzr/WestPlay (GPL-3.0, like WestPlay).

What's added
------------
- A "portrait" screen for tall in-car screens (material /material/ui/westplay/screen_portrait.mat).
- Your own screen shapes: Documents\WestPlay\screens.txt (instructions inside).
- Your own looks: style files in Documents\WestPlay\styles (examples and help in styles\examples).
- A fix for a crash with some mod vehicles' dashboards (WestPlay's cab marker in scripts that list
  their parts as "my_children[]").

Install
-------
1. Have the official WestPlay 2.2.2 installed and set up once (open it, let it set up your game).
2. Close the game, and close WestPlay (also from the tray by the clock: right-click, Quit).
3. Unzip this whole download into a folder, then double-click install.cmd.
   It backs up your original WestPlay first (to %LOCALAPPDATA%\WestPlay-original-backup).
4. Open WestPlay, then the game.

Go back to the original: close the game and WestPlay, then double-click restore.cmd.

Note: if WestPlay updates itself to a newer official version, these additions are gone until a
matching custom build exists; just run install.cmd from that newer build.
