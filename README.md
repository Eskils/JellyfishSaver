# Jellyfish Saver

A macOS screensaver written using SwiftUI Shaders. Draws some curves animated along a `sinc` function, which makes the curves vary between moving fast and slow—like jellyfish.

You may specify how many “jellyfish”, the number of curves making up one jellyfish, and the distance between the curves.

## Installation

- Download the latest release
- Open the saver-file
- Install and preview.
- If the screensaver is black the first time, you may need to approve it under *Privacy & Security*

## Debugging on macOS Sonoma

MacOS Sonoma has a new agent—namely `WallpaperAgent`—that deals with starting the screensaver. This agent suspends the screensaver in memory and so does not always read from disk when a new build is installed.

- Install by opening .saver file
- Restart System Settings for preview to update
- Restart WallpaperAgent for actual saver to update
    - `killall kill WallpaperAgent`