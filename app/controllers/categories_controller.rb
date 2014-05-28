# -*- encoding : utf-8 -*-
class CategoriesController < ApplicationController

  def update
    category = if params[:id]
                 Category.find(params[:id])
               else current_user.categories.build
               end
    authorize! :update, category

    if category.update_attributes(title: params[:title])
      render :json => category
    else render :json => { :errors => category.errors.full_messages }, :status => 422
    end
  end

  def delete
    category = Category.find(params[:id])
    authorize! :destroy, category

    if category.destroy
      render :json => current_user.categories
    else render :json => { :errors => category.errors.full_messages }, :status => 422
    end
  end

end
