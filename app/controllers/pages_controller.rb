# -*- encoding : utf-8 -*-
class PagesController < ApplicationController
  def home
    @page = Page.purpose('/').first

    if current_user
      render 'home'
    else
      render 'main', layout: false
    end
  end

  def show
    @page = Page.find(params[:id])
  end
end
