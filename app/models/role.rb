# -*- encoding : utf-8 -*-
class Role < ActiveRecord::Base
  has_many :users
  validates :name, presence: true
end

# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#
