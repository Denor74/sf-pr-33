<?php
namespace Message;
session_start();
use Message\Core\Config;
use Message\Core\Route;


//echo dirname(__DIR__, 1);


// dirname(__DIR__, 1) ПУТЬ НА ПАПКУ НА ОДИН УРОВЕНЬ ВЫШЕ ТЕКУЩЕЙ
require dirname(__DIR__, 1) . DIRECTORY_SEPARATOR . 'vendor'. DIRECTORY_SEPARATOR . 'autoload.php';


/* Оператор разрешения области видимости (::)
(также называемый "Paamayim Nekudotayim") или просто "двойное двоеточие" 
- это лексема, позволяющая обращаться к статическим свойствам, 
константам и переопределённым свойствам или методам класса. */
//  Вызываем метод start() 
Route::start();
