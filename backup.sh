#/bin/bash
# backup.sh - another try at making an effective backup.
#

# TODO: Insert some strategy to remove all files in /Downloads, maybe
# with an option to turn the deletions off for when some large d/l is
# in progress.

cd	# make sure I'm at $HOME


home="$HOME"/
logdir="$home"log/
lockdir="$home"lock/
logfile="$logdir"backup.log
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

exec >> "$logfile"	# cumulative log

if [[ -z "$back" ]]; then
  echo Backup drive not mounted, quitting.
  exit 1
fi

touch "$lockfile"
sync

tmpcruft='/tmp/cruft'
cruft="$home"cruft
excl="$home"excludes

date
echo home "$home"
echo back "$back"
echo tmpcruft "$tmpcruft"
echo cruft "$cruft"

sleep 2

# I don't use the --del option because I don't want to accidently make
# holes in the backup set in the event that I delete a file by mistake.

rsync -av --links --hard-links --exclude-from="$excl" "$home" "$back"

# Now I want to get control of stuff that should be deleted from the
# backup but without putting myself at risk of propagating a 'hole' into
# the backup, eg when some file is accidentally deleted.
# But NB I will take a chance on propagating a hole from the dot dirs in
# $HOME

# However this part here gives me a list of what would be deleted if I
# used the --del option. I review that list and then run 'cleanup.sh'
# which does use the --del option without the --dry-run option.

exec > "$tmpcruft"
rsync -av --dry-run --del --links --hard-links --exclude-from="$excl" \
"$home" "$back"

exec > "$cruft"

# the grep gets rid of everything except the 'deleting' notifications.
grep '^deleting' "$tmpcruft"

rm "$tmpcruft"

# I run 'cleanup.sh' a lot less often than I run 'backup.sh'

rm "$lockfile"
date
echo -----
echo ' '

