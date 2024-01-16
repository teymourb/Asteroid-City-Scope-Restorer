@ECHO OFF

cd "docs"
if exist temp (
	::Deleting temp files from previous failed session
    cd "temp"
	del *.* /F /Q
	cd ..
	cd ..
) else (
	::Creating temp folder
	mkdir temp
    cd ..
)

::Making sure batch file drive location has enough space
echo Please make sure you have extracted the 7z zip file to a drive with 60GB of free space.
echo If this is correct press Enter
echo If not, please close this program and extract the 7z zip file to an appropriate location.
pause

echo Please select your Blu-ray Asteroid City rip .mkv file
echo DISCLAIMER: This will not work with any other version of the movie. Only an unaltered file (video track) ripped from this specific disc will work with the program.
::File selection
Title Asteroid City Theatrical Scope Restorer
(
    echo Function GetFileDlgEx(sIniDir,sFilter,sTitle^) 
    echo Set oDlg = CreateObject("WScript.Shell"^).Exec("mshta.exe ""about:<object id=d classid=clsid:3050f4e1-98b5-11cf-bb82-00aa00bdce0b></object><script>moveTo(0,-9999);eval(new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(0).Read("^&Len(sIniDir^)^+Len(sFilter^)^+Len(sTitle^)+41^&"));function window.onload(){var p=/[^\0]*/;new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(1).Write(p.exec(d.object.openfiledlg(iniDir,null,filter,title)));close();}</script><hta:application showintaskbar=no />"""^) 
    echo oDlg.StdIn.Write "var iniDir='" ^& sIniDir ^& "';var filter='" ^& sFilter ^& "';var title='" ^& sTitle ^& "';"
    echo GetFileDlgEx = oDlg.StdOut.ReadAll 
    echo End Function
    echo sIniDir = "C:\Movie_Rip.mkv.mkv"
    echo sFilter = "MKV files (*.mkv)|*.mkv|"
    echo sTitle = "Selecting source rip .mkv file" 
    echo MyFile = GetFileDlgEx(Replace(sIniDir,"\","\\"^),sFilter,sTitle^) 
    echo wscript.echo MyFile
)>"%tmp%\%~n0.vbs"
for /f "tokens=* delims=" %%p in ('Cscript /NoLogo "%tmp%\%~n0.vbs"') do set "file=%%p"
echo %file%
pause


::Destination folder selection
setlocal

set "psCommand="(new-object -COM 'Shell.Application')^
.BrowseForFolder(0,'Please choose a destination folder for the Theatrical Scope Restoration:',0,0).self.path""

for /f "usebackq delims=" %%I in (`powershell %psCommand%`) do set "folder=%%I"

setlocal enabledelayedexpansion
echo You chose !folder!

::Define loop point for incorrect input
:a


echo Enter the number for the constant-width IMAX version you would like:
echo 1^) Scope Theatrical 1.78:1 ^(Black and White scenes windowboxed - unmasked 16:9 container^)
echo 2^) Scope Theatrical 2.39:1 ^(Black and White scenes pillarboxed - masked 2.39:1 container^)

::Get input from user
set /p version=Input: 

