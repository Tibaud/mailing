require 'rubygems'
require 'nokogiri'
require 'open-uri'
require "google_drive"

session = GoogleDrive::Session.from_config("config.json")
worksheet = session.spreadsheet_by_key("").worksheets[0]
