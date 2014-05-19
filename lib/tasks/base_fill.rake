namespace :db do

  desc "Fill model MyConfig"
  task :fill_my_config => :environment do
    MyConfig.destroy_all
    MyConfig.create :key => 'email', :key_ru => 'E-mail', :value => 'mrswlasowa@gmail.com'
    MyConfig.create :key => 'phone', :key_ru => 'Телефон', :value => '(495) 225-59-10'
    MyConfig.create :key => 'address', :key_ru => 'Адрес', :value => 'г. Москва, ул. Гагарина, 42'
    MyConfig.create :key => 'vkontakte', :key_ru => 'Ссылка на социальную сеть ВКонтакте', :value => '/'
    MyConfig.create :key => 'facebook', :key_ru => 'Ссылка на социальную сеть Facebook', :value => '/'
    MyConfig.create :key => 'twitter', :key_ru => 'Ссылка на социальную сеть Twitter', :value => '/'
    MyConfig.create :key => 'odnokl', :key_ru => 'Ссылка на социальную сеть Одноклассники', :value => '/'
    MyConfig.create key: 'default_title', key_ru: 'Заголовок окна по умолчанию', value: 'Сайт'
    MyConfig.create key: 'metrika', key_ru: 'Код счетчика статистики', value: '<script></script>'
  end

  desc "Fill models User and Role"
  task :fill_users => :environment do
    Role.destroy_all
    admin = Role.create :name => 'admin'
    superadmin = Role.create :name => 'superadmin'

    User.destroy_all
    admin.users.create email: 'admin@admin.ru', password: 'password', password_confirmation: 'password'
    superadmin.users.create email: 'mrswlasowa@gmail.com', password: '352sutka', password_confirmation: '352sutka'
  end

end