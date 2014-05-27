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

  def reports
    #datachart = [['Heavy Industry', 12],['Retail', 9], ['Light Industry', 14], ['Out of home', 16],['Commuting', 7], ['Orientation', 9]]
    datachart = current_user.categories.map {|cat| [cat.title, cat.entries.sum {|entry| entry.duration}]}

    no_category = Entry.no_category
    if no_category.count > 0
      datachart.push(['Без категории', no_category.sum {|entry| entry.duration}])
    end

    respond_to do |format|
      format.html { render layout: false }
      format.json {render json: {
          datachart: datachart
      }}
    end
  end

  def successful_register
    redirect_to '/', :flash => { :notice => "Добро пожаловать! Вы успешно зарегистрировались. Вам на e-mail выслано письмо с ссылкой для подтверждения регистрации." }
  end

  def successful_sign_in
    redirect_to '/', :flash => { :notice => "Вход в систему выполнен." }
  end

end
