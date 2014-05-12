# -*- encoding : utf-8 -*-
class Role < ActiveRecord::Base
  has_many :users
  validates :name, presence: true
end
