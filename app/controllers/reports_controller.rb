# -*- encoding : utf-8 -*-
class ReportsController < ApplicationController
  def index
    render layout: false
  end

  def data
    entries = current_user.entries
    entries = entries.fromto(params[:start], params[:finish]) if params[:start] and params[:finish]

    datachart = {}
    current_user.categories.each {|cat| datachart[cat.title] = 0 }
    datachart['Без категории'] = 0

    entries.each do |entry|
      category_title = entry.category ? entry.category.title : 'Без категории'
      datachart[category_title] += entry.duration
    end

    render json: {datachart: datachart.to_a}
  end
end
