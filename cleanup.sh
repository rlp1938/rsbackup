#/bin/bash
# cleanup.sh - get rid of unwanted files from backup.
#


home="$HOME"

exec > "$home"cleanup.log

back=`ls -R /media/ 2> /dev/null |grep '/backup/' |head -n1`
excl="$home"excludes

if [[ -z "$back" ]]; then
  echo Backup drive not mounted, quitting.
  exit 1
fi

back=`dirname "$back"`
back=`echo "$back"'/'`

rsync -av --del --links --hard-links --exclude-from="$excl" "$home" "$back"
