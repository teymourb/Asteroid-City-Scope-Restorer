@ECHO OFF
setlocal DisableDelayedExpansion
if "%~1"=="--selected" goto selected_entry
if not exist "%~dp0docs\scripts\Select-Restoration.ps1" (
    echo.
    echo ================================================================
    echo [STOP] Setup helper is missing. Extract the complete updated program folder.
    echo ================================================================
    pause
    exit /b 2
)
powershell.exe -NoProfile -STA -ExecutionPolicy Bypass -File "%~dp0docs\scripts\Select-Restoration.ps1" -Film Asteroid -Launcher "%~f0"
set "selection_result=%errorlevel%"
if "%selection_result%"=="2" pause
if "%selection_result%"=="0" pause
exit /b %selection_result%

:selected_entry
powershell.exe -NoProfile -STA -ExecutionPolicy Bypass -File "%~dp0docs\scripts\Select-Restoration.ps1" -Film Asteroid -ValidateEnvironment
if errorlevel 1 exit /b 2
call :prepare_workspace
if errorlevel 1 exit /b 2
if not exist "docs\scripts\Test-SourceFingerprint.ps1" (
    echo.
    echo ================================================================
    echo [STOP] Source-check helper is missing. Extract the complete updated program folder.
    echo ================================================================
    pause
    exit /b 2
)
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "docs\scripts\Test-SourceFingerprint.ps1" -Film Asteroid -Source "%file%" -WorkDirectory "%RESTORER_LOG_DIRECTORY%" -ScratchDirectory "docs\temp"
set "fingerprint_result=%errorlevel%"
if not "%fingerprint_result%"=="0" (
    echo.
    echo ================================================================
    echo [STOP] Source verification did not complete successfully. Processing has stopped.
    echo ================================================================
    pause
    exit /b 2
)
setlocal EnableDelayedExpansion

::Making sure setup is confirmed before any processing starts.
echo.
echo ----------------------------------------------------------------
echo Processing started. Keep this window open and the PC awake.
echo Detailed tool progress: %RESTORER_LOG_DIRECTORY%\processing.log
echo Copying and encoding can take a long time. Detailed progress is saved in the log.


