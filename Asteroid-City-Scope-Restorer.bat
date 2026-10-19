@ECHO OFF

setlocal DisableDelayedExpansion
call :prepare_workspace
if errorlevel 1 exit /b 2

::Making sure batch file drive location has enough space
echo Please make sure you have extracted the 7z zip file to a drive with 50GB of free space.
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


::In case file path prompt wasn't successful
echo Did a dialog prompt you to select your file and if so, were you successful? [y/n]

set /p dialog=Input:

if %dialog%==n (
	echo Please enter the full path to your file.
	echo You may be able to drag and drop the file on the terminal for the same result:
	set /p "file=Enter file path: "
)
pause


::Destination folder selection
setlocal

set "psCommand="(new-object -COM 'Shell.Application')^
.BrowseForFolder(0,'Please choose a destination folder for the Theatrical Scope Restoration:',0,0).self.path""

for /f "usebackq delims=" %%I in (`powershell %psCommand%`) do set "folder=%%I"

setlocal enabledelayedexpansion
echo You chose !folder!


::In case file path prompt wasn't successful
echo Did a dialog prompt you to select your folder and if so, were you successful? [y/n]

set /p dialog2=Input:

if %dialog2%==n (
	echo Please enter the full path to your folder:
	echo You may be able to drag and drop the folder on the terminal for the same result:
	set /p "folder=Enter folder path: "
	set "folder=!folder:"=!"
	if not "!folder:~-1!"=="\" set "folder=!folder!\"
	echo !folder!
)
pause


::Define loop point for incorrect input
:a


echo Enter the number for the constant-height Scope version you would like:
echo 1^) Scope Theatrical 1.78:1 ^(Black and White scenes windowboxed - unmasked 16:9 container^)
echo 2^) Scope Theatrical 2.39:1 ^(Black and White scenes pillarboxed - masked 2.39:1 container^)

::Get input from user
set /p version=Input:

echo Processing progress and diagnostics will be written to docs\temp\processing.log.
echo Temporary video files will be kept for review; allow substantial free disk space.

