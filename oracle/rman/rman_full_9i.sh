#!/bin/bash
# Includo variabili utente oracle
. /home/oracle/.bash_profile

# Imposto data
DATE=$(date +%d%m%y-%H%M%S)

# Trovo i sid delle istanze running
DB=$(ps ax|grep pmon|sed 's/.*_//'|grep -v "pmon")

# Eseguo il backup FULL delle istanze running
for SID in $DB
do
	ORACLE_SID=$SID; export ORACLE_SID
	rman target / catalog rman/rman@rman cmdfile '/backup/scripts/stored_script/global_full_no_comp' log /backup/logs/$ORACLE_SID/$ORACLE_SID.FULL.$DATE.log
	grep ERROR /backup/logs/$ORACLE_SID/$ORACLE_SID.FULL.$DATE.log
		if [ "$?" -eq "0" ]
		then
			cat /backup/logs/$ORACLE_SID/$ORACLE_SID.FULL.$DATE.log | mail -s "FULL BACKUP ERROR - $HOSTNAME - DB: $ORACLE_SID" MAIL_ADDRESS
		else
			cat /backup/logs/$ORACLE_SID/$ORACLE_SID.FULL.$DATE.log | mail -s "FULL BACKUP SUCCEDED - $HOSTNAME - DB: $ORACLE_SID" MAIL_ADDRESS
		fi
done
