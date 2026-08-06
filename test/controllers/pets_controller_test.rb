require "test_helper"

class PetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pet = pets(:one)
  end

  test "should get index" do
    get pets_url
    assert_response :success
  end

  test "should get show" do
    get pet_url(@pet)
    assert_response :success
  end

  test "should create pet with valid params" do
    assert_difference("Pet.count", 1) do
      post pets_url, params: {
        pet: {
          name: "New Pet",
          species: "dog",
          breed: "Beagle",
          date_of_birth: "2022-01-01",
          weight: 15.5,
          owner_id: @pet.owner_id
        }
      }
    end
    assert_redirected_to pet_url(Pet.last)
    assert_equal "The pet has been created correctly", flash[:notice]
  end

  test "should not create pet with invalid params" do
    assert_no_difference("Pet.count") do
      post pets_url, params: {
        pet: {
          name: "",
          species: "",
          breed: "",
          date_of_birth: "",
          weight: nil,
          owner_id: nil
        }
      }
    end
    assert_response :unprocessable_entity
  end

  test "should update pet with valid params" do
    patch pet_url(@pet), params: {
      pet: {
        name: "Updated Pet Name"
      }
    }
    assert_redirected_to pet_url(@pet)
    assert_equal "The pet has been updated correctly", flash[:notice]
    @pet.reload
    assert_equal "Updated Pet Name", @pet.name
  end

  test "should destroy pet" do
    assert_difference("Pet.count", -1) do
      delete pet_url(@pet)
    end
    assert_redirected_to pets_url
    assert_equal "The pet has been deleted correctly", flash[:notice]
  end
end