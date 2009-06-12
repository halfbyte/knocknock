require 'lib/pinger'



pinger = Pinger.new(
  :url => 'http://jan.krutisch.de/',
  :method => :get,
  :response_criteria => {
    :message => /OK/
  }
)
puts pinger.response_code
puts pinger.time
puts pinger.success?
