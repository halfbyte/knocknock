require 'test_helper'
require 'pinger'


class Ping < Test::Unit::TestCase
  
  def setup
    @common_options = {'method' => 'get', "url" => 'http://example.com/'}
    @mock_response = mock('response')
    @mock_response.stubs(:code).returns('200')
    @mock_response.stubs(:message).returns('OK')
    @mock_response.stubs(:body).returns('yaddayadda')
    @mock_response.stubs(:is_a?).returns(true)
  end
        
  def test_success_should_return_true_if_response_is_successful_and_no_more_criteria_given
    Net::HTTP.expects(:start).returns(@mock_response)
    @mock_response.expects(:is_a?).with(Net::HTTPSuccess).returns(true)
    p = Pinger.new(@common_options)
    assert p.success?
  end

  def test_success_should_return_false_if_response_is_not_successful_and_no_more_criteria_given
    Net::HTTP.expects(:start).returns(@mock_response)
    @mock_response.expects(:is_a?).with(Net::HTTPSuccess).returns(false)
    p = Pinger.new(@common_options)
    assert !p.success?
  end
  
  def test_success_for_response_code_criterium
    Net::HTTP.expects(:start).returns(@mock_response)
    @mock_response.expects(:code).returns('202')
    p = Pinger.new(@common_options.merge({"success_criteria" => {"response_code" => 202 }}))
    assert p.success?
  end

  def test_success_for_message_criterium
    Net::HTTP.expects(:start).returns(@mock_response)
    @mock_response.expects(:message).returns('ORLY?')
    p = Pinger.new(@common_options.merge({"success_criteria" => {"message" => 'ORLY?' }}))
    assert p.success?
  end

  def test_success_for_message_criterium_with_regexp
    Net::HTTP.expects(:start).returns(@mock_response)
    @mock_response.expects(:message).returns('ORLY?WTF')
    p = Pinger.new(@common_options.merge({"success_criteria" => {"message" => '/ORLY/' }}))
    assert p.success?
  end

  def test_should_return_message
    Net::HTTP.expects(:start).returns(@mock_response)
    p = Pinger.new(@common_options)
    assert_equal 'OK', p.message    
  end

  def test_should_return_response_code
    Net::HTTP.expects(:start).returns(@mock_response)
    p = Pinger.new(@common_options)
    assert_equal '200', p.response_code 
  end
  
  def test_should_return_time
    Net::HTTP.expects(:start).returns(@mock_response)
    p = Pinger.new(@common_options)
    assert_not_nil p.time
  end  
end