class EntriesController < ApplicationController
  def index

    categories = current_user.categories
    entries = Entry.where(category_id: categories.pluck(:id)).as_json(methods: [:start_to_i, :finish_to_i])

    respond_to do |format|
      format.html { render layout: false }
      format.json {render json: {
          categories: to_hash(categories),
          entries: entries
      }}
    end

  end
end
