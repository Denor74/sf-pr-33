<?php

namespace Message\Core;

class Config
{
    // подключение к БД
    public const HOST_DB = 'localhost';
    public const NAME_DB = 'sf-pr-33';
    public const USER_DB = 'root';
    public const PASS_DB = '';

    // настройки почтового сервера
/*  mail ругается на использование стороннего приложения профилем, 
    неообходимо Создайние в настройках аккаунта на сайте Mail.ru специального пароля, 
    уникального для каждого стороннего приложения
    без него поxта приходить (необходимо ввсти данные своей почты) */
    
    public const SMTP_SRV = 'smtp.mail.ru';
    public const EMAIL_USERNAME = 'main@mail';
    public const EMAIL_PASSWORD = 'password application';
    public const SMTP_SECURE = 'ssl';
    public const SMTP_PORT = 465;
    public const EMAIL_SENDER = 'main@mail';
    public const EMAIL_SENDER_NAME = 'Messenger sf-pr-33';

    // настройки вебсокета
    public const CHAT_WS_PORT = 8888;
    public const SITE_ADDR = '127.0.0.1';
    //public const SITE_ADDR = 'localhost';
    public const WEBSOCKET_PROCESSNAME = 'chat-server';

    public static function getWebSocketProcessFile(): string
    {
        return dirname(__DIR__, 1) . '/chat-server.php';
    }
    
    public static function getWebsocketProcessLogFile(): string
    {
        return dirname(__DIR__, 1) . '/logs/websocket.log';
    }

    public static function getPidsListFile(): string
    {
        return dirname(__DIR__, 1) . '/logs/pids.log';
    }
}
