# osm-import-atx-public-art

This repository is a script that converts the City of Austin "public art"
dataset into OSM form for Open Street Map import.

Usage:

  ruby generate.rb > City_of_Austin_Public_Art_Collection.osm


## Status

This script generates a data file that loads without error into the JOSM
applicaton. <https://josm.openstreetmap.de/>

It's not clear this is sufficient to complete the data import, but it
does successfully process the content from the city dataset.


## Issues

  * Do I need to generate a <bounds> element?
  * For the <node> element, what do I generate for @id and @version?
  * For the <node> element, do I need to generate anything for @changeset, @user, @uid, or @timestamp?
  * Review the <tag> elements for correctness.
  * This script generates multiple "image" tags, but only one is supported.
  * Need to figure out the rest of the import process.
  * This is blocked by city publication of its data terms of use.


## References

  * dataset URL <https://data.austintexas.gov/Fun/City-of-Austin-Public-Art-Collection/yqxj-7evp>
  * CSV download URL <https://data.austintexas.gov/api/views/yqxj-7evp/rows.csv>

