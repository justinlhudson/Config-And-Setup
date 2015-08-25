# give sudo to user or apps

sudo visudo

<usr> ALL=NOPASSWD: /usr/bin/application

# logging system operations

tail -f /var/log/syslog


# move files into dated folders
DatedFileFolder()
{
  for x in *.jpg; do
    d=$(date -r "$x" +%Y-%m-%d)
    mkdir -p "$d"
    mv -- "$x" "$d/"
  done
}

#cd Temp
#DatedFileFolder
#cd ..