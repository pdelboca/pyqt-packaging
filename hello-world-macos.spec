# -*- mode: python ; coding: utf-8 -*-
# This file was generated in a macos machine on Github Actions by executing the following command:
# pyinstaller --onefile --name HelloWorld.app --add-data "icons:icons" --icon icons/icon.icns --windowed app.py
# 
# MacOS requires a --onefile execution or else notarize process will fail.

a = Analysis(
    ['app.py'],
    pathex=[],
    binaries=[],
    datas=[('icons', 'icons')],
    hiddenimports=[],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    noarchive=False,
    optimize=0,
)
pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.datas,
    [],
    name='HelloWorld.app',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=False,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
    icon=['icons/icon.icns'],
)
app = BUNDLE(
    exe,
    name='HelloWorld.app.app',
    icon='icons/icon.icns',
    bundle_identifier=None,
)
