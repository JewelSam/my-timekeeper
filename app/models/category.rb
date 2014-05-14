class Category < ActiveRecord::Base
  has_many :entries
  belongs_to :user

  validates :title, presence: true
  validates :user_id, presence: true
end

# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  title      :text
#  created_at :datetime
#  updated_at :datetime
#
