require "test_helper"

class TreatmentTest < ActiveSupport::TestCase
  def setup
    @owner = Owner.create!(
      first_name: "Laura",
      last_name: "Fernández",
      email: "laura@example.com",
      phone: "+56922222222"
    )
    
    @pet = Pet.create!(
      name: "Bella",
      species: "rabbit",
      date_of_birth: 1.year.ago,
      weight: 2.3,
      owner: @owner
    )
    
    @vet = Vet.create!(
      first_name: "Roberto",
      last_name: "González",
      email: "roberto@vetclinic.com",
      specialization: "Medicina interna"
    )
    
    @appointment = Appointment.create!(
      date: Date.today,
      reason: "Vacunación",
      pet: @pet,
      vet: @vet,
      status: "completed"
    )
    
    @treatment = Treatment.new(
      name: "Vacuna antirrábica",
      administered_at: Time.current,
      appointment: @appointment
    )
  end

  test "should save valid treatment" do
    assert @treatment.valid?, -> { @treatment.errors.full_messages.join(", ") }
    assert @treatment.save
  end

  test "should not save treatment without name" do
    @treatment.name = nil
    assert_not @treatment.valid?
    assert_includes @treatment.errors[:name], "can't be blank"
  end

  test "should not save treatment without administered_at" do
    @treatment.administered_at = nil
    assert_not @treatment.valid?
    assert_includes @treatment.errors[:administered_at], "can't be blank"
  end

  test "should not save treatment without appointment" do
    @treatment.appointment = nil
    assert_not @treatment.valid?
    assert_includes @treatment.errors[:appointment], "must exist"
  end
end