::Check what version to use and make sure the user selected the right one
if %version%==1 (
	echo You have selected: Scope Theatrical ^(1.78:1, unmasked^)
	echo If this is correct press Enter
	echo If this was the wrong choice please restart this program
	PAUSE

	docs\programs\mkvtoolnix\mkvmerge -o "docs\temp\AsteroidCity.mkv" -A --no-audio -S --no-subtitles -B --no-buttons --no-chapters -M --no-attachments --no-global-tags "%file%"

	::Extracting 7 unaltered (Scope) files
	echo Splitting AsteroidCity_1s.mkv
	docs\programs\ffmpeg\ffmpeg -threads 0 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 898 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_1s.mkv"

	echo Splitting AsteroidCity_3s.mkv
	docs\programs\ffmpeg\ffmpeg -threads 0 -ss 00:03:54.609 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 20792 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_3s.mkv"

	echo Splitting AsteroidCity_5s.mkv
	docs\programs\ffmpeg\ffmpeg -threads 0 -ss 00:23:26.780 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 14780 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_5s.mkv"

	echo Splitting AsteroidCity_7s.mkv
	docs\programs\ffmpeg\ffmpeg -threads 0 -ss 00:37:01.010 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 21248 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_7s.mkv"

	echo Splitting AsteroidCity_9s.mkv
	docs\programs\ffmpeg\ffmpeg -threads 0 -ss 00:54:40.694 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 25396 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_9s.mkv"

	echo Splitting AsteroidCity_11s.mkv
	docs\programs\ffmpeg\ffmpeg -threads 0 -ss 01:15:26.230 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 18249 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_11s.mkv"

	echo Splitting AsteroidCity_13s.mkv
	docs\programs\ffmpeg\ffmpeg -threads 0 -ss 01:33:46.746 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_13s.mkv"



	::Extracting, encoding(windowboxing) and deleting(original) for the 6 other files (Black and White)
	echo Splitting AsteroidCity_2a.mkv
	docs\programs\ffmpeg\ffmpeg -threads 0 -ss 00:00:38.580 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 4700 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_2a.mkv"

	echo Windowboxing AsteroidCity_2a.mkv
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_2a.mkv" -o "docs\temp\AsteroidCity_2a_Windowboxed.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 -w 1430 -l 804 --crop-mode "none" --inline-parameter-sets --non-anamorphic --pad "width=1920:height=1080"

	echo Deleting AsteroidCity_2a.mkv
	del "docs\temp\AsteroidCity_2a.mkv"

	echo Splitting AsteroidCity_4a.mkv
	docs\programs\ffmpeg\ffmpeg -threads 0 -ss 00:18:21.809 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 7312 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_4a.mkv"

	echo Windowboxing AsteroidCity_4a.mkv
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_4a.mkv" -o "docs\temp\AsteroidCity_4a_Windowboxed.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 -w 1430 -l 804 --crop-mode "none" --inline-parameter-sets --non-anamorphic --pad "width=1920:height=1080"

	echo Deleting AsteroidCity_4a.mkv
	del "docs\temp\AsteroidCity_4a.mkv"

	echo Splitting AsteroidCity_6a.mkv
	docs\programs\ffmpeg\ffmpeg -threads 0 -ss 00:33:43.229 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 4742 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_6a.mkv"

	echo Windowboxing AsteroidCity_6a.mkv
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_6a.mkv" -o "docs\temp\AsteroidCity_6a_Windowboxed.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 -w 1430 -l 804 --crop-mode "none" --inline-parameter-sets --non-anamorphic --pad "width=1920:height=1080"

	echo Deleting AsteroidCity_6a.mkv
	del "docs\temp\AsteroidCity_6a.mkv"

	echo Splitting AsteroidCity_8a.mkv
	docs\programs\ffmpeg\ffmpeg -threads 0 -ss 00:51:47.229 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 4159 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_8a.mkv"

	echo Windowboxing AsteroidCity_8a.mkv
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_8a.mkv" -o "docs\temp\AsteroidCity_8a_Windowboxed.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 -w 1430 -l 804 --crop-mode "none" --inline-parameter-sets --non-anamorphic --pad "width=1920:height=1080"

	echo Deleting AsteroidCity_8a.mkv
	del "docs\temp\AsteroidCity_8a.mkv"

	echo Splitting AsteroidCity_10a.mkv
	docs\programs\ffmpeg\ffmpeg -threads 0 -ss 01:12:19.918 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 4467 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_10a.mkv"

	echo Windowboxing AsteroidCity_10a.mkv
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_10a.mkv" -o "docs\temp\AsteroidCity_10a_Windowboxed.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 -w 1430 -l 804 --crop-mode "none" --inline-parameter-sets --non-anamorphic --pad "width=1920:height=1080"

	echo Deleting AsteroidCity_10a.mkv
	del "docs\temp\AsteroidCity_10a.mkv"

	echo Splitting AsteroidCity_12a.mkv
	docs\programs\ffmpeg\ffmpeg -threads 0 -ss 01:28:07.365 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 8137 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -map_metadata -1 -y "docs\temp\AsteroidCity_12a.mkv"

	echo Windowboxing AsteroidCity_12a.mkv
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_12a.mkv" -o "docs\temp\AsteroidCity_12a_Windowboxed.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 -w 1430 -l 804 --crop-mode "none" --inline-parameter-sets --non-anamorphic --pad "width=1920:height=1080"

	echo Deleting AsteroidCity_12a.mkv
	del "docs\temp\AsteroidCity_12a.mkv"



	::Deleting audioless source
	echo Deleting AsteroidCity.mkv
	del "docs\temp\AsteroidCity.mkv"



	::Concatenating all 13 files
	echo Exporting...
	docs\programs\avidemux\avidemux_cli --load "docs\temp\AsteroidCity_1s.mkv" --append "docs\temp\AsteroidCity_2a_Windowboxed.mkv" --append "docs\temp\AsteroidCity_3s.mkv" --append "docs\temp\AsteroidCity_4a_Windowboxed.mkv" --append "docs\temp\AsteroidCity_5s.mkv" --append "docs\temp\AsteroidCity_6a_Windowboxed.mkv" --append "docs\temp\AsteroidCity_7s.mkv" --append "docs\temp\AsteroidCity_8a_Windowboxed.mkv" --append "docs\temp\AsteroidCity_9s.mkv" --append "docs\temp\AsteroidCity_10a_Windowboxed.mkv" --append "docs\temp\AsteroidCity_11s.mkv" --append "docs\temp\AsteroidCity_12a_Windowboxed.mkv" --append "docs\temp\AsteroidCity_13s.mkv" --video-codec copy --audio-codec copy --output-format mkv --save "docs\temp\AsteroidCity_S.mkv"



	::Deleting 13 split files
	echo Deleting Leftover Files
	del "docs\temp\AsteroidCity_1s.mkv"
	del "docs\temp\AsteroidCity_2a_Windowboxed.mkv"
	del "docs\temp\AsteroidCity_3s.mkv"
	del "docs\temp\AsteroidCity_4a_Windowboxed.mkv"
	del "docs\temp\AsteroidCity_5s.mkv"
	del "docs\temp\AsteroidCity_6a_Windowboxed.mkv"
	del "docs\temp\AsteroidCity_7s.mkv"
	del "docs\temp\AsteroidCity_8a_Windowboxed.mkv"
	del "docs\temp\AsteroidCity_9s.mkv"
	del "docs\temp\AsteroidCity_10a_Windowboxed.mkv"
	del "docs\temp\AsteroidCity_11s.mkv"
	del "docs\temp\AsteroidCity_12a_Windowboxed.mkv"
	del "docs\temp\AsteroidCity_13s.mkv"



	::Merging altered video with source rip, keeping only video track of the first and all but video track of the latter for the output file
	echo Remuxing audio and subtitles
	docs\programs\mkvtoolnix\mkvmerge -o "!folder!\Asteroid City Theatrical Scope Restoration (unmasked).mkv" -A --no-audio -S --no-subtitles -B --no-buttons --no-chapters -M --no-attachments --no-global-tags "docs\temp\AsteroidCity_S.mkv" -D --no-video "%file%"
	
	endlocal

	::Deleting altered video with incorrect non-video tracks
	echo Deleting AsteroidCity_S.mkv
	del "docs\temp\AsteroidCity_S.mkv"
) else if %version%==2 (
	echo You have selected: Scope Theatrical ^(2.39:1, masked^)
	echo If this is correct press Enter
	echo If this was the wrong choice please restart this program
	PAUSE

	docs\programs\mkvtoolnix\mkvmerge -o "docs\temp\AsteroidCity.mkv" -A --no-audio -S --no-subtitles -B --no-buttons --no-chapters -M --no-attachments --no-global-tags "%file%"

	::Extracting 13 unaltered (scope) files
	echo Splitting AsteroidCity_1s.mkv
	docs\programs\ffmpeg\ffmpeg -threads 0 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 898 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_1s.mkv"

	echo Splitting AsteroidCity_2a.mkv
	docs\programs\ffmpeg\ffmpeg -threads 0 -ss 00:00:38.580 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 4700 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_2a.mkv"

	echo Splitting AsteroidCity_3s.mkv
	docs\programs\ffmpeg\ffmpeg -threads 0 -ss 00:03:54.609 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 20792 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_3s.mkv"

	echo Splitting AsteroidCity_4a.mkv
	docs\programs\ffmpeg\ffmpeg -threads 0 -ss 00:18:21.809 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 7312 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_4a.mkv"

	echo Splitting AsteroidCity_5s.mkv
	docs\programs\ffmpeg\ffmpeg -threads 0 -ss 00:23:26.780 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 14780 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_5s.mkv"

	echo Splitting AsteroidCity_6a.mkv
	docs\programs\ffmpeg\ffmpeg -threads 0 -ss 00:33:43.229 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 4742 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_6a.mkv"

	echo Splitting AsteroidCity_7s.mkv
	docs\programs\ffmpeg\ffmpeg -threads 0 -ss 00:37:01.010 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 21248 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_7s.mkv"

	echo Splitting AsteroidCity_8a.mkv
	docs\programs\ffmpeg\ffmpeg -threads 0 -ss 00:51:47.229 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 4159 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_8a.mkv"

	echo Splitting AsteroidCity_9s.mkv
	docs\programs\ffmpeg\ffmpeg -threads 0 -ss 00:54:40.694 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 25396 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_9s.mkv"

	echo Splitting AsteroidCity_10a.mkv
	docs\programs\ffmpeg\ffmpeg -threads 0 -ss 01:12:19.918 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 4467 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_10a.mkv"

	echo Splitting AsteroidCity_11s.mkv
	docs\programs\ffmpeg\ffmpeg -threads 0 -ss 01:15:26.230 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 18249 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_11s.mkv"

	echo Splitting AsteroidCity_12a.mkv
	docs\programs\ffmpeg\ffmpeg -threads 0 -ss 01:28:07.365 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 8137 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -map_metadata -1 -y "docs\temp\AsteroidCity_12a.mkv"

	echo Splitting AsteroidCity_13s.mkv
	docs\programs\ffmpeg\ffmpeg -threads 0 -ss 01:33:46.746 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_13s.mkv"
	
	::Encoding(Cropping black bars) and deleting (original) for 7 files (Scope)
	echo Windowboxing AsteroidCity_1s.mkv
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_1s.mkv" -o "docs\temp\AsteroidCity_1s_Cropped.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 --crop 138:138:0:0 --inline-parameter-sets --non-anamorphic
	
	echo Deleting AsteroidCity_1s.mkv
	del "docs\temp\AsteroidCity_1s.mkv"
	
	echo Windowboxing AsteroidCity_3s.mkv
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_3s.mkv" -o "docs\temp\AsteroidCity_3s_Cropped.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 --crop 138:138:0:0 --inline-parameter-sets --non-anamorphic

	echo Deleting AsteroidCity_3s.mkv
	del "docs\temp\AsteroidCity_3s.mkv"
	
	echo Windowboxing AsteroidCity_5s.mkv
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_5s.mkv" -o "docs\temp\AsteroidCity_5s_Cropped.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 --crop 138:138:0:0 --inline-parameter-sets --non-anamorphic
	
	echo Deleting AsteroidCity_5s.mkv
	del "docs\temp\AsteroidCity_5s.mkv"
	
	echo Windowboxing AsteroidCity_7s.mkv
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_7s.mkv" -o "docs\temp\AsteroidCity_7s_Cropped.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 --crop 138:138:0:0 --inline-parameter-sets --non-anamorphic
	
	echo Deleting AsteroidCity_7s.mkv
	del "docs\temp\AsteroidCity_7s.mkv"
	
	echo Windowboxing AsteroidCity_9s.mkv
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_9s.mkv" -o "docs\temp\AsteroidCity_9s_Cropped.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 --crop 138:138:0:0 --inline-parameter-sets --non-anamorphic
	
	echo Deleting AsteroidCity_9s.mkv
	del "docs\temp\AsteroidCity_9s.mkv"
	
	echo Windowboxing AsteroidCity_11s.mkv
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_11s.mkv" -o "docs\temp\AsteroidCity_11s_Cropped.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 --crop 138:138:0:0 --inline-parameter-sets --non-anamorphic
	
	echo Deleting AsteroidCity_11s.mkv
	del "docs\temp\AsteroidCity_11s.mkv"
	
	echo Windowboxing AsteroidCity_13s.mkv
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_13s.mkv" -o "docs\temp\AsteroidCity_13s_Cropped.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 --crop 138:138:0:0 --inline-parameter-sets --non-anamorphic
	
	echo Deleting AsteroidCity_13s.mkv
	del "docs\temp\AsteroidCity_13s.mkv"
	
	::Encoding(Pillarboxing) and deleting(original) for 6 files (Black and White)
	echo Windowboxing AsteroidCity_2a.mkv
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_2a.mkv" -o "docs\temp\AsteroidCity_2a_Pillarboxed.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 -w 1430 -l 804 --crop-mode "none" --inline-parameter-sets --non-anamorphic --pad "width=1920:height=804"
	
	echo Deleting AsteroidCity_2a.mkv
	del "docs\temp\AsteroidCity_2a.mkv"
	
	echo Windowboxing AsteroidCity_4a.mkv
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_4a.mkv" -o "docs\temp\AsteroidCity_4a_Pillarboxed.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 -w 1430 -l 804 --crop-mode "none" --inline-parameter-sets --non-anamorphic --pad "width=1920:height=804"
	
	echo Deleting AsteroidCity_4a.mkv
	del "docs\temp\AsteroidCity_4a.mkv"
	
	echo Windowboxing AsteroidCity_6a.mkv
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_6a.mkv" -o "docs\temp\AsteroidCity_6a_Pillarboxed.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 -w 1430 -l 804 --crop-mode "none" --inline-parameter-sets --non-anamorphic --pad "width=1920:height=804"
	
	echo Deleting AsteroidCity_6a.mkv
	del "docs\temp\AsteroidCity_6a.mkv"
	
	echo Windowboxing AsteroidCity_8a.mkv
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_8a.mkv" -o "docs\temp\AsteroidCity_8a_Pillarboxed.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 -w 1430 -l 804 --crop-mode "none" --inline-parameter-sets --non-anamorphic --pad "width=1920:height=804"
	
	echo Deleting AsteroidCity_8a.mkv
	del "docs\temp\AsteroidCity_8a.mkv"
	
	echo Windowboxing AsteroidCity_10a.mkv
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_10a.mkv" -o "docs\temp\AsteroidCity_10a_Pillarboxed.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 -w 1430 -l 804 --crop-mode "none" --inline-parameter-sets --non-anamorphic --pad "width=1920:height=804"
	
	echo Deleting AsteroidCity_10a.mkv
	del "docs\temp\AsteroidCity_10a.mkv"
	
	echo Windowboxing AsteroidCity_12a.mkv
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_12a.mkv" -o "docs\temp\AsteroidCity_12a_Pillarboxed.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 -w 1430 -l 804 --crop-mode "none" --inline-parameter-sets --non-anamorphic --pad "width=1920:height=804"
	
	echo Deleting AsteroidCity_12a.mkv
	del "docs\temp\AsteroidCity_12a.mkv"
	
	::Deleting audioless source
	echo Deleting AsteroidCity.mkv
	del "docs\temp\AsteroidCity.mkv"
	
	::Concatenating all 13 files
	echo Exporting...
	docs\programs\avidemux\avidemux_cli --load "docs\temp\AsteroidCity_1s_Cropped.mkv" --append "docs\temp\AsteroidCity_2a_Pillarboxed.mkv" --append "docs\temp\AsteroidCity_3s_Cropped.mkv" --append "docs\temp\AsteroidCity_4a_Pillarboxed.mkv" --append "docs\temp\AsteroidCity_5s_Cropped.mkv" --append "docs\temp\AsteroidCity_6a_Pillarboxed.mkv" --append "docs\temp\AsteroidCity_7s_Cropped.mkv" --append "docs\temp\AsteroidCity_8a_Pillarboxed.mkv" --append "docs\temp\AsteroidCity_9s_Cropped.mkv" --append "docs\temp\AsteroidCity_10a_Pillarboxed.mkv" --append "docs\temp\AsteroidCity_11s_Cropped.mkv" --append "docs\temp\AsteroidCity_12a_Pillarboxed.mkv" --append "docs\temp\AsteroidCity_13s_Cropped.mkv" --video-codec copy --audio-codec copy --output-format mkv --save "docs\temp\AsteroidCity_S.mkv"
	
	
	::Deleting 13 split files
	echo Deleting Leftover Files
	del "docs\temp\AsteroidCity_1s_Cropped.mkv"
	del "docs\temp\AsteroidCity_2a_Pillarboxed.mkv"
	del "docs\temp\AsteroidCity_3s_Cropped.mkv"
	del "docs\temp\AsteroidCity_4a_Pillarboxed.mkv"
	del "docs\temp\AsteroidCity_5s_Cropped.mkv"
	del "docs\temp\AsteroidCity_6a_Pillarboxed.mkv"
	del "docs\temp\AsteroidCity_7s_Cropped.mkv"
	del "docs\temp\AsteroidCity_8a_Pillarboxed.mkv"
	del "docs\temp\AsteroidCity_9s_Cropped.mkv"
	del "docs\temp\AsteroidCity_10a_Pillarboxed.mkv"
	del "docs\temp\AsteroidCity_11s_Cropped.mkv"
	del "docs\temp\AsteroidCity_12a_Pillarboxed.mkv"
	del "docs\temp\AsteroidCity_13s_Cropped.mkv"
	
	::Merging altered video with source rip, keeping only video track of the first and all but video track of the latter for the output file
	echo Remuxing audio and subtitles
	docs\programs\mkvtoolnix\mkvmerge -o "!folder!\Asteroid City Theatrical Scope Restoration (masked).mkv" -A --no-audio -S --no-subtitles -B --no-buttons --no-chapters -M --no-attachments --no-global-tags "docs\temp\AsteroidCity_S.mkv" -D --no-video "%file%"
	
	endlocal
	
	::Deleting altered video with incorrect non-video tracks
	echo Deleting AsteroidCity_S.mkv
	del "docs\temp\AsteroidCity_S.mkv"
) else (
	::Loop if input is not valid
	echo %version% is not a valid input
	goto a
)

::Deleting all files in temp
echo Deleting any temp files before closing the session
cd "docs\temp\"
del *.* /F /Q

::Deleting temp folder
cd ..
rmdir /s /q temp
cd ..

echo Done!
PAUSE