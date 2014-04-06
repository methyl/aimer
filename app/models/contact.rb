class Contact < ActiveRecord::Base
  validates :email, :subject, :message, presence: true
  validates_uniqueness_of :email, :scope => [:subject, :message]
end
