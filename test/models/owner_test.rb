require "test_helper"

class OwnerTest < ActiveSupport::TestCase
  def setup
    @owner = Owner.new(
      first_name: "Juan",
      last_name: "Pérez",
      email: "juan@example.com",
      phone: "+56912345678"
    )
  end

  test "should save valid owner" do
    assert @owner.valid?, -> { @owner.errors.full_messages.join(", ") }
    assert @owner.save
  end

  test "should not save owner without first_name" do
    @owner.first_name = nil
    assert_not @owner.valid?
    assert_includes @owner.errors[:first_name], "can't be blank"
  end

  test "should not save owner without last_name" do
    @owner.last_name = nil
    assert_not @owner.valid?
    assert_includes @owner.errors[:last_name], "can't be blank"
  end

  test "should not save owner without email" do
    @owner.email = nil
    assert_not @owner.valid?
    assert_includes @owner.errors[:email], "can't be blank"
  end

  test "should not save owner with invalid email format" do
    invalid_emails = ["invalid", "test@", "@test.com", "test@test", "test test@test.com"]
    
    invalid_emails.each do |invalid_email|
      @owner.email = invalid_email
      assert_not @owner.valid?, "#{invalid_email} should be invalid"
      assert_includes @owner.errors[:email], "is invalid"
    end
  end

  test "should not save owner with duplicate email" do
    @owner.save!
    duplicate_owner = @owner.dup
    assert_not duplicate_owner.valid?
    assert_includes duplicate_owner.errors[:email], "has already been taken"
  end

  test "should accept valid email formats" do
    valid_emails = ["test@example.com", "user.name@domain.co", "user+tag@domain.org"]
    
    valid_emails.each do |valid_email|
      @owner.email = valid_email
      assert @owner.valid?, "#{valid_email} should be valid"
    end
  end

  test "should not save owner without phone" do
    @owner.phone = nil
    assert_not @owner.valid?
    assert_includes @owner.errors[:phone], "can't be blank"
  end
end