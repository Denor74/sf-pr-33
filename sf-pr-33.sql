-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3306
-- Время создания: Дек 15 2023 г., 18:14
-- Версия сервера: 8.0.24
-- Версия PHP: 8.0.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `sf-pr-33`
--

DELIMITER $$
--
-- Процедуры
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_forwarded_message` (IN `msg_creatorid` INT, IN `message_id` INT, IN `chat_id` INT, IN `msg_time` DATETIME, OUT `new_msg_id` INT)  begin

    # копируем сообщение

    insert into chat_message(chat_message_chatid, chat_message_text, chat_message_creatorid, chat_message_time)

    select chat_message_chatid, chat_message_text, chat_message_creatorid, chat_message_time

    from chat_message

    where chat_message_id = message_id;



    select last_insert_id() into new_msg_id;



    # обновляем чат и время строки

    update chat_message

    set chat_message_chatid    = chat_id,

        chat_message_time      = msg_time,

        chat_message_creatorid = msg_creatorid,

        chat_message_forward   = 1

    where chat_message_id = new_msg_id;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_message` (IN `chat_chatid` INT, IN `chat_text` TEXT, IN `chat_user` VARCHAR(100), IN `chat_time` DATETIME, OUT `msg_id` INT)  begin

    select user_id into @userid from users where user_email = chat_user or user_nickname = chat_user;

    insert into chat_message(chat_message_chatid, chat_message_text, chat_message_creatorid, chat_message_time)

    values (chat_chatid, chat_text, @userid, chat_time);

    select last_insert_id() into msg_id;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `create_dialog` (IN `user1` INT, IN `user2` INT, OUT `chatid` INT)  begin

    insert into chat(chat_type, chat_creatorid) values ('dialog', user1);

    select last_insert_id() into chatid;

    insert into chat_participant(chat_participant_chatid, chat_participant_userid)

    values (chatid, user1),

           (chatid, user2);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `create_discussion` (IN `userhost` INT, OUT `chatid` INT)  begin

    insert into chat(chat_type, chat_creatorid) values ('discussion', userhost);

   

    select last_insert_id() into chatid;

   

    insert into chat_participant(chat_participant_chatid, chat_participant_userid) values (chatid, userhost); # пользователи чата

    

    update chat set chat_name = concat('Групповой чат ', userhost, chatid) where chat_id = chatid; # название группового чата

END$$

--
-- Функции
--
CREATE DEFINER=`root`@`localhost` FUNCTION `getPublicUserName` (`email` VARCHAR(100), `nickname` VARCHAR(100), `hide_email` INT(1)) RETURNS VARCHAR(100) CHARSET utf8mb4 begin

    IF hide_email = 1 THEN

        return nickname;

    ELSE

        return email;

    END IF;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `chat`
--

