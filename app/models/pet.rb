class Pet < ApplicationRecord
    belongs_to :owner
    has_many :appointments

    validates  :name, presence: true
    validates :species, presence: true
    validates :date_of_birth, presence: true
    validate :validation_date
    validates :weight, presence: true, numericality: {greater_than: 0}
    validates :breed, presence: true
    validates :owner_id, presence: true

    def validation_date
        return unless date_of_birth.present?
        if date_of_birth > Date.today
        errors.add(:date_of_birth)
        end
    end
    scope :by_species, ->(species) {where(species: species)}
    before_save :capitalize_name
    def capitalize_name
        self.name = name.upcase
    end

    private
  
    def validate_photo_content_type
        unless photo.content_type.in?(%w[image/jpeg image/png image/webp])
            errors.add(:photo, "must be a JPEG, PNG, or WEBP image")
        end
    end
  
    def validate_photo_size
        if photo.byte_size > 5.megabytes
            errors.add(:photo, "must be less than 5 MB in size")
        end
    end
end