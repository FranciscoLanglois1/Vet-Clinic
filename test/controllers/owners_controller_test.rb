require "test_helper"

class OwnersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @owner = owners(:one)
  end

  test "should get index" do
    get owners_url
    assert_response :success
  end

  test "should get show" do
    get owner_url(@owner)
    assert_response :success
  end

  test "should create owner with valid params" do
    assert_difference("Owner.count", 1) do
      post owners_url, params: {
        owner: {
          first_name: "New",
          last_name: "Owner",
          email: "new@example.com",
          phone: "999-888-7777",
          address: "New Address 123"
        }
      }
    end
    assert_redirected_to owner_url(Owner.last)
    assert_equal "The owner has been created correctly", flash[:notice]
  end

  test "should not create owner with invalid params" do
    assert_no_difference("Owner.count") do
      post owners_url, params: {
        owner: {
          first_name: "",
          last_name: "",
          email: "invalid",
          phone: "",
          address: ""
        }
      }
    end
    assert_response :unprocessable_entity
  end

  test "should update owner with valid params" do
    patch owner_url(@owner), params: {
      owner: {
        first_name: "Updated Name"
      }
    }
    assert_redirected_to owner_url(@owner)
    assert_equal "The owner has been updated correctly", flash[:notice]
    @owner.reload
    assert_equal "Updated Name", @owner.first_name
  end

  test "should destroy owner" do
    assert_difference("Owner.count", -1) do
      delete owner_url(@owner)
    end
    assert_redirected_to owners_url
    assert_equal "The owner has been deleted correctly", flash[:notice]
  end
end