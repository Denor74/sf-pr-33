<?php

namespace Message\Controllers;

use Message\Core\Controller;

/** контроллер страницы 404 */
// Наследуем из 
class Page404Controller extends Controller
{
    public function index()
    {
        $this->view->generate('template_view.php', 'page404_view.php', '', '', 'Ошибка 404');
    }
}
