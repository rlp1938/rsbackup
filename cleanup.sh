#/bin/bash
# cleanup.sh - get rid of unwanted files from backup.
#

cd	# make sure I'm at $HOME


home="$HOME"/
logdir="$home"log/
lockdir="$home"lock/
logfile="$logdir"cleanup.log
lockfile="$lockdir"backup.lock

back=`ls -R /media/ 2> /dev/null |grep '/backup' |head -n1`
back=`dirname "$back"`
back="$back"/backup/

if [[ ! -d "$logdir" ]]; then
	mkdir "$logdir"
fi

if [[ ! -d "$lockdir" ]]; then
	mkdir "$lockdir"
fi


if [[ -f "$lockfile" ]]; then
	echo "Backup is already running, quitting."
	exit
fi

exec > "$logfile"	# individual log

if [[ -z "$back" ]]; then
  echo Backup drive not mounted, quitting.
  exit 1
fi

touch "$lockfile"
sync

excl="$home"excludes

date
echo home "$home"
echo back "$back"

sleep 2

rsync -av --del --links --hard-links --exclude-from="$excl" \
"$home" "$back"

rm "$lockfile"
date
echo --------
echo ' '

