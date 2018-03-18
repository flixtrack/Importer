# Importer
![flixtrack](https://avatars2.githubusercontent.com/u/37507138?s=60&v=4) Import GTFS Data to MySQL for database usage.

# Structure
![Preview](preview.png?v2)

# Usage
- Upload the importer to your server.
- Change file permissions `chmod 777 import.sh` 
- Execute the importer `./import.sh`
- **Additional:** Create a cronjob for the exporter

# Important
If you wan't to use another GTFS source, you must edit the `URL` from `./import.sh`!

By default, `flixtrack` database and username will be used. You must edit these in all files, if you're wan't to import the data to another database.

By the future, a configuration file will be added.
