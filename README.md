# Asteroid-City-Scope-Restorer
*Created by [@teymourb](https://github.com/teymourb)*

![AsteroidCity_Poster](https://github.com/teymourb/Asteroid-City-Scope-Restorer/assets/53331006/d2d7140f-319d-4def-b77c-3b5af20edd23)


<p align="center">
    <a href="https://github.com/teymourb/Asteroid-City-Scope-Restorer/releases" target="_blank" rel="noopener"><img src="https://img.shields.io/github/release/teymourb/Asteroid-City-Scope-Restorer.svg" alt="Latest releases" /></a>
</p>

***Asteroid-City-Scope-Restorer*** is an experimental program from the fanedit community which allows you to restore your the Scope theatrical version of the Blu-Ray of *Asteroid City* .


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

# Theatrical Scope version (unmasked)
  - Black and White sequences downscaled to **1102 x 804** (**2.39:1**) active picture, 1430 x 804 (1.78:1) container, then
  - Black and White sequences container **windowboxed** (pillarboxed + letterboxed) to 1920 x 1080 (1.78:1)
  - Scope sequences left unaltered at active picture of **1920 x 804** (**2.39:1**), **pillarboxed** within a 1920 x 1080 (1.78:1) container
  - Picture Variable width: 1102 (Black and White 1.37:1 sequences), 1920 (Scope 2.39:1 sequences), Constant height: 804
  - Active image: 1920 x 804 (2.39:1)
  - **Container**: 1920 x 1080 (1.78:1)

<br>

**Best suited for:**
  - Projectors with ~2.39:1 wall/screen (or with decent masking options)
  - ~2.39:1 displays
  - VR (if viewing app has a cropping tool or if letterboxing won't be noticeable/distracting)

> For native Scope displays, you should crop 138 px top and 138 px bottom of the image in your media player's settings (VLC, MPC...)

<br>

![AsteroidCity_Restoration](https://github.com/teymourb/Asteroid-City-Scope-Restorer/assets/53331006/4e4f65af-85f6-47ba-9376-ea7a1e053c2b)


