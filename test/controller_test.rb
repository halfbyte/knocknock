require 'test_helper'
require 'controller'
require 'pinger'

class ControllerTest < Test::Unit::TestCase
  def test_initialize_should_call_run
    Controller.any_instance.expects(:run)
    c = Controller.new('http://example.com', 200)
  end
  
  def test_initialize_should_set_instance_vars
    Controller.any_instance.stubs(:run)
    c = Controller.new('http://example.com', 200)
    assert_equal c.endpoint, 'http://example.com'
    assert_equal c.interval, 200
  end
  
  def test_parse_should_return_array
    Controller.any_instance.stubs(:run)
    c = Controller.new('http://example.com', 200)
    assert c.parse(File.open(File.join(File.dirname(__FILE__), 'fixtures', 'example_list.json'))).is_a?(Array)
  end
  
  def test_parse_should_return_correct_fields_in_array_members
    Controller.any_instance.stubs(:run)
    c = Controller.new('http://example.com', 200)
    member = c.parse(File.open(File.join(File.dirname(__FILE__), 'fixtures', 'example_list.json'))).first
    assert_equal 'http://example.com/', member['url']
    assert_equal 'get', member['method']
    assert_equal({'response_code' => 200, 'message' => '/OK/'}, member['acceptance_criteria'])
  end
  
  def test_should_post_results_for_entry
    Controller.any_instance.stubs(:run)
    Controller.any_instance.stubs(:open).returns(File.open(File.join(File.dirname(__FILE__), 'fixtures', 'example_list.json')))
    c = Controller.new('http://example.com/', 200)
    c.expects(:post_results).with([{}])
    Pinger.expects(:new).once.returns({})
    c.process
  end
  
  def test_should_initialize_pinger_for_entry
    Controller.any_instance.stubs(:run)
    Controller.any_instance.stubs(:open).returns(File.open(File.join(File.dirname(__FILE__), 'fixtures', 'example_list.json')))
    c = Controller.new('http://example.com/', 200)
    #c.stubs(:post_results)    
    Pinger.expects(:new).once.returns({})
    c.process
  end
  
  
  
end
