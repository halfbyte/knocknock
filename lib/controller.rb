require 'open-uri'
require 'json'
class Controller
  attr_accessor :interval, :endpoint
  
  def initialize(endpoint, interval)
    @interval = interval
    @endpoint = endpoint
    run
  end
  
  def run
    loop do
      process
      wait
    end
  end

  def process
    results = parse(open(@endpoint)).map do |entry|
      puts entry
      Pinger.new(entry).to_hash
    end
    post_results(results)
  end

  def post_results(pinger)
    answer = JSON.generate("results" => pinger, 'ticket_id' => @current_ticket_id)
  end
  
  def parse(file)
    json_structure = JSON.load(file)
    @current_ticket_id = json_structure['ticket_id']
    return json_structure['tasks']
  end
  
  def wait
    sleep @interval
  end
  
end
