# Asteroid-City-Scope-Restorer
*Created by [@teymourb](https://github.com/teymourb)*

![AsteroidCity_Poster](https://github.com/teymourb/Asteroid-City-Scope-Restorer/assets/53331006/d2d7140f-319d-4def-b77c-3b5af20edd23)


<p align="center">
    <a href="https://github.com/teymourb/Asteroid-City-Scope-Restorer/releases" target="_blank" rel="noopener"><img src="https://img.shields.io/github/release/teymourb/Asteroid-City-Scope-Restorer.svg" alt="Latest releases" /></a>
</p>

***Asteroid-City-Scope-Restorer*** is an experimental program from the fanedit community which allows you to restore your preferred Scope theatrical version of the Blu-Ray of *Asteroid City*.

Choose between two **constant-height** Scope restorations:

- [Theatrical Scope (unmasked)](#1-theatrical-scope-version-unmasked): Black and White sequences are windowboxed inside a 16:9 container; Blu-ray compliant.
- [Theatrical Scope (masked)](#2-theatrical-scope-version-masked): Black and White sequences are pillarboxed inside a 2.39:1 container.

## Requirements

- Windows with Windows PowerShell 5.1 and its standard file/folder dialogs.
- An unaltered `.mkv` rip of the *Asteroid City* Blu-ray disc.
- Enough free space for a temporary extracted video track, the restoration's working videos and the final MKV. Several film-sized files may coexist during processing; the displayed free space is not a guarantee that the run will fit.

> [!WARNING]
> No other version of the movie will work. Only the video track must match the supported disc; you may keep whichever audio and subtitle tracks you wish in your rip.

The program checks the video track before restoration and stops if it does not
match. This check reads and temporarily extracts the video without re-encoding
it. Your original MKV is unchanged.

## Download and run

1. Download the **complete application ZIP** from [Releases](https://github.com/teymourb/Asteroid-City-Scope-Restorer/releases). GitHub's automatically generated **Source code** archives do not include the processing tools.
2. Extract the entire ZIP to its own folder on a drive with sufficient free space. Do not run the program from inside the ZIP. Keep your source MKV outside the application folder.
3. Double-click **`Asteroid-City-Scope-Restorer.bat`**.
4. Read the source requirements, then press Enter to open the source-file dialog. Choose your MKV.
5. Press Enter to open the destination-folder dialog. Choose an existing folder for the restored MKV.
6. Choose restoration **1** or **2**, review the paths, restoration and storage information, then enter **Y** to begin. Enter **N** or **Q** to cancel.
7. Keep the program window open and your PC awake. Encoding can take several hours. Progress messages identify the current stage; a quiet window does not necessarily mean processing has stopped.

If a file/folder dialog is cancelled or unavailable, you can enter the full path
manually or quit. Paths with spaces and Unicode characters are supported. Paths
containing `!`, `%`, `^`, embedded quotes or control characters are refused with
guidance; use a simpler name for that file or folder.

The final MKV is saved in your selected output folder. Your original source is
not modified, and existing destination files are not overwritten.

## Temporary files and troubleshooting

The application uses `docs/temp` for generated working videos. These are removed
automatically after successful completion and when you confirm a fresh run.
Do not store source movies or personal files in `docs/temp`.

If processing stops, close the program before changing temporary files. You may
then delete `docs/temp` to reclaim space, or keep it while troubleshooting. A new
run starts from the beginning; **automatic resume is not available**. Never
delete or move temporary files while the program is running.

Small diagnostic records are kept separately in `docs/logs`. If you need help,
share the relevant logs and the message shown in the program window; do not
upload your film. A destination file left after an error may be incomplete.

## Source presentation

On the Blu-ray disc of Asteroid City, the different types of scenes are encoded as follows:
- The video file container is 1920 x 1080 (1.78:1 / 16:9).
- The Black and White sequences have an active image of 1480 x 1080 (1.37:1) pillarboxed (*black bars right and left*) within a 1920 x 1080 (1.78:1) container.
- The Scope sequences have an active image of 1920 x 804 (2.39:1) letterboxed (*black bars top and bottom*) within a 1920 x 1080 (1.78:1) container.

![AsteroidCity_Blu-ray](https://github.com/teymourb/Asteroid-City-Scope-Restorer/assets/53331006/4ba68733-b122-4261-81ec-fb0b08f0b251)

---

## 1. Theatrical Scope version (unmasked)
> Blu-ray compliant
  - Black and White sequences downscaled to **1102 x 804** (**1.37:1**) active picture, 1430 x 804 (1.78:1) container, then
  - Black and White sequences container **windowboxed** (pillarboxed + letterboxed) to 1920 x 1080 (1.78:1)
  - Scope sequences left unaltered at active picture of **1920 x 804** (**2.39:1**), **letterboxed** within a 1920 x 1080 (1.78:1) container
  - Picture Variable width: 1102 (Black and White 1.37:1 sequences), 1920 (Scope 2.39:1 sequences), Constant height: 804
  - Active image: 1920 x 804 (2.39:1)
  - **Container**: 1920 x 1080 (1.78:1)

**Best suited for:**
  - Burning to Blu-ray disc
  - Projectors with ~2.39:1 wall/screen (or with decent masking options)
  - ~2.39:1 displays
  - VR (if viewing app has a cropping tool or if letterboxing won't be noticeable/distracting)

> For native Scope displays, you should crop 138 px top and 138 px bottom of the image in your media player's settings (VLC, MPC...)

![AsteroidCity_Scope(unmasked)](https://github.com/teymourb/Asteroid-City-Scope-Restorer/assets/53331006/4e4f65af-85f6-47ba-9376-ea7a1e053c2b)

<br>

---

## 2. Theatrical Scope version (masked)
  - Black and White sequences downscaled to **1102 x 804** (**1.37:1**) active picture, 1430 x 804 (1.78:1) container, then
  - Black and White sequences container **pillarboxed** to 1920 x 804 (2.39:1)
  - Scope sequences **cropped** to 1920 x 804 (2.39:1), removing the top and bottom black bars
  - Picture Variable width: 1102 (Black and White 1.37:1 sequences), 1920 (Scope 2.39:1 sequences), Constant height: 804
  - Active image: 1920 x 804 (2.39:1)
  - **Container**: 1920 x 804 (2.39:1)

**Best suited for:**
  - Projectors with ~2.39:1 wall/screen (or with decent masking options)
  - ~2.39:1 displays
  - VR

![AsteroidCity_Scope(masked)](https://github.com/teymourb/Asteroid-City-Scope-Restorer/assets/53331006/d9e14010-d28d-4c89-b79f-5df0ed05434a)

---

## Community and discussion

[Reddit | r/fanedits Program thread](https://www.reddit.com/r/fanedits/comments/199y61n/fanedit_program_asteroid_city_theatrical_scope/)  
[fanedit.org | Forums Restoration thread](https://forums.fanedit.org/threads/asteroid-city-scope-2-39-1-theatrical-restoration-1080p-program.30268/)  
[Reddit | r/Bluray Proportions between aspect ratios was changed](https://www.reddit.com/r/Bluray/comments/195op7k/asteroid_city_bluray_the_proportions_between/)
