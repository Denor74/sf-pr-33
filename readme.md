<!-- SkillFactory PHPDEV-38 Рыков Денис-->
<!--33 Практическая работа -->

# Мессенджер
### 33. Практическая работа

Разработан в качестве практического задания на курсе Вэб разработчик учебного центра [SkillFactory](https://lms.skillfactory.ru/ "Перейти на сайт учебного центра")
____

License: [MIT](license.md "Смотреть лицензию")
## Используемые технологии

* HTML

* CSS

* JS

* PHP

* Composer

## Данные

* Название MySQL БД: **sf-pr-33**

* папка проекта *src*

* Для отправки почты используются **phpmailer**, **mail.ru SMTP-сервер**. Для отправки почты необходимо в классе Core/Config.php ввести свои данные: адрес почты и пароль для внешних приложений (удалены в соображениям безопасности)

* Для запуска сервера websocket необходимо запустить *chat-server.php* 
## Разворачивание проекта

* Для разворачивания проекта использовался *OpenServer* с названием домена messenger.loc

* Для формирования *autoload* необходим установленный Composer. Запустить *composer.json* командой *composer install*

* Дамп БД в корне проекта *sf-pr-33.sql*