# -*- encoding : utf-8 -*-
class PagesController < ApplicationController
  def home
    @page = Page.purpose('/').first
  end

  def show
    @page = Page.find(params[:id])
  end
end