::Check what version to use and make sure the user selected the right one
if %version%==1 (

	echo You have selected: Scope Theatrical ^(1.78:1, unmasked^)
	echo If this is correct press Enter
	echo If this was the wrong choice please restart this program
	PAUSE

	if %dialog%==y (
		set "stage_name=mkvmerge docs\temp\AsteroidCity.mkv"
		echo Stage: !stage_name!>> "docs\temp\processing.log"
		docs\programs\mkvtoolnix\mkvmerge -o "docs\temp\AsteroidCity.mkv" -A --no-audio -S --no-subtitles -B --no-buttons --no-chapters -M --no-attachments --no-global-tags "%file%" >> "docs\temp\processing.log" 2>&1
		if errorlevel 2 goto stage_failed
		if errorlevel 1 goto stage_warning
		if not errorlevel 0 goto stage_failed
		call :require_stage_output "docs\temp\AsteroidCity.mkv"
		if errorlevel 1 goto stage_failed
	) else if %dialog%==n (
		set "stage_name=mkvmerge docs\temp\AsteroidCity.mkv"
		echo Stage: !stage_name!>> "docs\temp\processing.log"
		docs\programs\mkvtoolnix\mkvmerge -o "docs\temp\AsteroidCity.mkv" -A --no-audio -S --no-subtitles -B --no-buttons --no-chapters -M --no-attachments --no-global-tags !file! >> "docs\temp\processing.log" 2>&1
		if errorlevel 2 goto stage_failed
		if errorlevel 1 goto stage_warning
		if not errorlevel 0 goto stage_failed
		call :require_stage_output "docs\temp\AsteroidCity.mkv"
		if errorlevel 1 goto stage_failed
	)

	::Extracting 6 unaltered (Scope) files
	echo Splitting AsteroidCity_3s.mkv
	set "stage_name=ffmpeg docs\temp\AsteroidCity_3s.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\ffmpeg\ffmpeg -threads 0 -ss 00:03:54.609 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 20792 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_3s.mkv" >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_3s.mkv"
	if errorlevel 1 goto stage_failed

	echo Splitting AsteroidCity_5s.mkv
	set "stage_name=ffmpeg docs\temp\AsteroidCity_5s.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\ffmpeg\ffmpeg -threads 0 -ss 00:23:26.780 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 14780 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_5s.mkv" >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_5s.mkv"
	if errorlevel 1 goto stage_failed

	echo Splitting AsteroidCity_7s.mkv
	set "stage_name=ffmpeg docs\temp\AsteroidCity_7s.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\ffmpeg\ffmpeg -threads 0 -ss 00:37:01.010 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 21248 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_7s.mkv" >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_7s.mkv"
	if errorlevel 1 goto stage_failed

	echo Splitting AsteroidCity_9s.mkv
	set "stage_name=ffmpeg docs\temp\AsteroidCity_9s.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\ffmpeg\ffmpeg -threads 0 -ss 00:54:40.694 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 25396 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_9s.mkv" >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_9s.mkv"
	if errorlevel 1 goto stage_failed

	echo Splitting AsteroidCity_11s.mkv
	set "stage_name=ffmpeg docs\temp\AsteroidCity_11s.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\ffmpeg\ffmpeg -threads 0 -ss 01:15:26.230 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 18249 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_11s.mkv" >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_11s.mkv"
	if errorlevel 1 goto stage_failed

	echo Splitting AsteroidCity_13s.mkv
	set "stage_name=ffmpeg docs\temp\AsteroidCity_13s.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\ffmpeg\ffmpeg -threads 0 -ss 01:33:46.746 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_13s.mkv" >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_13s.mkv"
	if errorlevel 1 goto stage_failed


	echo Splitting AsteroidCity_b.mkv
	set "stage_name=ffmpeg docs\temp\AsteroidCity_b.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\ffmpeg\ffmpeg -threads 0 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 137 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_b.mkv" >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_b.mkv"
	if errorlevel 1 goto stage_failed

	echo Letterboxing AsteroidCity_b.mkv
	set "stage_name=HandBrakeCLI docs\temp\AsteroidCity_b_Letterboxed.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_b.mkv" -o "docs\temp\AsteroidCity_b_Letterboxed.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 --crop 138:138:0:0 --inline-parameter-sets --non-anamorphic --pad "width=1920:height=1080" >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_b_Letterboxed.mkv"
	if errorlevel 1 goto stage_failed


	echo Splitting AsteroidCity_Logo2.mkv
	set "stage_name=ffmpeg docs\temp\AsteroidCity_Logo2.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\ffmpeg\ffmpeg -threads 0 -ss 00:00:18.727 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 475 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_Logo2.mkv" >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_Logo2.mkv"
	if errorlevel 1 goto stage_failed

	echo Letterboxing AsteroidCity_Logo2.mkv
	set "stage_name=HandBrakeCLI docs\temp\AsteroidCity_Logo2_Letterboxed.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_Logo2.mkv" -o "docs\temp\AsteroidCity_Logo2_Letterboxed.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 --crop 138:138:0:0 --inline-parameter-sets --non-anamorphic --pad "width=1920:height=1080" >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_Logo2_Letterboxed.mkv"
	if errorlevel 1 goto stage_failed



	echo Splitting AsteroidCity_2a.mkv
	set "stage_name=ffmpeg docs\temp\AsteroidCity_2a.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\ffmpeg\ffmpeg -threads 0 -ss 00:00:38.580 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 4700 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_2a.mkv" >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_2a.mkv"
	if errorlevel 1 goto stage_failed

	echo Windowboxing AsteroidCity_2a.mkv
	set "stage_name=HandBrakeCLI docs\temp\AsteroidCity_2a_Windowboxed.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_2a.mkv" -o "docs\temp\AsteroidCity_2a_Windowboxed.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 -w 1430 -l 804 --crop-mode "none" --inline-parameter-sets --non-anamorphic --pad "width=1920:height=1080" >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_2a_Windowboxed.mkv"
	if errorlevel 1 goto stage_failed


	echo Splitting AsteroidCity_4a.mkv
	set "stage_name=ffmpeg docs\temp\AsteroidCity_4a.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\ffmpeg\ffmpeg -threads 0 -ss 00:18:21.809 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 7312 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_4a.mkv" >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_4a.mkv"
	if errorlevel 1 goto stage_failed

	echo Windowboxing AsteroidCity_4a.mkv
	set "stage_name=HandBrakeCLI docs\temp\AsteroidCity_4a_Windowboxed.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_4a.mkv" -o "docs\temp\AsteroidCity_4a_Windowboxed.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 -w 1430 -l 804 --crop-mode "none" --inline-parameter-sets --non-anamorphic --pad "width=1920:height=1080" >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_4a_Windowboxed.mkv"
	if errorlevel 1 goto stage_failed


	echo Splitting AsteroidCity_6a.mkv
	set "stage_name=ffmpeg docs\temp\AsteroidCity_6a.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\ffmpeg\ffmpeg -threads 0 -ss 00:33:43.229 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 4742 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_6a.mkv" >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_6a.mkv"
	if errorlevel 1 goto stage_failed

	echo Windowboxing AsteroidCity_6a.mkv
	set "stage_name=HandBrakeCLI docs\temp\AsteroidCity_6a_Windowboxed.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_6a.mkv" -o "docs\temp\AsteroidCity_6a_Windowboxed.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 -w 1430 -l 804 --crop-mode "none" --inline-parameter-sets --non-anamorphic --pad "width=1920:height=1080" >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_6a_Windowboxed.mkv"
	if errorlevel 1 goto stage_failed


	echo Splitting AsteroidCity_8a.mkv
	set "stage_name=ffmpeg docs\temp\AsteroidCity_8a.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\ffmpeg\ffmpeg -threads 0 -ss 00:51:47.229 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 4159 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_8a.mkv" >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_8a.mkv"
	if errorlevel 1 goto stage_failed

	echo Windowboxing AsteroidCity_8a.mkv
	set "stage_name=HandBrakeCLI docs\temp\AsteroidCity_8a_Windowboxed.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_8a.mkv" -o "docs\temp\AsteroidCity_8a_Windowboxed.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 -w 1430 -l 804 --crop-mode "none" --inline-parameter-sets --non-anamorphic --pad "width=1920:height=1080" >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_8a_Windowboxed.mkv"
	if errorlevel 1 goto stage_failed


	echo Splitting AsteroidCity_10a.mkv
	set "stage_name=ffmpeg docs\temp\AsteroidCity_10a.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\ffmpeg\ffmpeg -threads 0 -ss 01:12:19.918 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 4467 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_10a.mkv" >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_10a.mkv"
	if errorlevel 1 goto stage_failed

	echo Windowboxing AsteroidCity_10a.mkv
	set "stage_name=HandBrakeCLI docs\temp\AsteroidCity_10a_Windowboxed.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_10a.mkv" -o "docs\temp\AsteroidCity_10a_Windowboxed.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 -w 1430 -l 804 --crop-mode "none" --inline-parameter-sets --non-anamorphic --pad "width=1920:height=1080" >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_10a_Windowboxed.mkv"
	if errorlevel 1 goto stage_failed


	echo Splitting AsteroidCity_12a.mkv
	set "stage_name=ffmpeg docs\temp\AsteroidCity_12a.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\ffmpeg\ffmpeg -threads 0 -ss 01:28:07.365 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 8137 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -map_metadata -1 -y "docs\temp\AsteroidCity_12a.mkv" >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_12a.mkv"
	if errorlevel 1 goto stage_failed

	echo Windowboxing AsteroidCity_12a.mkv
	set "stage_name=HandBrakeCLI docs\temp\AsteroidCity_12a_Windowboxed.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_12a.mkv" -o "docs\temp\AsteroidCity_12a_Windowboxed.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 -w 1430 -l 804 --crop-mode "none" --inline-parameter-sets --non-anamorphic --pad "width=1920:height=1080" >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_12a_Windowboxed.mkv"
	if errorlevel 1 goto stage_failed







	::Concatenating all 14 files
	echo Exporting...
	set "stage_name=avidemux_cli docs\temp\AsteroidCity_S.mkv"
	call :require_stage_output "docs\temp\AsteroidCity_b_Letterboxed.mkv"
	if errorlevel 1 goto stage_failed
	call :require_stage_output "docs\logos\AsteroidCity_Logo1.mkv"
	if errorlevel 1 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_Logo2_Letterboxed.mkv"
	if errorlevel 1 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_2a_Windowboxed.mkv"
	if errorlevel 1 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_3s.mkv"
	if errorlevel 1 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_4a_Windowboxed.mkv"
	if errorlevel 1 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_5s.mkv"
	if errorlevel 1 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_6a_Windowboxed.mkv"
	if errorlevel 1 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_7s.mkv"
	if errorlevel 1 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_8a_Windowboxed.mkv"
	if errorlevel 1 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_9s.mkv"
	if errorlevel 1 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_10a_Windowboxed.mkv"
	if errorlevel 1 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_11s.mkv"
	if errorlevel 1 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_12a_Windowboxed.mkv"
	if errorlevel 1 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_13s.mkv"
	if errorlevel 1 goto stage_failed
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\avidemux\avidemux_cli --load "docs\temp\AsteroidCity_b_Letterboxed.mkv" --append "docs\logos\AsteroidCity_Logo1.mkv" --append "docs\temp\AsteroidCity_Logo2_Letterboxed.mkv" --append "docs\temp\AsteroidCity_2a_Windowboxed.mkv" --append "docs\temp\AsteroidCity_3s.mkv" --append "docs\temp\AsteroidCity_4a_Windowboxed.mkv" --append "docs\temp\AsteroidCity_5s.mkv" --append "docs\temp\AsteroidCity_6a_Windowboxed.mkv" --append "docs\temp\AsteroidCity_7s.mkv" --append "docs\temp\AsteroidCity_8a_Windowboxed.mkv" --append "docs\temp\AsteroidCity_9s.mkv" --append "docs\temp\AsteroidCity_10a_Windowboxed.mkv" --append "docs\temp\AsteroidCity_11s.mkv" --append "docs\temp\AsteroidCity_12a_Windowboxed.mkv" --append "docs\temp\AsteroidCity_13s.mkv" --video-codec copy --audio-codec copy --output-format mkv --save "docs\temp\AsteroidCity_S.mkv" >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_S.mkv"
	if errorlevel 1 goto stage_failed
	call :validate_assembly "unmasked" "docs\temp\AsteroidCity_S.mkv"
	if errorlevel 1 goto stage_failed






	::Merging altered video with source rip, keeping only video track of the first and all but video track of the latter for the output file
	echo Remuxing audio and subtitles
	set "hello=Asteroid City Theatrical Scope Restoration (unmasked).mkv"
	set "result=!folder!!hello!"
	set "final_output=!result!"
	if "%dialog2%"=="y" set "final_output=!folder!\!hello!"
	if %dialog%==y (
		if %dialog2%==y (
			docs\programs\mkvtoolnix\mkvmerge -o "!folder!\Asteroid City Theatrical Scope Restoration (unmasked).mkv" -A --no-audio -S --no-subtitles -B --no-buttons --no-chapters -M --no-attachments --no-global-tags "docs\temp\AsteroidCity_S.mkv" -D --no-video "%file%" > "docs\temp\final-remux.log" 2>&1
			if errorlevel 2 goto remux_failed
			if errorlevel 1 goto remux_warning
			if not errorlevel 0 goto remux_failed
		) else if %dialog2%==n (
			docs\programs\mkvtoolnix\mkvmerge -o "!result!" -A --no-audio -S --no-subtitles -B --no-buttons --no-chapters -M --no-attachments --no-global-tags "docs\temp\AsteroidCity_S.mkv" -D --no-video "%file%" > "docs\temp\final-remux.log" 2>&1
			if errorlevel 2 goto remux_failed
			if errorlevel 1 goto remux_warning
			if not errorlevel 0 goto remux_failed
		)
	) else if %dialog%==n (
		if %dialog2%==y (
			docs\programs\mkvtoolnix\mkvmerge -o "!folder!\Asteroid City Theatrical Scope Restoration (unmasked).mkv" -A --no-audio -S --no-subtitles -B --no-buttons --no-chapters -M --no-attachments --no-global-tags "docs\temp\AsteroidCity_S.mkv" -D --no-video !file! > "docs\temp\final-remux.log" 2>&1
			if errorlevel 2 goto remux_failed
			if errorlevel 1 goto remux_warning
			if not errorlevel 0 goto remux_failed
		) else if %dialog2%==n (
			docs\programs\mkvtoolnix\mkvmerge -o "!result!" -A --no-audio -S --no-subtitles -B --no-buttons --no-chapters -M --no-attachments --no-global-tags "docs\temp\AsteroidCity_S.mkv" -D --no-video !file! > "docs\temp\final-remux.log" 2>&1
			if errorlevel 2 goto remux_failed
			if errorlevel 1 goto remux_warning
			if not errorlevel 0 goto remux_failed
		)
	)

	if not exist "!final_output!" goto remux_failed
	for %%F in ("!final_output!") do if %%~zF EQU 0 goto remux_failed

	endlocal

) else if %version%==2 (

	echo You have selected: Scope Theatrical ^(2.39:1, masked^)
	echo If this is correct press Enter
	echo If this was the wrong choice please restart this program
	PAUSE

	if %dialog%==y (
		set "stage_name=mkvmerge docs\temp\AsteroidCity.mkv"
		echo Stage: !stage_name!>> "docs\temp\processing.log"
		docs\programs\mkvtoolnix\mkvmerge -o "docs\temp\AsteroidCity.mkv" -A --no-audio -S --no-subtitles -B --no-buttons --no-chapters -M --no-attachments --no-global-tags "%file%" >> "docs\temp\processing.log" 2>&1
		if errorlevel 2 goto stage_failed
		if errorlevel 1 goto stage_warning
		if not errorlevel 0 goto stage_failed
		call :require_stage_output "docs\temp\AsteroidCity.mkv"
		if errorlevel 1 goto stage_failed
	) else if %dialog%==n (
		set "stage_name=mkvmerge docs\temp\AsteroidCity.mkv"
		echo Stage: !stage_name!>> "docs\temp\processing.log"
		docs\programs\mkvtoolnix\mkvmerge -o "docs\temp\AsteroidCity.mkv" -A --no-audio -S --no-subtitles -B --no-buttons --no-chapters -M --no-attachments --no-global-tags !file! >> "docs\temp\processing.log" 2>&1
		if errorlevel 2 goto stage_failed
		if errorlevel 1 goto stage_warning
		if not errorlevel 0 goto stage_failed
		call :require_stage_output "docs\temp\AsteroidCity.mkv"
		if errorlevel 1 goto stage_failed
	)

	::Extracting 12 files
	echo Splitting AsteroidCity_2a.mkv
	set "stage_name=ffmpeg docs\temp\AsteroidCity_2a.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\ffmpeg\ffmpeg -threads 0 -ss 00:00:38.580 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 4700 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_2a.mkv" >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_2a.mkv"
	if errorlevel 1 goto stage_failed

	echo Splitting AsteroidCity_3s.mkv
	set "stage_name=ffmpeg docs\temp\AsteroidCity_3s.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\ffmpeg\ffmpeg -threads 0 -ss 00:03:54.609 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 20792 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_3s.mkv" >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_3s.mkv"
	if errorlevel 1 goto stage_failed

	echo Splitting AsteroidCity_4a.mkv
	set "stage_name=ffmpeg docs\temp\AsteroidCity_4a.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\ffmpeg\ffmpeg -threads 0 -ss 00:18:21.809 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 7312 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_4a.mkv" >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_4a.mkv"
	if errorlevel 1 goto stage_failed

	echo Splitting AsteroidCity_5s.mkv
	set "stage_name=ffmpeg docs\temp\AsteroidCity_5s.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\ffmpeg\ffmpeg -threads 0 -ss 00:23:26.780 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 14780 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_5s.mkv" >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_5s.mkv"
	if errorlevel 1 goto stage_failed

	echo Splitting AsteroidCity_6a.mkv
	set "stage_name=ffmpeg docs\temp\AsteroidCity_6a.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\ffmpeg\ffmpeg -threads 0 -ss 00:33:43.229 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 4742 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_6a.mkv" >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_6a.mkv"
	if errorlevel 1 goto stage_failed

	echo Splitting AsteroidCity_7s.mkv
	set "stage_name=ffmpeg docs\temp\AsteroidCity_7s.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\ffmpeg\ffmpeg -threads 0 -ss 00:37:01.010 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 21248 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_7s.mkv" >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_7s.mkv"
	if errorlevel 1 goto stage_failed

	echo Splitting AsteroidCity_8a.mkv
	set "stage_name=ffmpeg docs\temp\AsteroidCity_8a.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\ffmpeg\ffmpeg -threads 0 -ss 00:51:47.229 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 4159 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_8a.mkv" >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_8a.mkv"
	if errorlevel 1 goto stage_failed

	echo Splitting AsteroidCity_9s.mkv
	set "stage_name=ffmpeg docs\temp\AsteroidCity_9s.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\ffmpeg\ffmpeg -threads 0 -ss 00:54:40.694 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 25396 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_9s.mkv" >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_9s.mkv"
	if errorlevel 1 goto stage_failed

	echo Splitting AsteroidCity_10a.mkv
	set "stage_name=ffmpeg docs\temp\AsteroidCity_10a.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\ffmpeg\ffmpeg -threads 0 -ss 01:12:19.918 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 4467 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_10a.mkv" >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_10a.mkv"
	if errorlevel 1 goto stage_failed

	echo Splitting AsteroidCity_11s.mkv
	set "stage_name=ffmpeg docs\temp\AsteroidCity_11s.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\ffmpeg\ffmpeg -threads 0 -ss 01:15:26.230 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 18249 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_11s.mkv" >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_11s.mkv"
	if errorlevel 1 goto stage_failed

	echo Splitting AsteroidCity_12a.mkv
	set "stage_name=ffmpeg docs\temp\AsteroidCity_12a.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\ffmpeg\ffmpeg -threads 0 -ss 01:28:07.365 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 8137 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -map_metadata -1 -y "docs\temp\AsteroidCity_12a.mkv" >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_12a.mkv"
	if errorlevel 1 goto stage_failed

	echo Splitting AsteroidCity_13s.mkv
	set "stage_name=ffmpeg docs\temp\AsteroidCity_13s.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\ffmpeg\ffmpeg -threads 0 -ss 01:33:46.746 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_13s.mkv" >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_13s.mkv"
	if errorlevel 1 goto stage_failed


	echo Splitting AsteroidCity_b.mkv
	set "stage_name=ffmpeg docs\temp\AsteroidCity_b.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\ffmpeg\ffmpeg -threads 0 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 137 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_b.mkv" >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_b.mkv"
	if errorlevel 1 goto stage_failed

	echo Cropping AsteroidCity_b.mkv
	set "stage_name=HandBrakeCLI docs\temp\AsteroidCity_b_Cropped.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_b.mkv" -o "docs\temp\AsteroidCity_b_Cropped.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 --crop 138:138:0:0 --inline-parameter-sets --non-anamorphic >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_b_Cropped.mkv"
	if errorlevel 1 goto stage_failed


	::Encoding(cropping) Logo 1
	echo Cropping AsteroidCity_Logo1.mkv
	set "stage_name=HandBrakeCLI docs\temp\AsteroidCity_Logo1_Cropped.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\handbrake\HandBrakeCLI -i "docs\logos\AsteroidCity_Logo1.mkv" -o "docs\temp\AsteroidCity_Logo1_Cropped.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 --crop 138:138:0:0 --inline-parameter-sets --non-anamorphic >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_Logo1_Cropped.mkv"
	if errorlevel 1 goto stage_failed

	echo Splitting AsteroidCity_Logo2.mkv
	set "stage_name=ffmpeg docs\temp\AsteroidCity_Logo2.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\ffmpeg\ffmpeg -threads 0 -ss 00:00:18.727 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 475 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_Logo2.mkv" >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_Logo2.mkv"
	if errorlevel 1 goto stage_failed

	echo Cropping AsteroidCity_Logo2.mkv
	set "stage_name=HandBrakeCLI docs\temp\AsteroidCity_Logo2_Cropped.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_Logo2.mkv" -o "docs\temp\AsteroidCity_Logo2_Cropped.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 --crop 138:138:0:0 --inline-parameter-sets --non-anamorphic >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_Logo2_Cropped.mkv"
	if errorlevel 1 goto stage_failed



	echo Windowboxing AsteroidCity_3s.mkv
	set "stage_name=HandBrakeCLI docs\temp\AsteroidCity_3s_Cropped.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_3s.mkv" -o "docs\temp\AsteroidCity_3s_Cropped.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 --crop 138:138:0:0 --inline-parameter-sets --non-anamorphic >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_3s_Cropped.mkv"
	if errorlevel 1 goto stage_failed


	echo Windowboxing AsteroidCity_5s.mkv
	set "stage_name=HandBrakeCLI docs\temp\AsteroidCity_5s_Cropped.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_5s.mkv" -o "docs\temp\AsteroidCity_5s_Cropped.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 --crop 138:138:0:0 --inline-parameter-sets --non-anamorphic >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_5s_Cropped.mkv"
	if errorlevel 1 goto stage_failed


	echo Windowboxing AsteroidCity_7s.mkv
	set "stage_name=HandBrakeCLI docs\temp\AsteroidCity_7s_Cropped.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_7s.mkv" -o "docs\temp\AsteroidCity_7s_Cropped.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 --crop 138:138:0:0 --inline-parameter-sets --non-anamorphic >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_7s_Cropped.mkv"
	if errorlevel 1 goto stage_failed


	echo Windowboxing AsteroidCity_9s.mkv
	set "stage_name=HandBrakeCLI docs\temp\AsteroidCity_9s_Cropped.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_9s.mkv" -o "docs\temp\AsteroidCity_9s_Cropped.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 --crop 138:138:0:0 --inline-parameter-sets --non-anamorphic >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_9s_Cropped.mkv"
	if errorlevel 1 goto stage_failed


	echo Windowboxing AsteroidCity_11s.mkv
	set "stage_name=HandBrakeCLI docs\temp\AsteroidCity_11s_Cropped.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_11s.mkv" -o "docs\temp\AsteroidCity_11s_Cropped.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 --crop 138:138:0:0 --inline-parameter-sets --non-anamorphic >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_11s_Cropped.mkv"
	if errorlevel 1 goto stage_failed


	echo Windowboxing AsteroidCity_13s.mkv
	set "stage_name=HandBrakeCLI docs\temp\AsteroidCity_13s_Cropped.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_13s.mkv" -o "docs\temp\AsteroidCity_13s_Cropped.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 --crop 138:138:0:0 --inline-parameter-sets --non-anamorphic >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_13s_Cropped.mkv"
	if errorlevel 1 goto stage_failed


	echo Windowboxing AsteroidCity_2a.mkv
	set "stage_name=HandBrakeCLI docs\temp\AsteroidCity_2a_Pillarboxed.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_2a.mkv" -o "docs\temp\AsteroidCity_2a_Pillarboxed.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 -w 1430 -l 804 --crop-mode "none" --inline-parameter-sets --non-anamorphic --pad "width=1920:height=804" >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_2a_Pillarboxed.mkv"
	if errorlevel 1 goto stage_failed


	echo Windowboxing AsteroidCity_4a.mkv
	set "stage_name=HandBrakeCLI docs\temp\AsteroidCity_4a_Pillarboxed.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_4a.mkv" -o "docs\temp\AsteroidCity_4a_Pillarboxed.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 -w 1430 -l 804 --crop-mode "none" --inline-parameter-sets --non-anamorphic --pad "width=1920:height=804" >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_4a_Pillarboxed.mkv"
	if errorlevel 1 goto stage_failed


	echo Windowboxing AsteroidCity_6a.mkv
	set "stage_name=HandBrakeCLI docs\temp\AsteroidCity_6a_Pillarboxed.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_6a.mkv" -o "docs\temp\AsteroidCity_6a_Pillarboxed.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 -w 1430 -l 804 --crop-mode "none" --inline-parameter-sets --non-anamorphic --pad "width=1920:height=804" >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_6a_Pillarboxed.mkv"
	if errorlevel 1 goto stage_failed


	echo Windowboxing AsteroidCity_8a.mkv
	set "stage_name=HandBrakeCLI docs\temp\AsteroidCity_8a_Pillarboxed.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_8a.mkv" -o "docs\temp\AsteroidCity_8a_Pillarboxed.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 -w 1430 -l 804 --crop-mode "none" --inline-parameter-sets --non-anamorphic --pad "width=1920:height=804" >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_8a_Pillarboxed.mkv"
	if errorlevel 1 goto stage_failed


	echo Windowboxing AsteroidCity_10a.mkv
	set "stage_name=HandBrakeCLI docs\temp\AsteroidCity_10a_Pillarboxed.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_10a.mkv" -o "docs\temp\AsteroidCity_10a_Pillarboxed.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 -w 1430 -l 804 --crop-mode "none" --inline-parameter-sets --non-anamorphic --pad "width=1920:height=804" >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_10a_Pillarboxed.mkv"
	if errorlevel 1 goto stage_failed


	echo Windowboxing AsteroidCity_12a.mkv
	set "stage_name=HandBrakeCLI docs\temp\AsteroidCity_12a_Pillarboxed.mkv"
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_12a.mkv" -o "docs\temp\AsteroidCity_12a_Pillarboxed.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 -w 1430 -l 804 --crop-mode "none" --inline-parameter-sets --non-anamorphic --pad "width=1920:height=804" >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_12a_Pillarboxed.mkv"
	if errorlevel 1 goto stage_failed



	::Concatenating all 14 files
	echo Exporting...
	set "stage_name=avidemux_cli docs\temp\AsteroidCity_S.mkv"
	call :require_stage_output "docs\temp\AsteroidCity_b_Cropped.mkv"
	if errorlevel 1 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_Logo1_Cropped.mkv"
	if errorlevel 1 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_Logo2_Cropped.mkv"
	if errorlevel 1 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_2a_Pillarboxed.mkv"
	if errorlevel 1 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_3s_Cropped.mkv"
	if errorlevel 1 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_4a_Pillarboxed.mkv"
	if errorlevel 1 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_5s_Cropped.mkv"
	if errorlevel 1 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_6a_Pillarboxed.mkv"
	if errorlevel 1 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_7s_Cropped.mkv"
	if errorlevel 1 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_8a_Pillarboxed.mkv"
	if errorlevel 1 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_9s_Cropped.mkv"
	if errorlevel 1 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_10a_Pillarboxed.mkv"
	if errorlevel 1 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_11s_Cropped.mkv"
	if errorlevel 1 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_12a_Pillarboxed.mkv"
	if errorlevel 1 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_13s_Cropped.mkv"
	if errorlevel 1 goto stage_failed
	echo Stage: !stage_name!>> "docs\temp\processing.log"
	docs\programs\avidemux\avidemux_cli --load "docs\temp\AsteroidCity_b_Cropped.mkv" --append "docs\temp\AsteroidCity_Logo1_Cropped.mkv" --append "docs\temp\AsteroidCity_Logo2_Cropped.mkv" --append "docs\temp\AsteroidCity_2a_Pillarboxed.mkv" --append "docs\temp\AsteroidCity_3s_Cropped.mkv" --append "docs\temp\AsteroidCity_4a_Pillarboxed.mkv" --append "docs\temp\AsteroidCity_5s_Cropped.mkv" --append "docs\temp\AsteroidCity_6a_Pillarboxed.mkv" --append "docs\temp\AsteroidCity_7s_Cropped.mkv" --append "docs\temp\AsteroidCity_8a_Pillarboxed.mkv" --append "docs\temp\AsteroidCity_9s_Cropped.mkv" --append "docs\temp\AsteroidCity_10a_Pillarboxed.mkv" --append "docs\temp\AsteroidCity_11s_Cropped.mkv" --append "docs\temp\AsteroidCity_12a_Pillarboxed.mkv" --append "docs\temp\AsteroidCity_13s_Cropped.mkv" --video-codec copy --audio-codec copy --output-format mkv --save "docs\temp\AsteroidCity_S.mkv" >> "docs\temp\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_S.mkv"
	if errorlevel 1 goto stage_failed
	call :validate_assembly "masked" "docs\temp\AsteroidCity_S.mkv"
	if errorlevel 1 goto stage_failed



	::Merging altered video with source rip, keeping only video track of the first and all but video track of the latter for the output file
	echo Remuxing audio and subtitles
	set "hello=Asteroid City Theatrical Scope Restoration (masked).mkv"
	set "result=!folder!!hello!"
	set "final_output=!result!"
	if "%dialog2%"=="y" set "final_output=!folder!\!hello!"
	if %dialog%==y (
		if %dialog2%==y (
			docs\programs\mkvtoolnix\mkvmerge -o "!folder!\Asteroid City Theatrical Scope Restoration (masked).mkv" -A --no-audio -S --no-subtitles -B --no-buttons --no-chapters -M --no-attachments --no-global-tags "docs\temp\AsteroidCity_S.mkv" -D --no-video "%file%" > "docs\temp\final-remux.log" 2>&1
			if errorlevel 2 goto remux_failed
			if errorlevel 1 goto remux_warning
			if not errorlevel 0 goto remux_failed
		) else if %dialog2%==n (
			docs\programs\mkvtoolnix\mkvmerge -o "!result!" -A --no-audio -S --no-subtitles -B --no-buttons --no-chapters -M --no-attachments --no-global-tags "docs\temp\AsteroidCity_S.mkv" -D --no-video "%file%" > "docs\temp\final-remux.log" 2>&1
			if errorlevel 2 goto remux_failed
			if errorlevel 1 goto remux_warning
			if not errorlevel 0 goto remux_failed
		)
	) else if %dialog%==n (
		if %dialog2%==y (
			docs\programs\mkvtoolnix\mkvmerge -o "!folder!\Asteroid City Theatrical Scope Restoration (masked).mkv" -A --no-audio -S --no-subtitles -B --no-buttons --no-chapters -M --no-attachments --no-global-tags "docs\temp\AsteroidCity_S.mkv" -D --no-video !file! > "docs\temp\final-remux.log" 2>&1
			if errorlevel 2 goto remux_failed
			if errorlevel 1 goto remux_warning
			if not errorlevel 0 goto remux_failed
		) else if %dialog2%==n (
			docs\programs\mkvtoolnix\mkvmerge -o "!result!" -A --no-audio -S --no-subtitles -B --no-buttons --no-chapters -M --no-attachments --no-global-tags "docs\temp\AsteroidCity_S.mkv" -D --no-video !file! > "docs\temp\final-remux.log" 2>&1
			if errorlevel 2 goto remux_failed
			if errorlevel 1 goto remux_warning
			if not errorlevel 0 goto remux_failed
		)
	)

	if not exist "!final_output!" goto remux_failed
	for %%F in ("!final_output!") do if %%~zF EQU 0 goto remux_failed

	endlocal

) else (
	::Loop if input is not valid
	echo %version% is not a valid input
	goto a
)

