require 'csv'
require 'rexml/document'
include REXML  # so that we don't have to prefix everything with REXML::...
require 'time'

SOURCE = "City_of_Austin_Public_Art_Collection.csv"

SOURCE_URL = "https://data.austintexas.gov/Fun/City-of-Austin-Public-Art-Collection/yqxj-7evp"

@id = 0

@doc = Document.new('<?xml version="1.0" encoding="UTF-8"?>')

@osm = Element.new("osm")
@osm.add_attributes(
  "version" => "0.6" ,
  #"generator" => "custom",
)
@doc << @osm

#e = Element.new("bounds")
#e.add_attributes(
#  "minlat" => 0,
#  "minlon" => 0,
#  "maxlat" => 0,
#  "maxlon" => 0,
#)
#osm << e

open(SOURCE) do |io|

  # Cols:
  #  * Artist Full Name
  #  * Art Title
  #  * Art Location Name
  #  * Art Location Street Address
  #  * Art Location City
  #  * Art Location State
  #  * Art Location Zip
  #  * Images
  #  * Web Detail Page
  #  * Location
  #
  CSV.foreach(io, :headers => true) do |row|

    # Example "Location" field:
    #
    #   5th Street and Sabine Street;
    #   Austin, TX 78701
    #   (30.265255505104278, -97.73647200312456)
    #
    m = /.*\((.*), (.*)\)$/.match(row["Location"])
    raise "cannot parse location: #{row['Location']}" unless m
    lat = m[1]
    lng = m[2]

    node = Element.new("node")
    node.add_attributes(
      "id" => @id+=1,
      "version" => "1", # XXX
      #"changeset" => "0", # XXX
      "lat" => lat,
      "lon" => lng,
      #"user" => USERNAME,
      #"uid" => USERID,
      "visible" => "true",
      #"timestamp" => TIMESTAMP,
    )
    @osm << node

    def node.add_tag(k, v)
      tag = Element.new("tag")
      tag.add_attributes("k" => k, "v" => v)
      self << tag
    end

    node.add_tag("amenity", "artwork")
    node.add_tag("tourism", "artwork")
    node.add_tag("name", row["Art Title"])
    node.add_tag("artist_name", row["Artist Full Name"])
    #node.add_tag("artwork_type", ???)
    #node.add_tag("material", ???)
    node.add_tag("url", row["Web Detail Page"])
    row["Images"].split(/;/).each do |url|
      node.add_tag("image", url)
    end
    node.add_tag("source_ref", SOURCE_URL)

  end
end

@doc.write($stdout, 2)

