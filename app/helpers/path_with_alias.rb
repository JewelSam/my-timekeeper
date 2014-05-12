# -*- encoding : utf-8 -*-
module PathWithAlias

  def my_path
    {id: self.id, alias: self.alias}
  end

  def alias
    self.title.transliterate
  end

  def html_title
    title_of_window.to_s.strip.blank? ? (MyConfig.get_config('default_title') + ' - ' + title) : title_of_window
  end
end