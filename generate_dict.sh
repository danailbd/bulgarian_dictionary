#!/usr/bin/sh

# TODO ADD OPTIONS
ROOTPWD=${2:-""}
TMPPATH=${3-"/tmp"}
TMP_DATABASE_NAME=${4:-"rechko"}

# TODO ADD REQUIREMENTS
# * pv, penelope, kindlegen
# * mysql with root 

# TODO ensure dependences
# pv, penelope, kindlgen
# pip install --user penelope
# yaourt -S kindlegen

echo "Downloading file"
wget -P $TMPPATH/ https://rechnik.chitanka.info/db.sql.gz 

echo "Extracting file"
gzip -d -v $TMPPATH/db.sql.gz

# TODO ensure permissions for import mysql
echo "PREPARE DATABASE. This might take a while..."
sed -i "1s/^/CREATE DATABASE IF NOT EXISTS ${TMP_DATABASE_NAME};\nuse ${TMP_DATABASE_NAME};\n/" $TMPPATH/db.sql
pv $TMPPATH/db.sql | mysql -u root --password=$ROOTPWD

echo "EXTRACT dict.csv"
mysql -u root --password=$ROOTPWD < ../lib/formatter.sql | sed 's/\t/,/g' > $TMPPATH/dict.csv

echo "GENERATE DICT"
penelope --description "Bulgarian Dictionary" -i $TMPPATH/dict.csv -j csv -f bg -t bg -p mobi -o dict.mobi

echo "CLEAR TEMP DATA"
rm $TMPPATH/db.sql $TMPPATH/dict.csv
mysql -u root --password=$ROOTPWD <<<"DROP DATABASE $TMP_DATABASE_NAME;"
