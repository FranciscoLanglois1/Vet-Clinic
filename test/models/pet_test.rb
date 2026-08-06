require "test_helper"

class PetTest < ActiveSupport::TestCase
  def setup
    @owner = Owner.create!(
      first_name: "María",
      last_name: "García",
      email: "maria@example.com",
      phone: "+56987654321"
    )
    
    @pet = Pet.new(
      name: "Luna",
      species: "dog",
      date_of_birth: 3.years.ago,
      weight: 15.5,
      owner: @owner
    )
  end

  test "should save valid pet" do
    assert @pet.valid?, -> { @pet.errors.full_messages.join(", ") }
    assert @pet.save
  end

  test "should not save pet without name" do
    @pet.name = nil
    assert_not @pet.valid?
    assert_includes @pet.errors[:name], "can't be blank"
  end

  test "should not save pet without species" do
    @pet.species = nil
    assert_not @pet.valid?
    assert_includes @pet.errors[:species], "can't be blank"
  end

  test "should not save pet with invalid species" do
    @pet.species = "dragon"
    assert_not @pet.valid?
    assert_includes @pet.errors[:species], "is not included in the list"
  end

  test "should accept all valid species" do
    valid_species = %w[dog cat rabbit bird reptile other]
    
    valid_species.each do |valid_species|
      @pet.species = valid_species
      assert @pet.valid?, "#{valid_species} should be a valid species"
    end
  end

  test "should not save pet without date_of_birth" do
    @pet.date_of_birth = nil
    assert_not @pet.valid?
    assert_includes @pet.errors[:date_of_birth], "can't be blank"
  end

  test "should not save pet with future date_of_birth" do
    @pet.date_of_birth = Date.tomorrow
    assert_not @pet.valid?
    # Depende del mensaje exacto de tu validación:
    assert_includes @pet.errors[:date_of_birth], "can't be in the future"
  end

  test "should accept date_of_birth as today" do
    @pet.date_of_birth = Date.today
    assert @pet.valid?, "Pet should be valid with today's date"
  end

  test "should accept date_of_birth in the past" do
    @pet.date_of_birth = 5.years.ago
    assert @pet.valid?, "Pet should be valid with past date"
  end

  test "should not save pet without weight" do
    @pet.weight = nil
    assert_not @pet.valid?
    assert_includes @pet.errors[:weight], "can't be blank"
  end

  test "should not save pet with weight zero" do
    @pet.weight = 0
    assert_not @pet.valid?
    assert_includes @pet.errors[:weight], "must be greater than 0"
  end

  test "should not save pet with negative weight" do
    @pet.weight = -5
    assert_not @pet.valid?
    assert_includes @pet.errors[:weight], "must be greater than 0"
  end

  test "should not save pet with non-numeric weight" do
    @pet.weight = "heavy"
    assert_not @pet.valid?
    assert_includes @pet.errors[:weight], "is not a number"
  end

  test "should accept valid weight" do
    @pet.weight = 10.5
    assert @pet.valid?, "Pet should be valid with positive weight"
  end

  test "should not save pet without owner" do
    @pet.owner = nil
    assert_not @pet.valid?
    assert_includes @pet.errors[:owner], "must exist"
  end
end