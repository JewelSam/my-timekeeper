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

  def settings
    respond_to do |format|
      format.html { render layout: false }
      format.json {render json: {
          categories: current_user.categories
      }}
    end
  end

  def successful_register
    redirect_to '/', :flash => { :notice => "Welcome! You have signed up successfully. You will receive an email with instructions for how to confirm your email address in a few minutes." }
  end

  def successful_sign_in
    redirect_to '/', :flash => { :notice => "Signed in successfully." }
  end

end