::Remove only the known log; unexpected work must survive cleanup.
call :cleanup_workspace
if errorlevel 1 goto cleanup_incomplete

echo Done!
PAUSE
popd
exit /b 0

:cleanup_incomplete
echo An output was created; independent assembly validation passed.
echo Full restoration quality still needs review.
echo Temporary inputs and logs remain in "%~dp0docs\temp".
echo Review or move them before starting another restoration.
PAUSE
popd
exit /b 1

:: Processing helpers: never remove predecessors on a failed stage.
:validate_assembly
set "stage_name=independent assembly validation: %~1"
echo Stage: !stage_name!>> "docs\temp\processing.log"
if not exist "docs\scripts\Validate-Assembly.ps1" (
 echo Missing assembly validator.>> "docs\temp\processing.log"
 exit /b 2
)
powershell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -File "docs\scripts\Validate-Assembly.ps1" -FFmpegPath "docs\programs\ffmpeg\ffmpeg.exe" -AssemblyPath "%~2" -InputListPath "docs\scripts\assembly-inputs-%~1.txt" -WorkDirectory "docs\temp\assembly-validation-%~1" >> "docs\temp\processing.log" 2>&1
if errorlevel 1 exit /b 2
if not errorlevel 0 exit /b 2
exit /b 0

:: Structural output check only; does not qualify media contents.
:require_stage_output
setlocal DisableDelayedExpansion
if not exist "%~1" (endlocal & exit /b 1)
if exist "%~1\" (endlocal & exit /b 1)
for %%F in ("%~1") do if %%~zF EQU 0 (endlocal & exit /b 1)
endlocal & exit /b 0

