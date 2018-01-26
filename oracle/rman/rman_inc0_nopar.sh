#!/bin/bash
# Includo variabili utente oracle
. /home/oracle/.bash_profile

# Imposto data
DATE=$(date +%d%m%y-%H%M%S)

# Trovo i sid delle istanze running
DB=$(ps ax|grep pmon|sed 's/.*_//'|grep -v "pmon")

# Eseguo il backup INCREMENTALE LEVEL 0 (FULL) delle istanze running
for SID in $DB
do
	ORACLE_SID=$SID; export ORACLE_SID
	rman target / catalog rman/rman@rman script 'global_inc0_comp_nopar' log /backup/logs/$ORACLE_SID/$ORACLE_SID.INC0.$DATE.log
	grep ERROR /backup/logs/$ORACLE_SID/$ORACLE_SID.INC0.$DATE.log
		if [ "$?" -eq "0" ]
		then
			cat /backup/logs/$ORACLE_SID/$ORACLE_SID.INC0.$DATE.log | mail -s "FULL BACKUP ERROR - $HOSTNAME - DB: $ORACLE_SID" alessandro.greganti@unito.it
		else
			cat /backup/logs/$ORACLE_SID/$ORACLE_SID.INC0.$DATE.log | mail -s "FULL BACKUP SUCCEDED - $HOSTNAME - DB: $ORACLE_SID" alessandro.greganti@unito.it
		fi
done
