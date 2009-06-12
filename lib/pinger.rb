require 'net/http'

class Pinger
  
  attr_reader :response, :time
  
  def initialize(options)
    @url = options[:url]
    @uri = URI.parse(@url)
    @method = options[:method] || :get
    @success_criteria = options[:success_criteria]
    ping
  end
  
  def ping
    @time = stopwatch do
      @response = Net::HTTP.start(@uri.host, @uri.port) {|http|
        http.send(@method, @uri.path + (@uri.query ? "?#{url.query}" : ""))
      }
    end
  end
  
  def stopwatch(&block)
    t = Time.now
      block.call
    ((Time.now - t) * 1000).to_i
  end
  
  def success?
    if @success_criteria
      return @success_criteria.map{ 
        |key, value| check_for(key, value)
      }.inject(true){ 
        |truth, element| truth && element 
      }
    else
      return true if @response.is_a?(Net::HTTPSuccess)
    end
    return false
  end
  
  def check_for(name, criteria)
    case(name)
    when :response_code, :message
      compare(send(name), criteria)
    else
      true
    end
  end
  
  def compare(value, criteria)
    case(criteria)
    when Regexp
      return criteria.match(value)
    when String
      return criteria == value
    else
      return criteria.to_s == value
    end
  end
  
  def response_code
    @response.code
  end
  
  def message
    @response.message
  end
  def body
    @response.body
  end
  
end
