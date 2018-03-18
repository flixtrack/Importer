#!/bin/bash

echo "Create Data Directory...";
mkdir -p data

echo "Fetch latest GTFS Data..."
wget -q http://data.ndovloket.nl/flixbus/flixbus-eu.zip -O ./data/flixbus-eu.zip

echo "Unpack GTFS Data..."
unzip -o ./data/flixbus-eu.zip -d ./data/

echo "Create MySQL Tables..."
cat ./sql/create.sql | mysql -u flixtrack --default-character-set=utf8 --local-infile

files=(
	agency
	calendar
	calendar_dates
	fare_attributes
	fare_rules
	feed_info
	frequencies
	routes
	stop_times
	stops
	transfers
	trips
	translations
	shapes
)

for i in ${files[@]}; do
	if [ -f "./data/${i}.txt" ]
	then
		echo "Importing ${i}..."
		cat ./sql/${i}.sql | mysql -u flixtrack --default-character-set=utf8 --local-infile
	else
		echo "Skip: ${i}.txt"
	fi
done

echo "Finished!"
