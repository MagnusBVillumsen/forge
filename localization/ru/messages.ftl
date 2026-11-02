msg-auth-add_token-prompt = новый ключ:
msg-auth-add_token-already_exists = ключ для { $host } уже добавлен
msg-actions-variable-create-already_exists = переменная уже существует. Добавьте --force, чтобы заменить её.
msg-actions-variable-create-already_exists_forced = переменная уже существует и будет изменена.
msg-actions-variable-delete-success = Переменная { $name } была удалена.
msg-org-list-page_number = Страница { $page } из { $total }
msg-org-view-visibility =
    { $visibility ->
        [public] Публичная
        [limited] Ограниченная
       *[private] Частная
    }
msg-org-create-success =
    создана новая { $visibility ->
        [public] публичная
        [limited] ограниченная
       *[private] приватная
    } организация { OPT($full_name) ->
       *[none] { STYLE("bold", "bright-cyan") }{ $name }{ STYLE("reset") }
        [some] { STYLE("bold", "bright-cyan") }{ $full_name }{ STYLE("reset") } { STYLE("light-gray") }({ $name }){ STYLE("reset") }
    }
msg-org-label-add-success = Создана новая метка { $label }
msg-org-label-edit-success = Метка { $old_label } переименована в { $label }
msg-org-label-remove-success = Метка { $label } была удалена
msg-org-repo-list-page_number = Страница { $page } из { $total }
msg-org-team-view-read_only = Только чтение:
msg-org-team-view-read_write = Чтение и запись:
msg-org-team-view-perms-issues = Задачи
msg-org-team-view-perms-ext_issues = Внешние задачи
msg-org-team-view-perms-releases = Выпуски
msg-org-team-repo-list-page_number = Страница { $page } из { $total }
msg-org-team-member-list-page_number = Страница { $page } из { $total }
msg-issue-create-success = создана задача #{ $number }: { $title }
msg-issue-edit-title-empty = название не может быть пустым
msg-issue-edit-title-no_newlines = название должно быть в одну строку
msg-auth-login-canceled = Вход был отменён
msg-auth-login-browser_success = Вход успешен! Закрывайте эту вкладку и возвращайтесь в консоль.
msg-auth-login-browser_failure = Не удалось войти.
msg-auth-list-none = Нет учётных записей.
msg-repo-migrate-username_prompt = Имя пользователя:
msg-repo-migrate-password_prompt = Пароль:
msg-repo-migrate-token_prompt = Ключ:
msg-repo-view-is_mirror = Зеркало { $mirror_of }
msg-repo-view-primary_language = Основной язык — { $language }
msg-repo-view-is_fork = Ответвление { $parent }
msg-repo-label-view-archived = (архивирована)
msg-repo-label-view-no_description = (без описания)
msg-user-followers-none-self = На вас никто не подписан :(
msg-org-create-invalid_character =
    Название организации может содержать только буквы, цифры и знаки: минусы, нижние подчёркивания и точки.
      Для установки названия с другими символами используйте флаг --full-name
msg-org-create-invalid_starting_character =
    Название организации может начинаться только с буквы.
      Для установки названия, начинающегося с другого символа, используйте флаг --full-name
msg-org-create-invalid_ending_character =
    Название организации может заканчиваться только на букву.
      Для установки названия, заканчивающегося другим символом, используйте флаг --full-name
msg-org-create-invalid_consecutive_characters =
    Название организации не может содержать идущие подряд спец. символы.
      Для установки подобного названия используйте флаг --full-name
msg-org-members-page_number = Страница { $page } из { $total }
msg-org-visibility-public = Вы публичный участник { STYLE("bold", "bright-cyan") }{ $org_name }{ STYLE("reset") }
msg-org-visibility-private = Вы скрытый участник { STYLE("bold", "bright-cyan") }{ $org_name }{ STYLE("reset") }
msg-org-visibility-set_public = Теперь вы публичный участник { STYLE("bold", "bright-cyan") }{ $org_name }{ STYLE("reset") }
msg-org-visibility-set_private = Теперь вы скрытый участник { STYLE("bold", "bright-cyan") }{ $org_name }{ STYLE("reset") }
msg-org-visibility-not_member = Вы не состоите в { STYLE("bold", "bright-cyan") }{ $org_name }{ STYLE("reset") }
msg-org-team-view-perms-wiki = Вики-страницы
msg-org-team-view-perms-ext_wiki = Внешние вики
msg-org-team-view-perms-packages = Пакеты
-dash =
    { IS_MINIMAL() ->
        [yes] -
       *[no] —
    }
msg-auth-login-oauth_unsupported =
    Ваша версия forge не поддерживает `login` для { $host_domain }

    Создайте токен по ссылке { $applications_url }
    и используйте его, чтобы войти с `forge auth add-key`
msg-auth_logout-success = выполнен выход из { $host }
msg-auth_logout-already_signed_out = вход не выполнен в { $host }
msg-whoami = выполнен вход в { $name }@{ $host }
msg-org-list-no_results = Ничего не нашлось.
msg-org-members-no_results = Ничего не нашлось.
msg-org-repo-list-no_results = Ничего не нашлось.
msg-org-team-repo-list-no_results = Ничего не нашлось.
msg-org-team-member-list-no_results = Ничего не нашлось.
msg-org-team-view-perms-projects = Проекты
msg-org-team-view-perms-code = Код
msg-issue-create-no_templates = { $owner }/{ $repo } не содержит шаблонов задач
msg-issue-create-templates_required =
    { $owner }/{ $repo } требует заполнение задач по шаблону.
    Выберите шаблон с `--template <NAME>`.
msg-issue-create-templates_enabled =
    { $owner }/{ $repo } использует шаблоны для задач.
    Выберите шаблон с `--template <NAME>`,
    или укажите `--no-template`, чтобы не использовать шаблон.
msg-issue-view-comments-attachments =
    { $attachments ->
        [one] 1 прикреплённый файл
        [few] { $attachments } прикреплённых файла
       *[many] { $attachments } прикреплённых файлов
    }
msg-issue-view-comment_count =
    { $comments ->
        [one] 1 комментарий
        [few] { $comments } комментария
       *[many] { $comments } комментариев
    }
help-arg-repo = Используемый репозиторий
help-arg-remote = git remote, указывающая на используемый удалённый репозиторий
help-cmd-auth-login-long =
    Войти на сервер

    Страница входа будет открыта в браузере
help-cmd-auth-login = Войти на сервер
help-cmd-auth-logout = Удалить данные о входе для сервера
help-cmd-auth-use_ssh = Вкл./выкл. использование SSH по умолчанию для указанных серверов
msg-auth-use_ssh-not_logged_in = не выполнен вход в { $host }
msg-auth-use_ssh-enabled = теперь по умолчанию для { $host } будет использован SSH
msg-auth-use_ssh-disabled = теперь по умолчанию для { $host } НЕ будет использован SSH
help-cmd-auth-add_token = Добавить токен приложения для сервера
help-cmd-auth-add_token-long =
    Добавить токен приложения для сервера

    Используйте, если `forge auth login` не работает.
help-arg-auth-add_token-token = Добавляемый ключ. Если не указан, будет прочитан из стд. ввода
help-cmd-auth-list = Список всех серверов, на которых выполнен вход
help-cmd-actions-secrets = Список и управление секретами
help-cmd-actions-secrets-list = Вывести секреты списком
help-cmd-actions-secrets-create = Создать новый секрет
help-arg-actions-secrets-create-name = Название нового секрета
help-arg-actions-secrets-create-data = Значение нового секрета
help-cmd-actions-secrets-delete = Удалить секрет
help-arg-actions-secrets-delete-name = Секрет, который нужно удалить
help-cmd-org-list = Вывести все организации списком
help-arg-org-options-full_name = Отображаемое название организации
help-arg-org-options-full_name-long =
    Отображаемое название организации

    В отличии от `name`, не имеет ограничений по типу символов, поддерживает UTF-8.
help-arg-org-options-description = Описание организации
help-arg-org-options-email = Контактный адрес эл. почты организации
help-arg-org-options-location = Расположение организации
help-arg-org-options-website = Веб-сайт организации
help-arg-org-options-visibility = Видимость организации
help-arg-org-options-visibility-long =
    Видимость организации

    Публичные организации видны всем, ограниченные только пользователям с
    учётными записями и частные доступны только участникам организации.
help-cmd-org-create = Создать организацию
help-arg-org-create-name = Название организации
help-arg-org-create-name-long =
    Название организации

    Может включать только латинские буквы, цифры, минусы, нижние подчёркивания и
    точки. Первым и последним символом могут выступать только буквы. Спец. символы
    не могут идти подряд.

    Также доступно отображаемое название организации, не имеющее этих ограничений.
    См. опцию `--full-name`.
help-cmd-org-activity = Смотреть активность в организации
help-arg-org-activity-name = Название организации, где смотреть активность
help-cmd-org-members = Вывести список участников организации
help-arg-org-members-org = Название организации, участников которой вывести
help-cmd-org-label-list = Вывести список всех меток задач, добавленных в организации
help-arg-org-label-list-org = Название организации, метки задач которой вывести
help-cmd-org-label-add = Добавить новую метку задач в организацию
help-arg-org-label-add-org = Название организации, в которую добавить метку задач
help-arg-org-label-add-name = Название добавляемой метки задач
help-arg-org-label-add-color = HEX-код цвета добавляемой метки задач
help-arg-org-label-add-description = Описание добавляемой метки задач
help-cmd-org-label-edit = Изменить метку задач в организации
help-arg-org-label-edit-org = Название организации, в которой находится метка
help-arg-org-label-rm-org = Название организации, в которой находится метка
help-arg-org-label-edit-name = Название изменяемой метки
help-arg-org-label-edit-new_name = Новое название метки
help-arg-org-label-edit-color = Новый HEX-код цвета метки
help-arg-org-label-edit-description = Новое описание метки
help-cmd-org-label-rm = Удалить метку задач из организации
help-arg-org-label-edit-archived = Указать архивный статус метки
help-arg-org-label-rm-label = Название организации, из которой удалить метку
help-cmd-org-repo-list = Вывести список всех репозиториев организации
help-arg-org-repo-list-org = Название организации, репозитории которой вывести
