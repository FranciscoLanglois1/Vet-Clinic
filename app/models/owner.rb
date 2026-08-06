class Owner < ApplicationRecord
    belongs_to :user, optional: true
    has_many :pets
    VALID_EMAIL_REGEX = /\A[^@\s]+@[^@\s]+\.[^@\s]+\z/
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX}
    validates :phone, presence: true
    validates :address, presence: true
    before_validation :normalize_email
    def normalize_email
        self.email = email.strip.downcase
    end
end