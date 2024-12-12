#!/bin/bash

DB_USER='root'
DB_PASSWORD='%vU9OGA8$^TmI!Ot'
DB_HOST='localhost'
DB_NAME='proman'

mysql -u $DB_USER -p$DB_PASSWORD -h $DB_HOST -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"

mysql -u $DB_USER -p$DB_PASSWORD -h $DB_HOST $DB_NAME < migrate.sql
mysql -u $DB_USER -p$DB_PASSWORD -h $DB_HOST $DB_NAME < seed.sql
