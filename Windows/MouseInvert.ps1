### Invert Mouse like OSX ###

# Powershell:
Get-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Enum\HID\*\*\Device` Parameters FlipFlopWheel -EA 0 | ForEach-Object { Set-ItemProperty $_.PSPath FlipFlopWheel 1 }

# regedit.exe
# HKEY_LOCAL_MACHINE/SYSTEM/CurrentControlSet/Enum/HID/<Hardware ID>/Device Parameters
# FlipFlopWheel from 0 to 1