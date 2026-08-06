require "test_helper"

class AppointmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @appointment = appointments(:one)
  end

  test "should get index" do
    get appointments_url
    assert_response :success
  end

  test "should get show" do
    get appointment_url(@appointment)
    assert_response :success
  end

  test "should create appointment with valid params" do
    assert_difference("Appointment.count", 1) do
      post appointments_url, params: {
        appointment: {
          pet_id: @appointment.pet_id,
          vet_id: @appointment.vet_id,
          date: Time.now + 1.day,
          reason: "New appointment reason",
          status: "scheduled"
        }
      }
    end
    assert_redirected_to appointment_url(Appointment.last)
    assert_equal "The appointment has been created correctly", flash[:notice]
  end

  test "should not create appointment with invalid params" do
    assert_no_difference("Appointment.count") do
      post appointments_url, params: {
        appointment: {
          pet_id: nil,
          vet_id: nil,
          date: nil,
          reason: "",
          status: nil
        }
      }
    end
    assert_response :unprocessable_entity
  end

  test "should update appointment with valid params" do
    patch appointment_url(@appointment), params: {
      appointment: {
        reason: "Updated reason"
      }
    }
    assert_redirected_to appointment_url(@appointment)
    assert_equal "The appointment has been updated correctly", flash[:notice]
    @appointment.reload
    assert_equal "Updated reason", @appointment.reason
  end

  test "should destroy appointment" do
    assert_difference("Appointment.count", -1) do
      delete appointment_url(@appointment)
    end
    assert_redirected_to appointments_url
    assert_equal "The appointment has been deleted correctly", flash[:notice]
  end
end