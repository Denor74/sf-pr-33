<?php

namespace Message\Models;

use Message\Core\DB\DBQueryClass;

/** Класс модели таблицы БД */
class DBTableModel
{
    protected DBQueryClass $db;

    public function __construct(DBQueryClass $db)
    {
        $this->db = $db;
    }
}