CREATE TABLE `chat` (
  `chat_id` int NOT NULL,
  `chat_type` varchar(10) NOT NULL,
  `chat_name` varchar(30) DEFAULT NULL,
  `chat_creatorid` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `chat`
--

INSERT INTO `chat` (`chat_id`, `chat_type`, `chat_name`, `chat_creatorid`) VALUES
(3, 'dialog', NULL, 8),
(4, 'discussion', 'Групповой чат 74', 7);

--
-- Триггеры `chat`
--
DELIMITER $$
CREATE TRIGGER `check_chat_type` BEFORE INSERT ON `chat` FOR EACH ROW begin

    IF NEW.chat_type not in ('dialog', 'discussion') then

        SIGNAL SQLSTATE '45000'

            SET MESSAGE_TEXT = 'chat_type не равен dialog или discussion';

    END if;

end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `chat_message`
--

CREATE TABLE `chat_message` (
  `chat_message_id` int NOT NULL,
  `chat_message_chatid` int DEFAULT NULL,
  `chat_message_text` text NOT NULL,
  `chat_message_creatorid` int DEFAULT NULL,
  `chat_message_time` datetime DEFAULT NULL,
  `chat_message_forward` int DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `chat_message`
--

INSERT INTO `chat_message` (`chat_message_id`, `chat_message_chatid`, `chat_message_text`, `chat_message_creatorid`, `chat_message_time`, `chat_message_forward`) VALUES
(1, 3, 'asdsdfdfsdf', 7, '2023-12-15 13:03:35', 0),
(2, 3, 'fasfafdsfd', 8, '2023-12-15 13:04:22', 0),
(3, 4, 'dgf', 7, '2023-12-15 13:19:00', 0),
(4, 3, 'ещё один пост', 7, '2023-12-15 14:56:52', 0),
(5, 3, 'отвте', 8, '2023-12-15 14:58:19', 0),
(6, 3, 'sdfsdfasdf', 7, '2023-12-15 18:04:23', 0);

--
-- Триггеры `chat_message`
--
DELIMITER $$
CREATE TRIGGER `check_message` BEFORE INSERT ON `chat_message` FOR EACH ROW BEGIN

    if new.chat_message_creatorid not in (select chat_participant_userid

                                          from chat_participant

                                          where chat_participant_chatid = new.chat_message_chatid) then

        SIGNAL SQLSTATE '45000'

            SET MESSAGE_TEXT = 'пользователя нет в данном чате';

    END IF;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `chat_participant`
--

CREATE TABLE `chat_participant` (
  `chat_participant_chatid` int NOT NULL,
  `chat_participant_userid` int NOT NULL,
  `chat_participant_isnotice` int DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `chat_participant`
--

INSERT INTO `chat_participant` (`chat_participant_chatid`, `chat_participant_userid`, `chat_participant_isnotice`) VALUES
(3, 7, 1),
(3, 8, 1),
(4, 7, 1),
(4, 8, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `connections`
--

CREATE TABLE `connections` (
  `connection_ws_id` int NOT NULL,
  `connection_userid` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `connections`
--

INSERT INTO `connections` (`connection_ws_id`, `connection_userid`) VALUES
(95, 7);

-- --------------------------------------------------------

--
-- Структура таблицы `contacts`
--

CREATE TABLE `contacts` (
  `cnt_id` int NOT NULL,
  `cnt_user_id` int NOT NULL,
  `cnt_contact_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `contacts`
--

INSERT INTO `contacts` (`cnt_id`, `cnt_user_id`, `cnt_contact_id`) VALUES
(1, 8, 7);

-- --------------------------------------------------------

--
-- Дублирующая структура для представления `unhidden_emails`
-- (См. Ниже фактическое представление)
--
CREATE TABLE `unhidden_emails` (
`user_email` varchar(100)
);

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

CREATE TABLE `users` (
  `user_id` int NOT NULL,
  `user_email` varchar(100) DEFAULT NULL,
  `user_nickname` varchar(100) DEFAULT NULL,
  `user_password` varchar(255) NOT NULL,
  `user_hash` varchar(255) DEFAULT NULL,
  `user_email_confirmed` tinyint(1) DEFAULT '0',
  `user_hide_email` int DEFAULT '0',
  `user_photo` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `users`
--

INSERT INTO `users` (`user_id`, `user_email`, `user_nickname`, `user_password`, `user_hash`, `user_email_confirmed`, `user_hide_email`, `user_photo`) VALUES
(7, 'den74@inbox.ru', 'Den74', '$2y$10$XCkVijaK5JfvJvZaf71b1.VzoipCB6MmyxfEeP5vsKue08UlqlxDO', 'b3dfb5c78220c975293f33a5ba127609', 1, 0, 'den74@inbox.ru.1.png'),
(8, 'den.developer@mail.ru', 'den.developer', '$2y$10$54RMr6884MRcQFVc2rT7nOqKQ5Aap6X.LtmSayRFmsI/zvftfeirq', '915db99d76640fdd810f4c7ea40bdce4', 1, 0, 'den.developer@mail.ru.1.jpg');

-- --------------------------------------------------------

--
-- Структура для представления `unhidden_emails`
--
DROP TABLE IF EXISTS `unhidden_emails`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `unhidden_emails`  AS SELECT `users`.`user_email` AS `user_email` FROM `users` WHERE (`users`.`user_hide_email` = 0) ;

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `chat`
--
ALTER TABLE `chat`
  ADD PRIMARY KEY (`chat_id`),
  ADD KEY `check_creatorid` (`chat_creatorid`);

--
-- Индексы таблицы `chat_message`
--
ALTER TABLE `chat_message`
  ADD PRIMARY KEY (`chat_message_id`),
  ADD KEY `check_message_chatid` (`chat_message_chatid`),
  ADD KEY `check_message_creator` (`chat_message_creatorid`);

--
-- Индексы таблицы `chat_participant`
--
ALTER TABLE `chat_participant`
  ADD PRIMARY KEY (`chat_participant_chatid`,`chat_participant_userid`),
  ADD KEY `check_participant_userid` (`chat_participant_userid`);

--
-- Индексы таблицы `connections`
--
ALTER TABLE `connections`
  ADD PRIMARY KEY (`connection_ws_id`),
  ADD UNIQUE KEY `connection_userid` (`connection_userid`);

--
-- Индексы таблицы `contacts`
--
ALTER TABLE `contacts`
  ADD PRIMARY KEY (`cnt_id`),
  ADD KEY `contacts_fk_userid` (`cnt_user_id`),
  ADD KEY `contacts_fk_contactid` (`cnt_contact_id`);

--
-- Индексы таблицы `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `user_email` (`user_email`),
  ADD UNIQUE KEY `user_nickname` (`user_nickname`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `chat`
--
ALTER TABLE `chat`
  MODIFY `chat_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT для таблицы `chat_message`
--
ALTER TABLE `chat_message`
  MODIFY `chat_message_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT для таблицы `contacts`
--
ALTER TABLE `contacts`
  MODIFY `cnt_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `chat`
--
ALTER TABLE `chat`
  ADD CONSTRAINT `check_creatorid` FOREIGN KEY (`chat_creatorid`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `chat_message`
--
ALTER TABLE `chat_message`
  ADD CONSTRAINT `check_message_chatid` FOREIGN KEY (`chat_message_chatid`) REFERENCES `chat` (`chat_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `check_message_creator` FOREIGN KEY (`chat_message_creatorid`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `chat_participant`
--
ALTER TABLE `chat_participant`
  ADD CONSTRAINT `check_participant_chatid` FOREIGN KEY (`chat_participant_chatid`) REFERENCES `chat` (`chat_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `check_participant_userid` FOREIGN KEY (`chat_participant_userid`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `connections`
--
ALTER TABLE `connections`
  ADD CONSTRAINT `fk_userid` FOREIGN KEY (`connection_userid`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `contacts`
--
ALTER TABLE `contacts`
  ADD CONSTRAINT `contacts_fk_contactid` FOREIGN KEY (`cnt_contact_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `contacts_fk_userid` FOREIGN KEY (`cnt_user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
