class EntriesController < ApplicationController
  def index
    limit = 20
    page = params[:page] || 0

    categories = current_user.categories
    entries = current_user.entries.offset(page * limit).limit(limit).as_json()

    respond_to do |format|
      format.html { render layout: false }
      format.json {render json: {
          categories: to_hash(categories),
          categories_order: categories,
          entries: entries
      }}
    end

  end

  def autocomplete_data
    autocompleteData = current_user.entries.where('start > ?', 2.month.ago).select("DISTINCT title, category_id").all
    render json: { autocompleteData: autocompleteData }
  end

  def update
    entry = if params[:id]
              entry = Entry.find(params[:id])
              authorize! :manage, entry
            else
              current_user.entries.build
            end

    if params[:category_id]
      category = Category.find(params[:category_id])
      authorize! :manage, category
    end

    if entry.update_attributes entry_params
      render json: {entry: entry}
    else render :json => { :errors => entry.errors.full_messages }, :status => 422
    end
  end

  def destroy
    result = true
    errors = []

    params[:ids].each do |id|
      entry = Entry.find(id)
      authorize! :manage, entry

      unless entry.destroy
        result = false
        errors.push(entry.errors.full_messages)
      end
    end

    if result
      render nothing: true
    else render :json => { :errors => errors.uniq.join(' ') }, :status => 422
    end
  end

  private
  def entry_params
    params.require(:entry).permit(:title, :start, :category_id, :finish, :current)
  end
end
