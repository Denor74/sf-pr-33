<?php

namespace Message\Controllers;

use Message\Core\Controller;

/** контроллер страницы подтверждения почты */
class VerifyEmailController extends Controller
{
    public function index()
    {
/*         В HTML некоторые символы имеют особый смысл и должны быть представлены в виде 
        HTML-сущностей, чтобы сохранить их значение. Эта функция возвращает строку, 
        над которой проведены эти преобразования. */
        //str_replace — Заменяет все вхождения строки поиска на строку замены
        $email = htmlspecialchars(str_replace('\'', '', $_GET['email']));
        $hash = htmlspecialchars(str_replace('\'', '', $_GET['hash']));

        if ($this->dbCtl->getUsers()->checkUserHash($email, $hash)) {
            $this->dbCtl->getUsers()->confirmEmail($email);
            $data = 'Электронная почта подтверждена';
        } else {
            $data = 'Ссылка недействительная или некорректная';
        }

        $this->view->generate('template_view.php', 'verify-email_view.php', '', '', 'Подтверждение почты', $data);
    }
}
