# Asteroid-City-Scope-Restorer
*Created by [@teymourb](https://github.com/teymourb)*

![AsteroidCity_Poster](https://github.com/teymourb/Asteroid-City-Scope-Restorer/assets/53331006/d2d7140f-319d-4def-b77c-3b5af20edd23)


<p align="center">
    <a href="https://github.com/teymourb/Asteroid-City-Scope-Restorer/releases" target="_blank" rel="noopener"><img src="https://img.shields.io/github/release/teymourb/Asteroid-City-Scope-Restorer.svg" alt="Latest releases" /></a>
</p>

***Asteroid-City-Scope-Restorer*** is an experimental program from the fanedit community which allows you to restore your preferred Scope theatrical version of the Blu-Ray of *Asteroid City*.

Choose between 2 **constant-height** Scope Restorations:
<!-- toc -->

- [1. Theatrical Scope (unmasked) - Blu-ray compliant](#1-theatrical-scope-version-unmasked)
- [2. Theatrical Scope (masked)](#2-theatrical-scope-version-masked)

<!-- tocstop -->

#### REQUIREMENTS:  
- An unaltered .mkv rip of the Blu-ray disc *Asteroid City*
- Published version: 50 GB of free space, excluding the source. The unreleased maintenance version retains intermediate videos and requires substantially more; peak use has not yet been measured.

> [!WARNING]
> No other version will work with this program! You are free to keep whichever audio and subtitle tracks you wish when ripping your disc. Only the video track needs to be the same.

<br>

#### INSTRUCTIONS:  
- Download the versioned application archive from Releases. GitHub Source code archives do not include the processing executables.
- Extract the complete application folder to a drive with room for the prepared video, raw and encoded segments, assembled video and final output. The unreleased maintenance version retains all of these; the historical free-space figure above is not its storage requirement.
- Launch *Asteroid-City-Scope-Restorer.bat* from the extracted application folder
- Choose the source and an existing output folder using the numbered setup prompts. File/folder dialogs offer a manual-path fallback if cancelled or unavailable.
- Choose restoration 1 or 2, review the source, destination, mode and storage summary, then explicitly confirm before processing. Type Q to leave setup without creating temporary work.
- Keep the PC awake during processing. Stage names appear in the console; detailed tool progress is recorded in the logs. A quiet console does not necessarily mean processing has stopped.
- The unreleased launcher requires Windows PowerShell 5.1 with its standard Windows Forms support. Paths containing unsupported CMD characters (including !, % and ^) are refused with guidance instead of risking incorrect processing. Use a simple folder name for this version.
- In the unreleased version 1.0.2, source preparation, splitting and encoding stop on reported errors or missing/empty outputs. Progress and diagnostics are in `docs/temp/processing.log`; final-remux diagnostics are in `docs/temp/final-remux.log`. All intermediate videos and logs remain for review, even when an output is created, because Avidemux does not reliably report append/save failures. A final output must be checked for completeness. This uses substantially more disk space. After review, move or manually remove `docs/temp` before another run; startup preserves any existing workspace. A destination file left after an error may be incomplete. An independent decoded-frame check verifies assembly order, format and geometry before final remux; it does not establish intended edits, timing, HDR metadata or audio synchronization. Automatic resume is not implemented.

<br>

## Original version:

On the Blu-ray disc of Asteroid City, the different types of scenes are encoded as follows:
- The video file container is 1920 x 1080 (1.78:1 / 16:9).
- The Black and White sequences have an active image of 1480 x 1080 (1.37:1) pillarboxed (*black bars right and left*) within a 1920 x 1080 (1.78:1) container.
- The Scope sequences have an active image of 1920 x 804 (2.39:1) letterboxed (*black bars top and bottom*) within a 1920 x 1080 (1.78:1) container.

![AsteroidCity_Blu-ray](https://github.com/teymourb/Asteroid-City-Scope-Restorer/assets/53331006/4ba68733-b122-4261-81ec-fb0b08f0b251)


---

# 1. Theatrical Scope version (unmasked)
> Blu-ray compliant
  - Black and White sequences downscaled to **1102 x 804** (**2.39:1**) active picture, 1430 x 804 (1.78:1) container, then
  - Black and White sequences container **windowboxed** (pillarboxed + letterboxed) to 1920 x 1080 (1.78:1)
  - Scope sequences left unaltered at active picture of **1920 x 804** (**2.39:1**), **pillarboxed** within a 1920 x 1080 (1.78:1) container
  - Picture Variable width: 1102 (Black and White 1.37:1 sequences), 1920 (Scope 2.39:1 sequences), Constant height: 804
  - Active image: 1920 x 804 (2.39:1)
  - **Container**: 1920 x 1080 (1.78:1)

<br>

**Best suited for:**
  - Burning to Blu-ray disc
  - Projectors with ~2.39:1 wall/screen (or with decent masking options)
  - ~2.39:1 displays
  - VR (if viewing app has a cropping tool or if letterboxing won't be noticeable/distracting)

> For native Scope displays, you should crop 138 px top and 138 px bottom of the image in your media player's settings (VLC, MPC...)

<br>

![AsteroidCity_Scope(unmasked)](https://github.com/teymourb/Asteroid-City-Scope-Restorer/assets/53331006/4e4f65af-85f6-47ba-9376-ea7a1e053c2b)

<br>
<br>
<br>

---

# 2. Theatrical Scope version (masked)
  - Black and White sequences downscaled to **1102 x 804** (**2.39:1**) active picture, 1430 x 804 (1.78:1) container, then
  - Black and White sequences container **pillarboxed** to 1920 x 804 (2.39:1)
  - Scope sequences **cropped** to 1920 x 1080 (2.39:1)
  - Picture Variable width: 1102 (Black and White 1.37:1 sequences), 1920 (Scope 2.39:1 sequences), Constant height: 804
  - Active image: 1920 x 804 (2.39:1)
  - **Container**: 1920 x 804 (1.78:1)

<br>

**Best suited for:**
  - Projectors with ~2.39:1 wall/screen (or with decent masking options)
  - ~2.39:1 displays
  - VR

<br>

![AsteroidCity_Scope(masked)](https://github.com/teymourb/Asteroid-City-Scope-Restorer/assets/53331006/d9e14010-d28d-4c89-b79f-5df0ed05434a)

---

### See also:

[Reddit | r/fanedits Program thread](https://www.reddit.com/r/fanedits/comments/199y61n/fanedit_program_asteroid_city_theatrical_scope/)  
[fanedit.org | Forums Restoration thread](https://forums.fanedit.org/threads/asteroid-city-scope-2-39-1-theatrical-restoration-1080p-program.30268/)  
[Reddit | r/Bluray Proportions between aspect ratios was changed](https://www.reddit.com/r/Bluray/comments/195op7k/asteroid_city_bluray_the_proportions_between/)  

## Independent assembly check (unreleased)

Before final remux, Windows PowerShell runs the bundled FFmpeg to decode the
assembled video and each input segment. Ordered SHA256 frame hashes, native
pixel formats and dimensions must match. This catches missing, repeated or
reordered decoded frames; missing tools, corrupt inputs and mismatches stop the
job and retain evidence under `docs/temp/assembly-validation-*`.

This extra full decoding pass adds substantial processing time, without changing
the restoration's media settings. It does not verify intended cuts, timestamps,
audio synchronization or HDR metadata. All intermediate files remain for now.
Keep the `docs/scripts` folder with the launcher; copying the BAT alone is no
longer sufficient. No additional user-installed runtime is needed beyond stock
Windows PowerShell and the existing bundled tools.
