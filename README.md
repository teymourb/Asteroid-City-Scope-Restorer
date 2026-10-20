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
- In the unreleased version 1.0.2, source preparation, splitting and encoding stop on reported errors or missing/empty outputs. Progress and diagnostics are in `docs/temp/processing.log`; final-remux diagnostics are in `docs/temp/final-remux.log`. All intermediate videos and logs remain for review, even when an output is created, because Avidemux does not reliably report append/save failures. A final output must be checked for completeness. This uses substantially more disk space. After review, move or manually remove `docs/temp` before another run; startup preserves any existing workspace. A destination file left after an error may be incomplete. An explicit routine/exhaustive choice controls decoded-frame comparison; routine records NOT RUN, exhaustive compares frames before final remux. Neither establishes intended edits, timing, HDR metadata or audio synchronization. Automatic resume is not implemented.

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

## Maintenance candidate 1.0.2 — not published

The film-processing recipe is preserved: the same cut points, crops/scaling,
HandBrake encoding settings, Avidemux section order and copy-mode assembly.
Processing tool versions are unchanged. This update improves setup, failure
handling and evidence; it does not fix legacy codec/join compatibility.

Run the BAT and select source, existing output folder, restoration mode and an
explicit check level before confirming:

- **Basic (routine):** tool exit statuses and required nonempty outputs are checked.
  The decoded-frame assembly comparison is **NOT RUN**. This cannot establish
  pristine joins, complete picture identity, timestamps, HDR or synchronization.
- **Exhaustive:** additionally decode the assembly and ordered sections and
  compare every decoded frame's fingerprint, pixel format and geometry. This
  can take many hours. It still does not qualify intended edits, timing, HDR,
  source identity or universal player compatibility. During decoding, progress
  messages appear and the console offers Q to stop while retaining evidence.

FFmpeg does not accept accidental keyboard commands during splitting. Avidemux
runs visibly in the console so its codec-compatibility questions can be answered
explicitly. A warning remains unresolved even if you choose to continue. Full
Avidemux diagnostics appear in the console; processing.log records its stage
marker, not a complete assembly transcript. Other processing diagnostics and
validation reports remain in docs/temp; final mux logs are in final-remux.log.

Tool failures or missing/empty outputs stop the job. The bundled Avidemux may
return success after an incomplete save, so routine checks alone cannot prove
assembly completeness. Check the selected level and assembly-check.txt; a NOT RUN
record is never a PASS. Final completion still requests review and retains work.

All intermediates remain, including after final output creation. Prepared video,
raw/encoded sections, assembly and output may coexist; free-space figures are
not a guarantee the job fits. There is no automatic resume or cleanup. A new run
refuses an existing docs/temp or output. Keep completed encodes/logs after errors.

Dialogs support cancel, manual path entry and quit. Spaces, Unicode, ampersands,
brackets and parentheses are supported. Legacy batch paths containing !, %, ^,
embedded quotes or control characters are rejected with guidance.
Published 1.0.1 downloads remain unchanged. No source fingerprint registry or
new encoding/join engine is introduced. Local source-only candidates require a
separate complete trusted historical installation; they contain no tools/media.
