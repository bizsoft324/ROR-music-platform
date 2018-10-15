class Session
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :email_or_username, :password, :admin, :remember_me

  delegate :id, to: :user, prefix: true

  validates :email_or_username, :password, presence: true
  validate :credentials

  def initialize(attrs = {})
    attrs.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end

  def user
    @user ||= User.find_by('email = :query OR username = :query', query: email_or_username)
  end

  private

  def credentials
    user_account = user
    return errors.add(:email_or_username, :invalid) if user_account.nil? || !user_account.authenticate(password)
    return false if password.blank?
    return true if user_account.admin?
  end
end
