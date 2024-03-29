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
- 50 GB of free space (not including the source .mkv file)

> [!WARNING]
> No other version will work with this program! You are free to keep whichever audio and subtitle tracks you wish when ripping your disc. Only the video track needs to be the same.

<br>

#### INSTRUCTIONS:  
- Extract the zip file in a drive where you have at least 50 GB of free space
- Launch *Asteroid-City-Scope-Restorer.bat* and disregard the unknow publisher prompt  
- Select your source rip .mkv file when prompted  
- Select your destination folder for the output file  
- If prompted to accept or decline a command towards the end of the encoding, enter y for yes
- If the program is interrupted at any point or has failed, making sure to delete the *temp* folder in /docs/. This will be done automatically if the program is executed again.

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
