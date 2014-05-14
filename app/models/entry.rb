class Entry < ActiveRecord::Base
  belongs_to :category

  validates :start, presence: true

  default_scope {order('start DESC')}
end

# == Schema Information
#
# Table name: entries
#
#  id          :integer          not null, primary key
#  category_id :integer
#  title       :text
#  start       :datetime
#  finish      :datetime
#  created_at  :datetime
#  updated_at  :datetime
#
