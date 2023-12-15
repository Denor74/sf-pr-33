<?php

namespace Message;

use Message\Core\Config;
use Message\Core\Chat;
use Message\Core\DB\DBCtl;
use Ratchet\Http\HttpServer;
use Ratchet\Server\IoServer;
use Ratchet\WebSocket\WsServer;

// require __DIR__ . '/vendor/autoload.php';

require dirname(__DIR__, 1) . DIRECTORY_SEPARATOR . 'vendor'. DIRECTORY_SEPARATOR . 'autoload.php';

// Подключаемся к БД через PDO
$dbCtl = new DBCtl(Config::HOST_DB, Config::NAME_DB, Config::USER_DB, Config::PASS_DB);
$users = $dbCtl->getUsers();
$connections = $dbCtl->getConnections();
$messages = $dbCtl->getMessageDBTable();

$server = IoServer::factory(
    new HttpServer(
        new WsServer(
            new Chat($connections, $messages, $users)
        )
    ),
    Config::CHAT_WS_PORT
);

$server->run();
