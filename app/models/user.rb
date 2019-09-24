class User < ApplicationRecord
  before_create :set_random_steps

  has_secure_password
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true, uniqueness: true

  def set_random_steps
    self.steps = Random.rand(100...5000)
  end

  def self.reset_steps
    User.update_all(steps: 0)
  end
end
