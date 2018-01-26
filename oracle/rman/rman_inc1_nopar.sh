#!/bin/bash
# Includo variabili utente oracle
. /home/oracle/.bash_profile

# Imposto data
DATE=$(date +%d%m%y-%H%M%S)

# Trovo i sid delle istanze running
DB=$(ps ax|grep pmon|sed 's/.*_//'|grep -v "pmon")

# Eseguo il backup INCREMENTALE LEVEL 1 delle istanze running
for SID in $DB
do
	ORACLE_SID=$SID; export ORACLE_SID
	rman target / catalog rman/rman@rman script 'global_inc1_comp_nopar' log /backup/logs/$ORACLE_SID/$ORACLE_SID.INC1.$DATE.log
	grep ERROR /backup/logs/$ORACLE_SID/$ORACLE_SID.INC1.$DATE.log
		if [ "$?" -eq "0" ]
		then
			cat /backup/logs/$ORACLE_SID/$ORACLE_SID.INC1.$DATE.log | mail -s "INCREMENTAL BACKUP ERROR - $HOSTNAME - DB: $ORACLE_SID" MAIL_ADDRESS
		else
			cat /backup/logs/$ORACLE_SID/$ORACLE_SID.INC1.$DATE.log | mail -s "INCREMENTAL BACKUP SUCCEDED - $HOSTNAME - DB: $ORACLE_SID" MAIL_ADDRESS
		fi
done
