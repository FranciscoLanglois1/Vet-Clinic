class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  has_one :owner
  has_one :vet

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    first_name = conditions.delete(:first_name)
    last_name = conditions.delete(:last_name)
    
    if first_name.present? && last_name.present?
      where(conditions).where("first_name = ? AND last_name = ?", first_name, last_name).first
    else
      nil
    end
  end

  def email_required?
    false
  end

  def email_changed?
    false
  end

  validate :email_present_for_recovery, if: :persisted?

  def email_present_for_recovery
    if email.blank? && !admin?
      errors.add(:email, "must be present for password recovery")
    end
  end

  def self.required_fields
    super + [:first_name, :last_name]
  end

  attribute :role, :integer
  enum :role, {owner: 0, vet: 1, admin: 2}
  validates :first_name, presence: true, uniqueness: { scope: :last_name }
  validates :last_name, presence: true

  def owner? = role == "owner"
  def vet?   = role == "vet"
  def admin? = role == "admin"

  def associated_record
    return owner if owner?
    return vet if vet?
    nil
  end
end
