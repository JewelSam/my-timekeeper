# -*- encoding : utf-8 -*-
module ApplicationHelper
  def html_title(page_title = '')
    if page_title.strip.blank?
      content_for :html_title, (MyConfig.get_config 'default_title')
    else
      content_for :html_title, page_title.to_s
    end

  end

  def html_meta(page_meta)
    content_for :html_meta, page_meta.to_s
  end

  def children_breadcrumbs(res, page, first = false)
    hash = {title: page.title}
    hash[:link] = page.purpose.blank? ? page_path(page.my_path) : page.purpose unless first
    res << hash

    res = children_breadcrumbs(res, page.parent) unless page.is_root?
    res
  end

  def breadcrumbs
    res = @page ? children_breadcrumbs([], @page, true) : []
    res << {title: 'Главная', link: '/'}
    res.reverse
  end

  def sort_link(full_path, param)
    full_path = full_path.gsub(/direction=([a-z]*)/, '' ).gsub(/order=([a-z_0-9]*)/, '' ).gsub('&&', '&').gsub(/&$/, '').gsub(/\?$/, '')

    direction =
        if params[:order] == param
          params[:direction] == 'desc' ? 'asc' : 'desc'
        else 'desc'
        end

    full_path += full_path.include?('?') ? '&' : '?'
    full_path += "order=#{param}&direction=#{direction}"
  end

  def to_hash(array)
    Hash[*array.map{|el| [el['id'], el]}.flatten]
  end

end
