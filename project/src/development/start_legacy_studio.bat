@echo off
setlocal
cd /d "%~dp0"

if not exist "%~dp0.venv\Scripts\python.exe" goto missing_python
set "PYTHONPATH=%~dp0python;%PYTHONPATH%"
if defined VOICE_VIEW_GAME_PROJECTS_ROOT goto launch_studio
set "VOICE_VIEW_GAME_PROJECTS_ROOT=%~dp0games_gesture"
"%~dp0.venv\Scripts\python.exe" -B "%~dp0subprojects\ps_ui_r23b2\tools\prepare_studio_projects.py" --output "%VOICE_VIEW_GAME_PROJECTS_ROOT%"
if errorlevel 1 goto project_prepare_failed
:launch_studio
"%~dp0.venv\Scripts\python.exe" -B -m pynq_multimodal_game.studio.app --agent-host 192.168.2.99 --agent-build-id 0xC0061000 --agent-source-address 192.168.2.1 %*
set "studio_exit_code=%errorlevel%"
if not "%studio_exit_code%"=="0" (
    echo.
    echo Studio failed to start. Exit code: %studio_exit_code%
    pause
)
exit /b %studio_exit_code%

:project_prepare_failed
echo R23 gesture projects could not be prepared. Existing projects were preserved.
pause
exit /b 1

:missing_python
echo Project Python environment was not found.
echo Expected: "%~dp0.venv\Scripts\python.exe"
echo Create the environment and install the Studio dependencies first.
pause
exit /b 1
