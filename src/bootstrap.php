<?php
namespace Message;
session_start();
use Message\Core\Config;
use Message\Core\Route;


//echo dirname(__DIR__, 1);


// dirname(__DIR__, 1) ПУТЬ НА ПАПКУ НА ОДИН УРОВЕНЬ ВЫШЕ ТЕКУЩЕЙ
require dirname(__DIR__, 1) . DIRECTORY_SEPARATOR . 'vendor'. DIRECTORY_SEPARATOR . 'autoload.php';
// require __DIR__.'/vendor/autoload.php';

//date_default_timezone_set — Устанавливает часовой пояс по умолчанию для всех функций даты/времени в скрипте
//date_default_timezone_set('Asia/Yekaterinburg');

/* explode — Разбивает строку с помощью разделителя
Возвращает массив строк, полученных разбиением 
строки string с использованием separator в качестве разделителя. */
//php_uname — Возвращает информацию об операционной системе, на которой запущен PHP
$os = explode(' ', php_uname())[0]; 


/* Оператор разрешения области видимости (::)
(также называемый "Paamayim Nekudotayim") или просто "двойное двоеточие" 
- это лексема, позволяющая обращаться к статическим свойствам, 
константам и переопределённым свойствам или методам класса. */
//  Вызываем метод start() 
Route::start();
