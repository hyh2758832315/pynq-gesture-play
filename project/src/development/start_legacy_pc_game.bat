@echo off
setlocal
cd /d "%~dp0"
set "PYTHONPATH=%CD%\python"
python -m pynq_multimodal_game.demo
if errorlevel 1 (
    echo.
    echo 游戏未能启动。请确认已安装 Python 并在项目目录执行依赖安装。
    pause
)