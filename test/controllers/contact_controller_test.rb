require 'test_helper'

class ContactControllerTest < ActionDispatch::IntegrationTest
  test "should get send" do
    get contact_send_url
    assert_response :success
  end

end
