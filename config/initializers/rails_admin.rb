# -*- encoding : utf-8 -*-
# RailsAdmin config file. Generated on December 19, 2013 13:43
# See github.com/sferik/rails_admin for more informations

RailsAdmin.config do |config|

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

  ################  Global configuration  ################
  config.authorize_with :cancan

  # Set the admin name here (optional second array element will appear in red). For example:
  config.main_app_name = ['Site', 'Admin']
  # or for a more dynamic name:
  # config.main_app_name = Proc.new { |controller| [Rails.application.engine_name.titleize, controller.params['action'].titleize] }

  # RailsAdmin may need a way to know who the current user is]
  config.current_user_method { current_user } # auto-generated

  # If you want to track changes on your models:
  config.audit_with :history, 'MyConfig'

  # Or with a PaperTrail: (you need to install it first)
  #config.audit_with :paper_trail, 'MyConfig'

  # Display empty fields in show views:
  # config.compact_show_view = false

  # Number of default rows per-page:
  # config.default_items_per_page = 20

  # Exclude specific models (keep the others):
  config.excluded_models = [Ckeditor::Asset, Ckeditor::Picture, Ckeditor::AttachmentFile]

  # Include specific models (exclude the others):
  # config.included_models = []

  # Label methods for model instances:
  # config.label_methods << :description # Default is [:name, :title]


  ################  Model configuration  ################

  # Each model configuration can alternatively:
  #   - stay here in a `config.model 'ModelName' do ... end` block
  #   - go in the model definition file in a `rails_admin do ... end` block

  # This is your choice to make:
  #   - This initializer is loaded once at startup (modifications will show up when restarting the application) but all RailsAdmin configuration would stay in one place.
  #   - Models are reloaded at each request in development mode (when modified), which may smooth your RailsAdmin development workflow.
  # Now you probably need to tour the wiki a bit: https://github.com/sferik/rails_admin/wiki
  # Anyway, here is how RailsAdmin saw your application's models when you ran the initializer:

  config.model MyConfig do
    navigation_label 'Общее'
    weight -2

    list do
      field :key_ru
      field :value
    end

    show do
      field :id
      field :key do
        visible do
          bindings[:view]._current_user.role?('superadmin')
        end
      end
      field :key_ru
      field :value
      field :created_at
      field :updated_at
    end

    edit do
      field :key do
        visible do
          bindings[:view]._current_user.role?('superadmin')
        end
      end
      field :key_ru do
        visible do
          bindings[:view]._current_user.role?('superadmin')
        end
      end
      field :value
    end
  end

  config.model User do
    navigation_label 'Общее'
    weight 1

    edit do
      field :role
      field :email
      field :password
      field :password_confirmation
    end
  end

  config.model Role do
    navigation_label 'Общее'
    weight 0
  end
end