::Check what version to use and make sure the user selected the right one
if %version%==1 (


	if %dialog%==y (
		set "stage_name=mkvmerge docs\temp\AsteroidCity.mkv"
		echo.
		echo ----------------------------------------------------------------
		echo [!time!] Preparing a video-only working copy; the original source is unchanged.
		echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
		docs\programs\mkvtoolnix\mkvmerge -o "docs\temp\AsteroidCity.mkv" -A --no-audio -S --no-subtitles -B --no-buttons --no-chapters -M --no-attachments --no-global-tags "%file%" >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
		if errorlevel 2 goto stage_failed
		if errorlevel 1 goto stage_warning
		if not errorlevel 0 goto stage_failed
		call :require_stage_output "docs\temp\AsteroidCity.mkv"
		if errorlevel 1 goto stage_failed
	) else if %dialog%==n (
		set "stage_name=mkvmerge docs\temp\AsteroidCity.mkv"
		echo.
		echo ----------------------------------------------------------------
		echo [!time!] Preparing a video-only working copy; the original source is unchanged.
		echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
		docs\programs\mkvtoolnix\mkvmerge -o "docs\temp\AsteroidCity.mkv" -A --no-audio -S --no-subtitles -B --no-buttons --no-chapters -M --no-attachments --no-global-tags !file! >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
		if errorlevel 2 goto stage_failed
		if errorlevel 1 goto stage_warning
		if not errorlevel 0 goto stage_failed
		call :require_stage_output "docs\temp\AsteroidCity.mkv"
		if errorlevel 1 goto stage_failed
	)

	::Extracting 6 unaltered (Scope) files
	set "stage_name=ffmpeg docs\temp\AsteroidCity_3s.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Copying a film section without re-encoding.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\ffmpeg\ffmpeg -nostdin -threads 0 -ss 00:03:54.609 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 20792 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_3s.mkv" >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_3s.mkv"
	if errorlevel 1 goto stage_failed
	set "stage_name=ffmpeg docs\temp\AsteroidCity_5s.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Copying a film section without re-encoding.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\ffmpeg\ffmpeg -nostdin -threads 0 -ss 00:23:26.780 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 14780 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_5s.mkv" >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_5s.mkv"
	if errorlevel 1 goto stage_failed
	set "stage_name=ffmpeg docs\temp\AsteroidCity_7s.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Copying a film section without re-encoding.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\ffmpeg\ffmpeg -nostdin -threads 0 -ss 00:37:01.010 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 21248 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_7s.mkv" >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_7s.mkv"
	if errorlevel 1 goto stage_failed
	set "stage_name=ffmpeg docs\temp\AsteroidCity_9s.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Copying a film section without re-encoding.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\ffmpeg\ffmpeg -nostdin -threads 0 -ss 00:54:40.694 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 25396 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_9s.mkv" >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_9s.mkv"
	if errorlevel 1 goto stage_failed
	set "stage_name=ffmpeg docs\temp\AsteroidCity_11s.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Copying a film section without re-encoding.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\ffmpeg\ffmpeg -nostdin -threads 0 -ss 01:15:26.230 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 18249 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_11s.mkv" >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_11s.mkv"
	if errorlevel 1 goto stage_failed
	set "stage_name=ffmpeg docs\temp\AsteroidCity_13s.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Copying a film section without re-encoding.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\ffmpeg\ffmpeg -nostdin -threads 0 -ss 01:33:46.746 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_13s.mkv" >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_13s.mkv"
	if errorlevel 1 goto stage_failed
	set "stage_name=ffmpeg docs\temp\AsteroidCity_b.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Copying a film section without re-encoding.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\ffmpeg\ffmpeg -nostdin -threads 0 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 137 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_b.mkv" >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_b.mkv"
	if errorlevel 1 goto stage_failed

	echo Letterboxing AsteroidCity_b.mkv
	set "stage_name=HandBrakeCLI docs\temp\AsteroidCity_b_Letterboxed.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Encoding a section with its restoration framing. This may take a long time.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_b.mkv" -o "docs\temp\AsteroidCity_b_Letterboxed.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 --crop 138:138:0:0 --inline-parameter-sets --non-anamorphic --pad "width=1920:height=1080" >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_b_Letterboxed.mkv"
	if errorlevel 1 goto stage_failed
	set "stage_name=ffmpeg docs\temp\AsteroidCity_Logo2.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Copying a film section without re-encoding.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\ffmpeg\ffmpeg -nostdin -threads 0 -ss 00:00:18.727 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 475 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_Logo2.mkv" >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_Logo2.mkv"
	if errorlevel 1 goto stage_failed

	echo Letterboxing AsteroidCity_Logo2.mkv
	set "stage_name=HandBrakeCLI docs\temp\AsteroidCity_Logo2_Letterboxed.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Encoding a section with its restoration framing. This may take a long time.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_Logo2.mkv" -o "docs\temp\AsteroidCity_Logo2_Letterboxed.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 --crop 138:138:0:0 --inline-parameter-sets --non-anamorphic --pad "width=1920:height=1080" >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_Logo2_Letterboxed.mkv"
	if errorlevel 1 goto stage_failed
	set "stage_name=ffmpeg docs\temp\AsteroidCity_2a.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Copying a film section without re-encoding.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\ffmpeg\ffmpeg -nostdin -threads 0 -ss 00:00:38.580 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 4700 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_2a.mkv" >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_2a.mkv"
	if errorlevel 1 goto stage_failed

	echo Windowboxing AsteroidCity_2a.mkv
	set "stage_name=HandBrakeCLI docs\temp\AsteroidCity_2a_Windowboxed.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Encoding a section with its restoration framing. This may take a long time.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_2a.mkv" -o "docs\temp\AsteroidCity_2a_Windowboxed.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 -w 1430 -l 804 --crop-mode "none" --inline-parameter-sets --non-anamorphic --pad "width=1920:height=1080" >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_2a_Windowboxed.mkv"
	if errorlevel 1 goto stage_failed
	set "stage_name=ffmpeg docs\temp\AsteroidCity_4a.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Copying a film section without re-encoding.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\ffmpeg\ffmpeg -nostdin -threads 0 -ss 00:18:21.809 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 7312 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_4a.mkv" >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_4a.mkv"
	if errorlevel 1 goto stage_failed

	echo Windowboxing AsteroidCity_4a.mkv
	set "stage_name=HandBrakeCLI docs\temp\AsteroidCity_4a_Windowboxed.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Encoding a section with its restoration framing. This may take a long time.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_4a.mkv" -o "docs\temp\AsteroidCity_4a_Windowboxed.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 -w 1430 -l 804 --crop-mode "none" --inline-parameter-sets --non-anamorphic --pad "width=1920:height=1080" >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_4a_Windowboxed.mkv"
	if errorlevel 1 goto stage_failed
	set "stage_name=ffmpeg docs\temp\AsteroidCity_6a.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Copying a film section without re-encoding.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\ffmpeg\ffmpeg -nostdin -threads 0 -ss 00:33:43.229 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 4742 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_6a.mkv" >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_6a.mkv"
	if errorlevel 1 goto stage_failed

	echo Windowboxing AsteroidCity_6a.mkv
	set "stage_name=HandBrakeCLI docs\temp\AsteroidCity_6a_Windowboxed.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Encoding a section with its restoration framing. This may take a long time.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_6a.mkv" -o "docs\temp\AsteroidCity_6a_Windowboxed.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 -w 1430 -l 804 --crop-mode "none" --inline-parameter-sets --non-anamorphic --pad "width=1920:height=1080" >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_6a_Windowboxed.mkv"
	if errorlevel 1 goto stage_failed
	set "stage_name=ffmpeg docs\temp\AsteroidCity_8a.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Copying a film section without re-encoding.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\ffmpeg\ffmpeg -nostdin -threads 0 -ss 00:51:47.229 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 4159 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_8a.mkv" >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_8a.mkv"
	if errorlevel 1 goto stage_failed

	echo Windowboxing AsteroidCity_8a.mkv
	set "stage_name=HandBrakeCLI docs\temp\AsteroidCity_8a_Windowboxed.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Encoding a section with its restoration framing. This may take a long time.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_8a.mkv" -o "docs\temp\AsteroidCity_8a_Windowboxed.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 -w 1430 -l 804 --crop-mode "none" --inline-parameter-sets --non-anamorphic --pad "width=1920:height=1080" >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_8a_Windowboxed.mkv"
	if errorlevel 1 goto stage_failed
	set "stage_name=ffmpeg docs\temp\AsteroidCity_10a.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Copying a film section without re-encoding.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\ffmpeg\ffmpeg -nostdin -threads 0 -ss 01:12:19.918 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 4467 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_10a.mkv" >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_10a.mkv"
	if errorlevel 1 goto stage_failed

	echo Windowboxing AsteroidCity_10a.mkv
	set "stage_name=HandBrakeCLI docs\temp\AsteroidCity_10a_Windowboxed.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Encoding a section with its restoration framing. This may take a long time.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_10a.mkv" -o "docs\temp\AsteroidCity_10a_Windowboxed.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 -w 1430 -l 804 --crop-mode "none" --inline-parameter-sets --non-anamorphic --pad "width=1920:height=1080" >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_10a_Windowboxed.mkv"
	if errorlevel 1 goto stage_failed
	set "stage_name=ffmpeg docs\temp\AsteroidCity_12a.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Copying a film section without re-encoding.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\ffmpeg\ffmpeg -nostdin -threads 0 -ss 01:28:07.365 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 8137 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -map_metadata -1 -y "docs\temp\AsteroidCity_12a.mkv" >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_12a.mkv"
	if errorlevel 1 goto stage_failed

	echo Windowboxing AsteroidCity_12a.mkv
	set "stage_name=HandBrakeCLI docs\temp\AsteroidCity_12a_Windowboxed.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Encoding a section with its restoration framing. This may take a long time.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_12a.mkv" -o "docs\temp\AsteroidCity_12a_Windowboxed.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 -w 1430 -l 804 --crop-mode "none" --inline-parameter-sets --non-anamorphic --pad "width=1920:height=1080" >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_12a_Windowboxed.mkv"
	if errorlevel 1 goto stage_failed







	::Concatenating all 14 files
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
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Joining the completed video sections in order.
	echo Working file: !stage_name!
	echo Assembly diagnostics and any questions appear in this window, not processing.log.
	echo Answer only an explicit assembly question: y continues despite its warning; n declines.
	echo Continuing does not establish codec compatibility or seamless joins.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\avidemux\avidemux_cli --load "docs\temp\AsteroidCity_b_Letterboxed.mkv" --append "docs\logos\AsteroidCity_Logo1.mkv" --append "docs\temp\AsteroidCity_Logo2_Letterboxed.mkv" --append "docs\temp\AsteroidCity_2a_Windowboxed.mkv" --append "docs\temp\AsteroidCity_3s.mkv" --append "docs\temp\AsteroidCity_4a_Windowboxed.mkv" --append "docs\temp\AsteroidCity_5s.mkv" --append "docs\temp\AsteroidCity_6a_Windowboxed.mkv" --append "docs\temp\AsteroidCity_7s.mkv" --append "docs\temp\AsteroidCity_8a_Windowboxed.mkv" --append "docs\temp\AsteroidCity_9s.mkv" --append "docs\temp\AsteroidCity_10a_Windowboxed.mkv" --append "docs\temp\AsteroidCity_11s.mkv" --append "docs\temp\AsteroidCity_12a_Windowboxed.mkv" --append "docs\temp\AsteroidCity_13s.mkv" --video-codec copy --audio-codec copy --output-format mkv --save "docs\temp\AsteroidCity_S.mkv"
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_S.mkv"
	if errorlevel 1 goto stage_failed






	::Merging altered video with source rip, keeping only video track of the first and all but video track of the latter for the output file
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Creating the final file with original audio and subtitles.
	echo Remuxing audio and subtitles
	set "hello=Asteroid City Theatrical Scope Restoration (unmasked).mkv"
	set "result=!folder!!hello!"
	set "final_output=!result!"
	if "%dialog2%"=="y" set "final_output=!folder!\!hello!"
	if exist "!final_output!" goto output_exists
	if %dialog%==y (
		if %dialog2%==y (
			docs\programs\mkvtoolnix\mkvmerge -o "!folder!\Asteroid City Theatrical Scope Restoration (unmasked).mkv" -A --no-audio -S --no-subtitles -B --no-buttons --no-chapters -M --no-attachments --no-global-tags "docs\temp\AsteroidCity_S.mkv" -D --no-video "%file%" > "%RESTORER_LOG_DIRECTORY%\final-remux.log" 2>&1
			if errorlevel 2 goto remux_failed
			if errorlevel 1 goto remux_warning
			if not errorlevel 0 goto remux_failed
		) else if %dialog2%==n (
			docs\programs\mkvtoolnix\mkvmerge -o "!result!" -A --no-audio -S --no-subtitles -B --no-buttons --no-chapters -M --no-attachments --no-global-tags "docs\temp\AsteroidCity_S.mkv" -D --no-video "%file%" > "%RESTORER_LOG_DIRECTORY%\final-remux.log" 2>&1
			if errorlevel 2 goto remux_failed
			if errorlevel 1 goto remux_warning
			if not errorlevel 0 goto remux_failed
		)
	) else if %dialog%==n (
		if %dialog2%==y (
			docs\programs\mkvtoolnix\mkvmerge -o "!folder!\Asteroid City Theatrical Scope Restoration (unmasked).mkv" -A --no-audio -S --no-subtitles -B --no-buttons --no-chapters -M --no-attachments --no-global-tags "docs\temp\AsteroidCity_S.mkv" -D --no-video !file! > "%RESTORER_LOG_DIRECTORY%\final-remux.log" 2>&1
			if errorlevel 2 goto remux_failed
			if errorlevel 1 goto remux_warning
			if not errorlevel 0 goto remux_failed
		) else if %dialog2%==n (
			docs\programs\mkvtoolnix\mkvmerge -o "!result!" -A --no-audio -S --no-subtitles -B --no-buttons --no-chapters -M --no-attachments --no-global-tags "docs\temp\AsteroidCity_S.mkv" -D --no-video !file! > "%RESTORER_LOG_DIRECTORY%\final-remux.log" 2>&1
			if errorlevel 2 goto remux_failed
			if errorlevel 1 goto remux_warning
			if not errorlevel 0 goto remux_failed
		)
	)

	if not exist "!final_output!" goto remux_failed
	for %%F in ("!final_output!") do if %%~zF EQU 0 goto remux_failed

	for %%O in ("!final_output!") do (endlocal & set "completed_output=%%~O")

) else if %version%==2 (


	if %dialog%==y (
		set "stage_name=mkvmerge docs\temp\AsteroidCity.mkv"
		echo.
		echo ----------------------------------------------------------------
		echo [!time!] Preparing a video-only working copy; the original source is unchanged.
		echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
		docs\programs\mkvtoolnix\mkvmerge -o "docs\temp\AsteroidCity.mkv" -A --no-audio -S --no-subtitles -B --no-buttons --no-chapters -M --no-attachments --no-global-tags "%file%" >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
		if errorlevel 2 goto stage_failed
		if errorlevel 1 goto stage_warning
		if not errorlevel 0 goto stage_failed
		call :require_stage_output "docs\temp\AsteroidCity.mkv"
		if errorlevel 1 goto stage_failed
	) else if %dialog%==n (
		set "stage_name=mkvmerge docs\temp\AsteroidCity.mkv"
		echo.
		echo ----------------------------------------------------------------
		echo [!time!] Preparing a video-only working copy; the original source is unchanged.
		echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
		docs\programs\mkvtoolnix\mkvmerge -o "docs\temp\AsteroidCity.mkv" -A --no-audio -S --no-subtitles -B --no-buttons --no-chapters -M --no-attachments --no-global-tags !file! >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
		if errorlevel 2 goto stage_failed
		if errorlevel 1 goto stage_warning
		if not errorlevel 0 goto stage_failed
		call :require_stage_output "docs\temp\AsteroidCity.mkv"
		if errorlevel 1 goto stage_failed
	)

	::Extracting 12 files
	set "stage_name=ffmpeg docs\temp\AsteroidCity_2a.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Copying a film section without re-encoding.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\ffmpeg\ffmpeg -nostdin -threads 0 -ss 00:00:38.580 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 4700 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_2a.mkv" >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_2a.mkv"
	if errorlevel 1 goto stage_failed
	set "stage_name=ffmpeg docs\temp\AsteroidCity_3s.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Copying a film section without re-encoding.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\ffmpeg\ffmpeg -nostdin -threads 0 -ss 00:03:54.609 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 20792 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_3s.mkv" >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_3s.mkv"
	if errorlevel 1 goto stage_failed
	set "stage_name=ffmpeg docs\temp\AsteroidCity_4a.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Copying a film section without re-encoding.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\ffmpeg\ffmpeg -nostdin -threads 0 -ss 00:18:21.809 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 7312 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_4a.mkv" >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_4a.mkv"
	if errorlevel 1 goto stage_failed
	set "stage_name=ffmpeg docs\temp\AsteroidCity_5s.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Copying a film section without re-encoding.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\ffmpeg\ffmpeg -nostdin -threads 0 -ss 00:23:26.780 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 14780 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_5s.mkv" >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_5s.mkv"
	if errorlevel 1 goto stage_failed
	set "stage_name=ffmpeg docs\temp\AsteroidCity_6a.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Copying a film section without re-encoding.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\ffmpeg\ffmpeg -nostdin -threads 0 -ss 00:33:43.229 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 4742 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_6a.mkv" >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_6a.mkv"
	if errorlevel 1 goto stage_failed
	set "stage_name=ffmpeg docs\temp\AsteroidCity_7s.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Copying a film section without re-encoding.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\ffmpeg\ffmpeg -nostdin -threads 0 -ss 00:37:01.010 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 21248 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_7s.mkv" >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_7s.mkv"
	if errorlevel 1 goto stage_failed
	set "stage_name=ffmpeg docs\temp\AsteroidCity_8a.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Copying a film section without re-encoding.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\ffmpeg\ffmpeg -nostdin -threads 0 -ss 00:51:47.229 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 4159 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_8a.mkv" >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_8a.mkv"
	if errorlevel 1 goto stage_failed
	set "stage_name=ffmpeg docs\temp\AsteroidCity_9s.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Copying a film section without re-encoding.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\ffmpeg\ffmpeg -nostdin -threads 0 -ss 00:54:40.694 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 25396 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_9s.mkv" >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_9s.mkv"
	if errorlevel 1 goto stage_failed
	set "stage_name=ffmpeg docs\temp\AsteroidCity_10a.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Copying a film section without re-encoding.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\ffmpeg\ffmpeg -nostdin -threads 0 -ss 01:12:19.918 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 4467 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_10a.mkv" >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_10a.mkv"
	if errorlevel 1 goto stage_failed
	set "stage_name=ffmpeg docs\temp\AsteroidCity_11s.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Copying a film section without re-encoding.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\ffmpeg\ffmpeg -nostdin -threads 0 -ss 01:15:26.230 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 18249 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_11s.mkv" >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_11s.mkv"
	if errorlevel 1 goto stage_failed
	set "stage_name=ffmpeg docs\temp\AsteroidCity_12a.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Copying a film section without re-encoding.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\ffmpeg\ffmpeg -nostdin -threads 0 -ss 01:28:07.365 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 8137 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -map_metadata -1 -y "docs\temp\AsteroidCity_12a.mkv" >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_12a.mkv"
	if errorlevel 1 goto stage_failed
	set "stage_name=ffmpeg docs\temp\AsteroidCity_13s.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Copying a film section without re-encoding.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\ffmpeg\ffmpeg -nostdin -threads 0 -ss 01:33:46.746 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_13s.mkv" >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_13s.mkv"
	if errorlevel 1 goto stage_failed
	set "stage_name=ffmpeg docs\temp\AsteroidCity_b.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Copying a film section without re-encoding.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\ffmpeg\ffmpeg -nostdin -threads 0 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 137 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_b.mkv" >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_b.mkv"
	if errorlevel 1 goto stage_failed
	set "stage_name=HandBrakeCLI docs\temp\AsteroidCity_b_Cropped.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Encoding a section with its restoration framing. This may take a long time.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_b.mkv" -o "docs\temp\AsteroidCity_b_Cropped.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 --crop 138:138:0:0 --inline-parameter-sets --non-anamorphic >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_b_Cropped.mkv"
	if errorlevel 1 goto stage_failed


	::Encoding(cropping) Logo 1
	set "stage_name=HandBrakeCLI docs\temp\AsteroidCity_Logo1_Cropped.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Encoding a section with its restoration framing. This may take a long time.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\handbrake\HandBrakeCLI -i "docs\logos\AsteroidCity_Logo1.mkv" -o "docs\temp\AsteroidCity_Logo1_Cropped.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 --crop 138:138:0:0 --inline-parameter-sets --non-anamorphic >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_Logo1_Cropped.mkv"
	if errorlevel 1 goto stage_failed
	set "stage_name=ffmpeg docs\temp\AsteroidCity_Logo2.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Copying a film section without re-encoding.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\ffmpeg\ffmpeg -nostdin -threads 0 -ss 00:00:18.727 -noaccurate_seek -i "docs\temp\AsteroidCity.mkv" -vframes 475 -c:v copy -map v:0 -map_chapters -1 -map_metadata -1 -y "docs\temp\AsteroidCity_Logo2.mkv" >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_Logo2.mkv"
	if errorlevel 1 goto stage_failed
	set "stage_name=HandBrakeCLI docs\temp\AsteroidCity_Logo2_Cropped.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Encoding a section with its restoration framing. This may take a long time.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_Logo2.mkv" -o "docs\temp\AsteroidCity_Logo2_Cropped.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 --crop 138:138:0:0 --inline-parameter-sets --non-anamorphic >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_Logo2_Cropped.mkv"
	if errorlevel 1 goto stage_failed



	echo Windowboxing AsteroidCity_3s.mkv
	set "stage_name=HandBrakeCLI docs\temp\AsteroidCity_3s_Cropped.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Encoding a section with its restoration framing. This may take a long time.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_3s.mkv" -o "docs\temp\AsteroidCity_3s_Cropped.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 --crop 138:138:0:0 --inline-parameter-sets --non-anamorphic >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_3s_Cropped.mkv"
	if errorlevel 1 goto stage_failed


	echo Windowboxing AsteroidCity_5s.mkv
	set "stage_name=HandBrakeCLI docs\temp\AsteroidCity_5s_Cropped.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Encoding a section with its restoration framing. This may take a long time.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_5s.mkv" -o "docs\temp\AsteroidCity_5s_Cropped.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 --crop 138:138:0:0 --inline-parameter-sets --non-anamorphic >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_5s_Cropped.mkv"
	if errorlevel 1 goto stage_failed


	echo Windowboxing AsteroidCity_7s.mkv
	set "stage_name=HandBrakeCLI docs\temp\AsteroidCity_7s_Cropped.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Encoding a section with its restoration framing. This may take a long time.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_7s.mkv" -o "docs\temp\AsteroidCity_7s_Cropped.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 --crop 138:138:0:0 --inline-parameter-sets --non-anamorphic >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_7s_Cropped.mkv"
	if errorlevel 1 goto stage_failed


	echo Windowboxing AsteroidCity_9s.mkv
	set "stage_name=HandBrakeCLI docs\temp\AsteroidCity_9s_Cropped.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Encoding a section with its restoration framing. This may take a long time.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_9s.mkv" -o "docs\temp\AsteroidCity_9s_Cropped.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 --crop 138:138:0:0 --inline-parameter-sets --non-anamorphic >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_9s_Cropped.mkv"
	if errorlevel 1 goto stage_failed


	echo Windowboxing AsteroidCity_11s.mkv
	set "stage_name=HandBrakeCLI docs\temp\AsteroidCity_11s_Cropped.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Encoding a section with its restoration framing. This may take a long time.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_11s.mkv" -o "docs\temp\AsteroidCity_11s_Cropped.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 --crop 138:138:0:0 --inline-parameter-sets --non-anamorphic >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_11s_Cropped.mkv"
	if errorlevel 1 goto stage_failed


	echo Windowboxing AsteroidCity_13s.mkv
	set "stage_name=HandBrakeCLI docs\temp\AsteroidCity_13s_Cropped.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Encoding a section with its restoration framing. This may take a long time.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_13s.mkv" -o "docs\temp\AsteroidCity_13s_Cropped.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 --crop 138:138:0:0 --inline-parameter-sets --non-anamorphic >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_13s_Cropped.mkv"
	if errorlevel 1 goto stage_failed


	echo Windowboxing AsteroidCity_2a.mkv
	set "stage_name=HandBrakeCLI docs\temp\AsteroidCity_2a_Pillarboxed.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Encoding a section with its restoration framing. This may take a long time.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_2a.mkv" -o "docs\temp\AsteroidCity_2a_Pillarboxed.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 -w 1430 -l 804 --crop-mode "none" --inline-parameter-sets --non-anamorphic --pad "width=1920:height=804" >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_2a_Pillarboxed.mkv"
	if errorlevel 1 goto stage_failed


	echo Windowboxing AsteroidCity_4a.mkv
	set "stage_name=HandBrakeCLI docs\temp\AsteroidCity_4a_Pillarboxed.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Encoding a section with its restoration framing. This may take a long time.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_4a.mkv" -o "docs\temp\AsteroidCity_4a_Pillarboxed.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 -w 1430 -l 804 --crop-mode "none" --inline-parameter-sets --non-anamorphic --pad "width=1920:height=804" >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_4a_Pillarboxed.mkv"
	if errorlevel 1 goto stage_failed


	echo Windowboxing AsteroidCity_6a.mkv
	set "stage_name=HandBrakeCLI docs\temp\AsteroidCity_6a_Pillarboxed.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Encoding a section with its restoration framing. This may take a long time.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_6a.mkv" -o "docs\temp\AsteroidCity_6a_Pillarboxed.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 -w 1430 -l 804 --crop-mode "none" --inline-parameter-sets --non-anamorphic --pad "width=1920:height=804" >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_6a_Pillarboxed.mkv"
	if errorlevel 1 goto stage_failed


	echo Windowboxing AsteroidCity_8a.mkv
	set "stage_name=HandBrakeCLI docs\temp\AsteroidCity_8a_Pillarboxed.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Encoding a section with its restoration framing. This may take a long time.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_8a.mkv" -o "docs\temp\AsteroidCity_8a_Pillarboxed.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 -w 1430 -l 804 --crop-mode "none" --inline-parameter-sets --non-anamorphic --pad "width=1920:height=804" >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_8a_Pillarboxed.mkv"
	if errorlevel 1 goto stage_failed


	echo Windowboxing AsteroidCity_10a.mkv
	set "stage_name=HandBrakeCLI docs\temp\AsteroidCity_10a_Pillarboxed.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Encoding a section with its restoration framing. This may take a long time.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_10a.mkv" -o "docs\temp\AsteroidCity_10a_Pillarboxed.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 -w 1430 -l 804 --crop-mode "none" --inline-parameter-sets --non-anamorphic --pad "width=1920:height=804" >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_10a_Pillarboxed.mkv"
	if errorlevel 1 goto stage_failed


	echo Windowboxing AsteroidCity_12a.mkv
	set "stage_name=HandBrakeCLI docs\temp\AsteroidCity_12a_Pillarboxed.mkv"
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Encoding a section with its restoration framing. This may take a long time.
	echo Working file: !stage_name!
	echo Detailed progress: %RESTORER_LOG_DIRECTORY%\processing.log - this window may be quiet.
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	docs\programs\handbrake\HandBrakeCLI -i "docs\temp\AsteroidCity_12a.mkv" -o "docs\temp\AsteroidCity_12a_Pillarboxed.mkv" -e x264 --encoder-preset "fast" --encoder-profile "auto" --encoder-level "auto" -b 29500 --cfr -2 -w 1430 -l 804 --crop-mode "none" --inline-parameter-sets --non-anamorphic --pad "width=1920:height=804" >> "%RESTORER_LOG_DIRECTORY%\processing.log" 2>&1
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_12a_Pillarboxed.mkv"
	if errorlevel 1 goto stage_failed



	::Concatenating all 14 files
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
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Joining the completed video sections in order.
	echo Working file: !stage_name!
	echo Stage: !stage_name!>> "%RESTORER_LOG_DIRECTORY%\processing.log"
	echo Assembly diagnostics and any questions appear in this window, not processing.log.
	echo Answer only an explicit assembly question: y continues despite its warning; n declines.
	echo Continuing does not establish codec compatibility or seamless joins.
	docs\programs\avidemux\avidemux_cli --load "docs\temp\AsteroidCity_b_Cropped.mkv" --append "docs\temp\AsteroidCity_Logo1_Cropped.mkv" --append "docs\temp\AsteroidCity_Logo2_Cropped.mkv" --append "docs\temp\AsteroidCity_2a_Pillarboxed.mkv" --append "docs\temp\AsteroidCity_3s_Cropped.mkv" --append "docs\temp\AsteroidCity_4a_Pillarboxed.mkv" --append "docs\temp\AsteroidCity_5s_Cropped.mkv" --append "docs\temp\AsteroidCity_6a_Pillarboxed.mkv" --append "docs\temp\AsteroidCity_7s_Cropped.mkv" --append "docs\temp\AsteroidCity_8a_Pillarboxed.mkv" --append "docs\temp\AsteroidCity_9s_Cropped.mkv" --append "docs\temp\AsteroidCity_10a_Pillarboxed.mkv" --append "docs\temp\AsteroidCity_11s_Cropped.mkv" --append "docs\temp\AsteroidCity_12a_Pillarboxed.mkv" --append "docs\temp\AsteroidCity_13s_Cropped.mkv" --video-codec copy --audio-codec copy --output-format mkv --save "docs\temp\AsteroidCity_S.mkv"
	if errorlevel 1 goto stage_failed
	if not errorlevel 0 goto stage_failed
	call :require_stage_output "docs\temp\AsteroidCity_S.mkv"
	if errorlevel 1 goto stage_failed



	::Merging altered video with source rip, keeping only video track of the first and all but video track of the latter for the output file
	echo.
	echo ----------------------------------------------------------------
	echo [!time!] Creating the final file with original audio and subtitles.
	echo Remuxing audio and subtitles
	set "hello=Asteroid City Theatrical Scope Restoration (masked).mkv"
	set "result=!folder!!hello!"
	set "final_output=!result!"
	if "%dialog2%"=="y" set "final_output=!folder!\!hello!"
	if exist "!final_output!" goto output_exists
	if %dialog%==y (
		if %dialog2%==y (
			docs\programs\mkvtoolnix\mkvmerge -o "!folder!\Asteroid City Theatrical Scope Restoration (masked).mkv" -A --no-audio -S --no-subtitles -B --no-buttons --no-chapters -M --no-attachments --no-global-tags "docs\temp\AsteroidCity_S.mkv" -D --no-video "%file%" > "%RESTORER_LOG_DIRECTORY%\final-remux.log" 2>&1
			if errorlevel 2 goto remux_failed
			if errorlevel 1 goto remux_warning
			if not errorlevel 0 goto remux_failed
		) else if %dialog2%==n (
			docs\programs\mkvtoolnix\mkvmerge -o "!result!" -A --no-audio -S --no-subtitles -B --no-buttons --no-chapters -M --no-attachments --no-global-tags "docs\temp\AsteroidCity_S.mkv" -D --no-video "%file%" > "%RESTORER_LOG_DIRECTORY%\final-remux.log" 2>&1
			if errorlevel 2 goto remux_failed
			if errorlevel 1 goto remux_warning
			if not errorlevel 0 goto remux_failed
		)
	) else if %dialog%==n (
		if %dialog2%==y (
			docs\programs\mkvtoolnix\mkvmerge -o "!folder!\Asteroid City Theatrical Scope Restoration (masked).mkv" -A --no-audio -S --no-subtitles -B --no-buttons --no-chapters -M --no-attachments --no-global-tags "docs\temp\AsteroidCity_S.mkv" -D --no-video !file! > "%RESTORER_LOG_DIRECTORY%\final-remux.log" 2>&1
			if errorlevel 2 goto remux_failed
			if errorlevel 1 goto remux_warning
			if not errorlevel 0 goto remux_failed
		) else if %dialog2%==n (
			docs\programs\mkvtoolnix\mkvmerge -o "!result!" -A --no-audio -S --no-subtitles -B --no-buttons --no-chapters -M --no-attachments --no-global-tags "docs\temp\AsteroidCity_S.mkv" -D --no-video !file! > "%RESTORER_LOG_DIRECTORY%\final-remux.log" 2>&1
			if errorlevel 2 goto remux_failed
			if errorlevel 1 goto remux_warning
			if not errorlevel 0 goto remux_failed
		)
	)

	if not exist "!final_output!" goto remux_failed
	for %%F in ("!final_output!") do if %%~zF EQU 0 goto remux_failed

	for %%O in ("!final_output!") do (endlocal & set "completed_output=%%~O")

) else (
	::Loop if input is not valid
	echo %version% is not a valid input
	goto stage_failed
)

