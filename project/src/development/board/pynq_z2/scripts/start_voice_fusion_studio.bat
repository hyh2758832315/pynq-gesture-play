@echo off
setlocal
set "STUDIO_ROOT=%~dp0"
if exist "%~dp0..\..\..\pyproject.toml" set "STUDIO_ROOT=%~dp0..\..\..\"
cd /d "%STUDIO_ROOT%"
if not exist ".venv\Scripts\python.exe" goto missing_python
set "PYTHONPATH=%CD%\python;%PYTHONPATH%"
".venv\Scripts\python.exe" -B -m pynq_multimodal_game.studio.app --agent-build-id 0xC0060900 %*
exit /b %errorlevel%

:missing_python
echo Candidate Studio requires a local .venv with PySide6 and numpy.
echo Create the environment and install the Studio and audio dependencies first.
exit /b 1