require "test_helper"

class AppointmentTest < ActiveSupport::TestCase
  def setup
    @owner = Owner.create!(
      first_name: "Pedro",
      last_name: "López",
      email: "pedro@example.com",
      phone: "+56911111111"
    )
    
    @pet = Pet.create!(
      name: "Max",
      species: "cat",
      date_of_birth: 2.years.ago,
      weight: 4.5,
      owner: @owner
    )
    
    @vet = Vet.create!(
      first_name: "Ana",
      last_name: "Martínez",
      email: "ana@vetclinic.com",
      specialization: "Dermatología"
    )
    
    @appointment = Appointment.new(
      date: Date.tomorrow,
      reason: "Control general",
      pet: @pet,
      vet: @vet,
      status: "scheduled"
    )
  end

  test "should save valid appointment" do
    assert @appointment.valid?, -> { @appointment.errors.full_messages.join(", ") }
    assert @appointment.save
  end

  test "should not save appointment without date" do
    @appointment.date = nil
    assert_not @appointment.valid?
    assert_includes @appointment.errors[:date], "can't be blank"
  end

  test "should not save appointment without reason" do
    @appointment.reason = nil
    assert_not @appointment.valid?
    assert_includes @appointment.errors[:reason], "can't be blank"
  end

  test "should not save appointment without pet" do
    @appointment.pet = nil
    assert_not @appointment.valid?
    assert_includes @appointment.errors[:pet], "must exist"
  end

  test "should not save appointment without vet" do
    @appointment.vet = nil
    assert_not @appointment.valid?
    assert_includes @appointment.errors[:vet], "must exist"
  end

  test "should not save appointment without status" do
    @appointment.status = nil
    assert_not @appointment.valid?
    assert_includes @appointment.errors[:status], "can't be blank"
  end

  test "should accept valid statuses" do
    valid_statuses = %w[scheduled confirmed completed cancelled]
    
    valid_statuses.each do |status|
      @appointment.status = status
      assert @appointment.valid?, "#{status} should be a valid status"
    end
  end

  test "should not accept invalid status" do
    assert_raises(ArgumentError) do
      @appointment.status = "invalid_status"
    end
  end
end