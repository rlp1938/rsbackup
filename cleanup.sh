#/bin/bash
# cleanup.sh - get rid of unwanted files from backup.
#

cd

if [[ "$BACKUP_RUNNING" -eq 1 ]]; then
	echo "Backup is running, try again later."
	exit	# quit
fi
export BACKUP_RUNNING=1

home="$HOME"/
#echo home "$home"
exec > "$home"cleanup.log

back=`ls -R /media/ 2> /dev/null |grep '/backup' |head -n1`

#echo back "$back"
if [[ -z "$back" ]]; then
  echo Backup drive not mounted, quitting.
  exit 1
fi
back=`dirname "$back"`
back="$back"/backup/
#echo back2 "$back"

tmpcruft='/tmp/cruft'
cruft="$home"cruft
excl="$home"excludes

date
echo home "$home"
echo back "$back"
echo tmpcruft "$tmpcruft"
echo cruft "$cruft"

sleep 2

rsync -av --del --links --hard-links --exclude-from="$excl" "$home" "$back"

unset BACKUP_RUNNING
