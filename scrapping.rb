require 'rubygems'
require 'nokogiri'
require 'open-uri'
require "google_drive"

# URL de base
PAGE_URL = "http://annuaire-des-mairies.com/val-d-oise.html"

# Array vide pour pouvoir préparer le hash
TABLE = []

def get_all_the_urls_of_val_doise_townhalls

  begin

  page = Nokogiri::HTML(open(PAGE_URL))
  links = page.css(".lientxt")

  # On ouvre les liens de chaque ville pour aller chercher l'email
  links.each do |link|
    get_the_email_of_a_townhal_from_its_webpage(link['href'])
  end
  session = GoogleDrive::Session.from_config("config,json")
  # On prépapre la spreadsheet avec deux colonnes
  worksheet = session.spreadsheet_by_key("").worksheets[0]

  worksheet[1, 1] = "Mairie"
  worksheet[1, 2] = "Email"

  TABLE.each do |col|
    worksheet.insert_rows(2, [col.values])
  end

  worksheet.save

  puts "============================================================================================="
  puts "Liste envoyée dans la spreadsheet"

  rescue => e
    puts "Exception Class: #{ e.class.name }"
    puts "Exception Message: #{ e.message }"
    puts "Exception Backtrace: #{ e.backtrace }"
  end
  
end

def get_the_email_of_a_townhal_from_its_webpage(url)

  begin

  page = Nokogiri::HTML(open("http://annuaire-des-mairies.com/" + url))

  elements = page.css('td p font')

  city = page.css(".lientitre")

  city_name = city[0].text

  elements.each do |el|
    if el.text.include?('@')
      TABLE << {:ville => city_name.downcase.capitalize, :email => el.text}
      puts "#{city_name.downcase.capitalize} Contact: #{el.text}"
    end
  end

  rescue => e
    puts "Exception Class: #{ e.class.name }"
    puts "Exception Message: #{ e.message }"
    puts "Exception Backtrace: #{ e.backtrace }"
  end

end

get_all_the_urls_of_val_doise_townhalls
