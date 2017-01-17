module Organizers::Events::ConferencesHelper
  GooglePattern = /(docs.google.com\/presentation\/d\/\w+)/i
  def presentation_url(conference)
    case
    when conference.embedded_url.match(GooglePattern)
      url = "https://#{$1}/embed?start=true&loop=false&delayms=100000&micefySignal=start&micefyId=#{conference.id}&micefyHash=#{conference.security_hash}"
      url += "&micefyDev=true" if Rails.env.development?
      url
    else
      conference.embedded_url
    end
  end
end
