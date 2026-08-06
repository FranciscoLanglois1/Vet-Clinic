require "test_helper"

class TreatmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @treatment = treatments(:one)
    @appointment = @treatment.appointment
  end

  test "should get new" do
    get new_appointment_treatment_url(@appointment)
    assert_response :success
  end

  test "should get edit" do
    get edit_appointment_treatment_url(@appointment, @treatment)
    assert_response :success
  end

  test "should create treatment with valid params" do
    assert_difference("Treatment.count", 1) do
      post appointment_treatments_url(@appointment), params: {
        treatment: {
          name: "New Treatment",
          medication: "New Med",
          dosage: "10mg",
          administered_at: Time.now,
          notes: "Test notes"
        }
      }
    end
    assert_redirected_to appointment_url(@appointment)
    assert_equal "The treatment has been created correctly", flash[:notice]
  end

  test "should not create treatment with invalid params" do
    assert_no_difference("Treatment.count") do
      post appointment_treatments_url(@appointment), params: {
        treatment: {
          name: "",
          medication: "",
          dosage: "",
          administered_at: nil,
          notes: ""
        }
      }
    end
    assert_response :unprocessable_entity
  end

  test "should update treatment with valid params" do
    patch appointment_treatment_url(@appointment, @treatment), params: {
      treatment: {
        name: "Updated Treatment Name"
      }
    }
    assert_redirected_to appointment_url(@appointment)
    assert_equal "The treatment has been updated correctly", flash[:notice]
    @treatment.reload
    assert_equal "Updated Treatment Name", @treatment.name
  end

  test "should destroy treatment" do
    assert_difference("Treatment.count", -1) do
      delete appointment_treatment_url(@appointment, @treatment)
    end
    assert_redirected_to appointment_url(@appointment)
    assert_equal "The treatment has been deleted correctly", flash[:notice]
  end
end