echo.
echo ================================================================
echo [OK] Restoration complete.
echo ================================================================
echo Output: "%completed_output%"
echo The final MKV contains the restored video and the selected original audio and subtitles.
echo Logs: "%RESTORER_LOG_DIRECTORY%"

popd
exit /b 0

:: Processing helpers: never remove predecessors on a failed stage.
:: Structural output check only; does not qualify media contents.
:require_stage_output
setlocal DisableDelayedExpansion
if not exist "%~1" (endlocal & exit /b 1)
if exist "%~1\" (endlocal & exit /b 1)
for %%F in ("%~1") do if %%~zF EQU 0 (endlocal & exit /b 1)
endlocal & exit /b 0

:stage_warning
echo.
echo ================================================================
echo [STOP] Source preparation completed with warnings. Processing has stopped.
echo ================================================================
echo Stage: !stage_name!
echo Logs: "%RESTORER_LOG_DIRECTORY%"
echo You can start a new restoration after closing this run.
PAUSE
popd
exit /b 1

:stage_failed
echo.
echo ================================================================
echo [STOP] a processing stage failed, or an expected output is missing or empty.
echo ================================================================
echo Stage: !stage_name!
echo Any partial output is untrusted. Temporary inputs have been preserved.
echo Logs: "%RESTORER_LOG_DIRECTORY%"
echo You can start a new restoration after closing this run.
PAUSE
popd
exit /b 2

