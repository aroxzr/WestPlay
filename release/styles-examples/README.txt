WestPlay: your own looks (styles)
=================================

Put style files (.css) in Documents\WestPlay\styles\ (one folder up from this one):

  all.css               applies to every screen
  portrait.css          applies only to the Revuelto's portrait screen
  <screen-name>.css     applies only to that screen (WestPlay's own, or one from screens.txt)

Changes show on the in-game screen within about a second; no restart needed.
A broken line is simply ignored by the screen; delete or rename the file to go back to normal.

Files in this "examples" folder are NOT used; copy one up a folder to try it.

Useful things to change
-----------------------
  --edge             margin around everything (default 16px)
  --panel-radius     how round the panels' corners are
  --dock-height      height of the bottom dock on tall screens
  --sidebar-width    width of the side bar on wide screens
  .sidebar           the side bar / dock itself (background, padding...)
  .carplay           the whole interface (clip-path to cut it to a screen's shape)
  [data-screen="portrait"]   put this in front of a rule in all.css to aim it at one screen

Screen names you can use: generic, daf-2021, scania-2025, renault-t-2024, iveco-sway,
scania-2025-advanced, volvo-fh, tablet, travego-16, travego-16-23, setra-516, setra-531,
man-lions-coach, portrait, plus your own from screens.txt.
