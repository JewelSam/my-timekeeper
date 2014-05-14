# -*- encoding : utf-8 -*-
class MyConfig < ActiveRecord::Base
  validates :key, presence: true
  validates :key_ru, presence: true
  validates :value, presence: true

  def self.get_config(title)
    config = self.find_by_key(title)
    if config.nil?
      ''
    else
      config.value
    end
  end

end

# == Schema Information
#
# Table name: my_configs
#
#  id         :integer          not null, primary key
#  key        :string(255)
#  key_ru     :string(255)
#  value      :text
#  created_at :datetime
#  updated_at :datetime
#
