#!/bin/bash
# Includo variabili utente oracle
. /home/oracle/.bash_profile

# Imposto data
DATE=$(date +%d%m%y-%H%M%S)

# Trovo i sid delle istanze running
DB=$(ps ax|grep pmon|sed 's/.*_//'|grep -v "pmon")

# Eseguo il backup ARCHIVE delle istanze running
for SID in $DB
do
	ORACLE_SID=$SID; export ORACLE_SID
	rman target / catalog rman/rman@rman cmdfile '/backup/scripts/stored_script/global_arc_no_comp' log /backup/logs/$ORACLE_SID/$ORACLE_SID.ARC.$DATE.log
	grep ERROR /backup/logs/$ORACLE_SID/$ORACLE_SID.ARC.$DATE.log
		if [ "$?" -eq "0" ]
		then
			cat /backup/logs/$ORACLE_SID/$ORACLE_SID.ARC.$DATE.log | mail -s "ARCHIVELOGS BACKUP ERROR - $HOSTNAME - DB: $ORACLE_SID" alessandro.greganti@unito.it
		else
			cat /backup/logs/$ORACLE_SID/$ORACLE_SID.ARC.$DATE.log | mail -s "ARCHIVELOGS BACKUP SUCCEDED - $HOSTNAME - DB: $ORACLE_SID" alessandro.greganti@unito.it
		fi
done
