require "test_helper"

class VetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @vet = vets(:one)
  end

  test "should get index" do
    get vets_url
    assert_response :success
  end

  test "should get show" do
    get vet_url(@vet)
    assert_response :success
  end

  test "should create vet with valid params" do
    assert_difference("Vet.count", 1) do
      post vets_url, params: {
        vet: {
          first_name: "New",
          last_name: "Vet",
          email: "newvet@example.com",
          phone: "777-888-9999",
          specialization: "Dentistry"
        }
      }
    end
    assert_redirected_to vet_url(Vet.last)
    assert_equal "The vet has been created correctly", flash[:notice]
  end

  test "should not create vet with invalid params" do
    assert_no_difference("Vet.count") do
      post vets_url, params: {
        vet: {
          first_name: "",
          last_name: "",
          email: "invalid",
          phone: "",
          specialization: ""
        }
      }
    end
    assert_response :unprocessable_entity
  end

  test "should update vet with valid params" do
    patch vet_url(@vet), params: {
      vet: {
        first_name: "Updated Name"
      }
    }
    assert_redirected_to vet_url(@vet)
    assert_equal "The vet has been updated correctly", flash[:notice]
    @vet.reload
    assert_equal "Updated Name", @vet.first_name
  end

  test "should destroy vet" do
    assert_difference("Vet.count", -1) do
      delete vet_url(@vet)
    end
    assert_redirected_to vets_url
    assert_equal "The vet has been deleted correctly", flash[:notice]
  end
end