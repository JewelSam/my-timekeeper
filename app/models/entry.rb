class Entry < ActiveRecord::Base
  belongs_to :category
  belongs_to :user

  #validates :start, presence: true

  default_scope {order('start DESC')}

  def start_to_i; start.to_i end
  def finish_to_i; finish.to_i end
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
