# puts files 1 level deep into dated folders for so many days.

_location=$1
_days=$2

# delete if older then
find "$_location"/* -type f -mtime +$_days -delete
# delete directory if empty
find "$_location"/* -type d -empty -delete

# Move files into date folders (Note: 1 level deep)
for _directory in $(find "$_location" -maxdepth 1 -type d); do
  echo $_directory
  # Note: skip hidden files
  for _file in $(find "$_directory" -maxdepth 1 -type f | grep -v '/\.'); do
    _date=$(date -r "$_file" +%Y_%m_%d)
    _new="$_directory"/"$_date"

     echo "$_file -> $_new"

    mkdir -p $_new
    mv $_file $_new
  done
done
