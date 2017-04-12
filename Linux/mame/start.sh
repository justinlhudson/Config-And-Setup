pkill qjoypad || true
pkill mame || true
sleep 5

qjoypad "mame" --notray &
sleep 5
mame dkong &