:stage_warning
echo Source preparation completed with warnings. Processing has stopped.
echo Stage: !stage_name!
echo Review docs\temp\processing.log before moving the preserved workspace.
PAUSE
popd
exit /b 1

:stage_failed
echo A processing stage failed or an expected output is missing or empty.
echo Stage: !stage_name!
echo Any partial output is untrusted. Temporary inputs have been preserved.
echo Review docs\temp\processing.log before moving the preserved workspace.
PAUSE
popd
exit /b 2

:: Workspace helpers: shared structure in both film launchers.
:prepare_workspace
rem Caller owns environment scope; keep pushd active until the final popd.
pushd "%~dp0"
if errorlevel 1 (
    echo Cannot open the restorer program folder. Processing has not started.
    exit /b 2
)
if not exist "docs\" (
    echo The docs folder is missing. Extract the complete application archive.
    popd
    exit /b 2
)
if exist "docs\temp" (
    echo Temporary work already exists in "%~dp0docs\temp".
    echo Preserve or move that folder before starting another restoration.
    echo No existing temporary files have been deleted.
    popd
    exit /b 2
)
mkdir "docs\temp"
if errorlevel 1 (
    echo Cannot create the temporary workspace. Processing has not started.
    popd
    exit /b 2
)
exit /b 0

:cleanup_workspace
setlocal DisableDelayedExpansion
rem Avidemux may report success after incomplete assembly; retain evidence.
if exist "docs\temp\processing.log" (
    endlocal & exit /b 1
)
if exist "docs\temp\final-remux.log" del /q "docs\temp\final-remux.log"
rem Nonrecursive removal preserves any unexpected files or subdirectories.
rmdir "docs\temp" 2>nul
if exist "docs\temp" (
    endlocal & exit /b 1
)
endlocal & exit /b 0

:remux_warning
echo Final remux completed with warnings. The output needs review.
echo The assembled video is retained at docs\temp\AsteroidCity_S.mkv
echo Details are in docs\temp\final-remux.log
echo A new run will preserve this folder and stop until you move it aside.
PAUSE
popd
exit /b 1

:remux_failed
echo Final remux failed. Any destination output may be incomplete; do not use it.
echo The assembled video is retained at docs\temp\AsteroidCity_S.mkv
echo Details are in docs\temp\final-remux.log
echo A new run will preserve this folder and stop until you move it aside.
PAUSE
popd
exit /b 2
