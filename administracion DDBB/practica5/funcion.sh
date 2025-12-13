function dbbackup {
	DB=$1
	DBDIR=$BAK/databases
	FILENAME=$2
	mysqldump -p$DBPASS --opt $DB > $DBDIR/$DB'_'$DIA.sql
	cd $DBDIR
	tar -cjvf $FILENAME'_'$DIA'.tar.bz2' $DB'_'$DIA'.sql' 2> /tmp/backuplog > /dev/null
	rm $DBDIR/$DB'_'$DIA'.sql'
}