if ! type nvidia-settings > /dev/null; then
  # loads: ~/.nvidia-settings-rc , create by hand or running nvidia-settings (GUI config, or console)
  nvidia-settings --load-config-only &
if

# Carry-on as normal now...
. /etc/X11/xinit/xinitrc
