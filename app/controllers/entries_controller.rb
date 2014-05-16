class EntriesController < ApplicationController
  def index

    categories = current_user.categories
    entries = Entry.where(category_id: categories.pluck(:id))

    respond_to do |format|
      format.html { render layout: false }
      format.json {render json: {
          categories: categories,
          entries: entries
      }}
    end

  end
end
