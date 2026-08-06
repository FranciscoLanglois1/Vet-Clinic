class Treatment < ApplicationRecord
    belongs_to :appointment

    has_rich_text :notes

    validates :name, presence: true
    validates :administered_at, presence: true
    validates :appointment, presence: true
    validates :dosage, presence: true
    validates :notes, presence: true
    validates :medication, presence: true
end