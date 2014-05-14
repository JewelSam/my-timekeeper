# -*- encoding : utf-8 -*-
class Page < ActiveRecord::Base
  include PathWithAlias
  has_ancestry

  validates :title, presence: true

  default_scope {order('sort')}
  scope :purpose, lambda { |purpose| where(purpose: purpose).limit(1) }
  scope :main_menu,  ->{ where(:show_in_menu=>true) }

  def self.menu_tree
    Page.all.each { |c| c.ancestry = c.ancestry.to_s + (c.ancestry != nil ? "/" : '') + c.id.to_s
    }.sort {|x,y| x.ancestry <=> y.ancestry
    }
  end


  def parent_enum
    #Page.where.not(id: id).order(:names_depth_cache).map { |c| ["-" * (c.depth) + ' ' + c.title, c.id ] }
    Page.menu_tree.map{ |c| ["---" * (c.depth - 1) + ' ' + c.title,c.id]
    }

  end

  def current?(params)
    (purpose == '/' and params[:controller] == 'pages' and params[:action] == 'home') or
        (params[:id].to_i == id and params[:action] == 'show' and params[:controller] == 'pages') or
        (children.pluck(:id).include?(params[:id].to_i) and params[:action] == 'show' and params[:controller] == 'pages') or
        (purpose == '/news' and params[:controller] == 'articles') or
        (purpose == '/gallery' and params[:controller] == 'photo_galleries') or
        (purpose == '/contacts' and params[:controller] == 'feedbacks') or
        (purpose == '/reviews' and params[:controller] == 'reviews') or
        (purpose == '/catalog' and params[:controller] == 'catalog') or
        (purpose == '/services' and params[:controller] == 'services') or
        (purpose == '/portfolio' and params[:controller] == 'portfolio_objects')
  end

end

# == Schema Information
#
# Table name: pages
#
#  id              :integer          not null, primary key
#  title           :string(255)
#  text            :text
#  purpose         :string(255)
#  show_in_menu    :boolean
#  menu            :string(255)
#  meta            :text
#  title_of_window :string(255)
#  ancestry        :string(255)
#  sort            :integer
#  created_at      :datetime
#  updated_at      :datetime
#
# Indexes
#
#  index_pages_on_ancestry  (ancestry)
#
