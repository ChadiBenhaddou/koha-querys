#!/bin/bash


# MySQL connection details
DB_USER="root"
DB_PASS="pas123//"
DB_NAME="koha_library"


# Query the database to get the new biblionumbers (you can modify the WHERE clause)
biblionumbers=$(mysql -u $DB_USER -p$DB_PASS -D $DB_NAME -se "SELECT biblionumber from koha_library.aqorders a WHERE a.basketno = 12449;")


# Loop through each biblionumber and rebuild the Zebra index for it
for biblionumber in $biblionumbers; do
    echo "Indexing biblionumber: $biblionumber"
    sudo koha-rebuild-zebra --selective --biblionumber=$biblionumber library
done
