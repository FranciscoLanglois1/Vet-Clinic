class Vet < ApplicationRecord
    belongs_to :user, optional: true
    has_many :appointments
    VALID_EMAIL_REGEX = /\A[^@\s]+@[^@\s]+\.[^@\s]+\z/
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX}
    validates :specialization, presence: true
    scope :by_specialization, ->(specialization) {where(specialization: specialization)}
end