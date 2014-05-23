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

  def successful_register
    redirect_to '/', :flash => { :notice => "Добро пожаловать! Вы успешно зарегистрировались. Вам на e-mail выслано письмо с ссылкой для подтверждения регистрации." }
  end

  def successful_sign_in
    redirect_to '/', :flash => { :notice => "Вход в систему выполнен." }
  end
end
