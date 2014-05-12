
  config.model Page do
    weight -4
    navigation_label 'Контент'
    nestable_tree({
                      position_field: :sort,
                      max_depth: 2
                  })

    list do
      field :title
      field :show_in_menu
    end

    show do
      field :id
      field :title
      field :text
      field :created_at
      field :updated_at
    end

    edit do
      group :main do
        label "Главная инфомация"
        field :title
        field :text, :ck_editor
      end

      group :spec do
        #active false
        label "Служебная информация"
        field :show_in_menu
        field :purpose, :enum do
          enum do
            [ ['Главная', '/'] , ['Новости', '/news'], ['Каталог', '/catalog'],  ['Галерея', '/gallery'], ['О компании', '/about'], ['Отзывы', '/reviews'], ['Контакты', '/contacts'], ['Портфолио', '/portfolio'], ['Услуги', '/services'] ]
          end
        end

      end


      group :seo do
        active false
        label 'SEO оптимизация'
        field :title_of_window do
          help 'Оставьте это поле пустым, если хотите оставить заголовок по умолчанию'
        end
        field :meta do
          help 'Оставьте это поле пустым, если хотите оставить мета теги по умолчанию'
        end
      end

    end



  end



  config.actions do
    # root actions
    dashboard                     # mandatory
                                  # collection actions
    index                         # mandatory
    new
    export
    history_index
    bulk_delete
                                  # member actions
    show
    edit
    delete
    history_show
    show_in_app

    # Add the nestable action for configured models
    nestable
  end