:: Workspace helpers: shared structure in both film launchers.
:prepare_workspace
rem Caller owns environment scope; keep pushd active until the final popd.
pushd "%~dp0"
if errorlevel 1 (
    echo.
    echo ================================================================
    echo [STOP] Cannot open the restorer program folder. Processing has not started.
    echo ================================================================
    exit /b 2
)
if not exist "docs\" (
    echo.
    echo ================================================================
    echo [STOP] The docs folder is missing. Extract the complete application archive.
    echo ================================================================
    popd
    exit /b 2
)
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "docs\scripts\Manage-Workspace.ps1" -Action CheckOwned -Film Asteroid
if errorlevel 1 (
    echo [STOP] Cannot use the temporary workspace. Close any previous restoration and try again.
    popd
    exit /b 2
)
exit /b 0



:remux_warning
echo.
echo ================================================================
echo [STOP] Final remux completed with warnings. The output needs review.
echo ================================================================
echo The assembled video is retained at docs\temp\AsteroidCity_S.mkv
echo Details are in %RESTORER_LOG_DIRECTORY%\final-remux.log
echo Temporary work is cleared automatically when you start a new restoration.
echo You can start a new restoration after closing this run.
PAUSE
popd
exit /b 1

:remux_failed
echo.
echo ================================================================
echo [STOP] Final remux failed. Any destination output may be incomplete; do not use it.
echo ================================================================
echo The assembled video is retained at docs\temp\AsteroidCity_S.mkv
echo Details are in %RESTORER_LOG_DIRECTORY%\final-remux.log
echo Temporary work is cleared automatically when you start a new restoration.
echo You can start a new restoration after closing this run.
PAUSE
popd
exit /b 2

:output_exists
echo.
echo ================================================================
echo [STOP] a file appeared at the final output path after setup.
echo ================================================================
echo It has not been overwritten. Completed processing files and logs are retained.
echo NEXT: preserve both files and request help selecting a new output name.
echo A new restoration starts again from the beginning.
PAUSE
popd
exit /b 2
