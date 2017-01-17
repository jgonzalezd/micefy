#encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#

if Rails.env.development? || Rails.env.staging?
  # Clean up models
  Event.delete_all #should delete Conferences, conferences should delete questions, slides, notes, but this behavior will change to not allow destroy past events.
  Lecturer.delete_all
  Location.delete_all
  User.delete_all
  Organizer.delete_all
  Indication.delete_all
  EventCode.delete_all
  Slide.delete_all
  Vote.delete_all
  Admin.delete_all
  City.delete_all
  Conference.delete_all
end

password = "tacos123!."

[
  {email: "brayancastrop@gmail.com", password: password},
  {email: "jgonzalezd.sist@gmail.com", password: password}
].each do |attributes|
  Admin.create attributes
end


time = Time.new(2014, 8, 21)
countries = Country.arel_table
Country.where(countries[:created_at].lt(time)).destroy_all
locale = "es"
country_locale = YAML.load(File.open(Rails.root.join('config', 'locales',  "countries.#{locale}.yml")))
country_locale[locale]["countries"].each do |code, name|
  Country.find_or_create_by :"code" => code, name: name
end

=begin
tags = [
  {name: "web"},
  {name: "development"},
  {name: "javascript"},
  {name: "developer"},
  {name: "scrum"},
  {name: "ruby"},
  {name: "rails"},
  {name: "scala"},
  {name: "grunt"},
  {name: "sinatra"}
].each do |attributes|
  ActsAsTaggableOn::Tag.find_or_create_by(attributes)
end
=end


=begin
if Rails.env.development? || Rails.env.staging?
  # Clean up models
  Event.delete_all #should delete Conferences, conferences should delete questions, slides, notes, but this behavior will change to not allow destroy past events.
  Lecturer.delete_all
  Location.delete_all
  User.delete_all
  Organizer.delete_all
  Indication.delete_all


  # Clean uploaded files
  # TODO: Remove files uploaded with carrierwave

  # Create Atendee
   user = User.new(
        :email                 => "testuser@email.com",
        :name                  => "testuser",
        :password              => "password",
        :password_confirmation => "password"
    )
    #user.skip_confirmation!
    user.save!

  #Create Event Organizer
    organizer = Organizer.new(
        :email                 => "testorganizer@email.com",
        :company_name          => "CIDEU-Centro Iberoamericano de Desarrollo Estratégico Urbano",
        :password              => "password",
        :password_confirmation => "password"
    )
    #user.skip_confirmation!
    organizer.save!


  #TODO: Use cities file to seed cities table.

  #Dir.foreach(Dir.pwd+"/db/seed_files/events/") do |item|
  #  if item.end_with?('.yml')
      seed_events = YAML::load_file(Dir.pwd+"/db/seed_files/events/events.yml")
        seed_events.each do |index, data|
          event = Event.new
          event.name = data["name"]

          event.logo = EventLogoUploader.new
          event.logo = File.open(Dir.pwd+"/db/seed_files/events/"+data["logo"])
          #event.logo.store!

          event.description = data["description"]
          event.city = City.find_or_create_by(name: data["city"])

          event.map_picture = EventLogoUploader.new
          event.map_picture = File.open(Dir.pwd+"/db/seed_files/events/"+data["map"])
          #event.map_picture.store!

          data["locations"].each do |index, location|
            event.locations << Location.find_or_create_by(name: location["name"], address: location["address"])
          end

          event.start_at = DateTime.strptime(data["start_date"], '%d-%m-%Y %I:%M %p')
          event.end_at = DateTime.strptime(data["end_date"], '%d-%m-%Y %I:%M %p')

          data["indications"].each do |index, indication|
            event.indications << Indication.create!(content: indication["description"], kind: indication["kind"])
          end

          # TODO: Add presentations (s)?
          data["conferences"].each do |index, conference|
            conference_object = Conference.new(name: conference["name"], description: conference["description"])
            conference_object.start_at = DateTime.strptime(conference["start_date"], '%d-%m-%Y %I:%M %p')
            conference_object.end_at = DateTime.strptime(conference["end_date"], '%d-%m-%Y %I:%M %p')
            conference_object.archived = conference["archived"]
            conference_location_name = data["locations"][conference["location"]]["name"]
            conference_object.location = Location.find_by(name: conference_location_name)
            conference["lecturers"].each do |index|
              data["lecturers"][index]
              object_lecturer = Lecturer.new(name: data["lecturers"][index]["name"], description: data["lecturers"][index]["description"], linkedin_url: data["lecturers"][index]["linkedin"])
              object_lecturer.country = Country.find_or_create_by(name: data["lecturers"][index]["country"]) unless data["lecturers"][index]["country"].empty?
              conference_object.lecturers << object_lecturer
            end
            event.conferences << conference_object
          end
          event.organizer = organizer
          event.save!
      end
  #  end
  #end
end
=end

puts "Your database has been seeded correctly"
