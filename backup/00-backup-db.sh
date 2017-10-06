#!/bin/bash
# Database Backup Script
# Originator    : Mirasz

# Global
DATE=$(date +%Y%m%d%H%M)

# MySQL
AUTH="-hlocalhost -uhigienis -p0f97ad465aaa9ddc90025a5b4dd0b8d9@H"
OPT="--opt --single-transaction"
OPT1="--no-data --no-create-db --routines --triggers --events"
DB="higienis"
#DB1="indolistrik1"

# Directory & File
DIR="/data/backups/"
NAME="$DATE-$DB.sql.gz"
NAMER="$DATE-$DB-routines.sql"
#NAME1="$DATE-$DB1.sql.gz"
#NAMER1="$DATE-$DB1-routines.sql"

# Execution
mysqldump $AUTH $OPT $DB | gzip > $DIR$NAME
mysqldump $AUTH $OPT $OPT1 $DB > $DIR$NAMER
#mysqldump $AUTH $OPT $DB1 | gzip > $DIR$NAME1
#mysqldump $AUTH $OPT $OPT1 $DB1 > $DIR$NAMER1

# Clean Up
find $DIR -type f -iname '*'$DB'.sql*' -mtime +3 -exec rm {} \;
#find $DIR -type f -iname '*'$DB1'.sql*' -mtime +3 -exec rm {} \;

