require "test_helper"

class VetTest < ActiveSupport::TestCase
  def setup
    @vet = Vet.new(
      first_name: "Carlos",
      last_name: "Rodríguez",
      email: "carlos@vetclinic.com",
      specialization: "Cirugía"
    )
  end

  test "should save valid vet" do
    assert @vet.valid?, -> { @vet.errors.full_messages.join(", ") }
    assert @vet.save
  end

  test "should not save vet without first_name" do
    @vet.first_name = nil
    assert_not @vet.valid?
    assert_includes @vet.errors[:first_name], "can't be blank"
  end

  test "should not save vet without last_name" do
    @vet.last_name = nil
    assert_not @vet.valid?
    assert_includes @vet.errors[:last_name], "can't be blank"
  end

  test "should not save vet without email" do
    @vet.email = nil
    assert_not @vet.valid?
    assert_includes @vet.errors[:email], "can't be blank"
  end

  test "should not save vet with invalid email format" do
    invalid_emails = ["invalid", "test@", "@test.com", "test@test", "test test@test.com"]
    
    invalid_emails.each do |invalid_email|
      @vet.email = invalid_email
      assert_not @vet.valid?, "#{invalid_email} should be invalid"
      assert_includes @vet.errors[:email], "is invalid"
    end
  end

  test "should not save vet with duplicate email" do
    @vet.save!
    duplicate_vet = @vet.dup
    assert_not duplicate_vet.valid?
    assert_includes duplicate_vet.errors[:email], "has already been taken"
  end

  test "should accept valid email formats" do
    valid_emails = ["vet@clinic.com", "dr.name@hospital.org", "vet+emergency@clinic.co"]
    
    valid_emails.each do |valid_email|
      @vet.email = valid_email
      assert @vet.valid?, "#{valid_email} should be valid"
    end
  end

  test "should not save vet without specialization" do
    @vet.specialization = nil
    assert_not @vet.valid?
    assert_includes @vet.errors[:specialization], "can't be blank"
  end
end