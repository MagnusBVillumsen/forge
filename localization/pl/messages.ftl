msg-org-list-no_results = Brak wyników.
msg-org-repo-list-no_results = Brak wyników.
msg-org-team-repo-list-no_results = Brak wyników.
msg-org-team-member-list-no_results = Brak wyników.
msg-repo-migrate-password_prompt = Hasło:
msg-whoami = obecnie zalogowano jako { $name }@{ $host }
msg-auth-login-oauth_unsupported =
    Twoja instalacja forge nie wspiera polecenia `login` dla { $host_domain }

    Odwiedź { $applications_url }
    aby utworzyć token, następnie użyj go aby zalogować się za pomocą `forge auth add-key`
msg-auth-login-canceled = Logowanie anulowane
msg-auth-login-browser_success = Uwierzytelniono! Zamknij tę kartę i powróć do swojego terminala.
msg-auth-login-browser_failure = Uwierzytelnienie zakończone niepowodzeniem.
msg-auth_logout-success = wylogowano z { $host }
msg-auth_logout-already_signed_out = już zostałeś wcześniej wylogowany z { $host }
msg-auth-use_ssh-enabled = od teraz SSH będzie domyślnie używane dla { $host }
msg-auth-use_ssh-disabled = SSH nie będzie więcej domyślnie używane dla { $host }
msg-auth-use_ssh-already_enabled = SSH jest już domyślnie używane dla { $host }
msg-auth-use_ssh-already_disabled = SSH już wcześniej przestało być domyślnie używane dla { $host }
msg-auth-add_token-prompt = nowy klucz:
msg-auth-add_token-already_exists = istnieje już klucz dla { $host }
msg-auth-list-none = Brak zalogowań.
msg-actions-variable-create-already_exists = zmienna już istnieje, użyj --force aby zastąpić
msg-actions-variable-create-already_exists_forced = zmienna już istnieje, aktualizowanie.
msg-actions-variable-delete-success = Usunięto zmienną { $name }.
msg-actions-dispatch-success =
    Zlecono wykonanie procesu pracy { $name } w { $ref } z użyciem { $n_inputs ->
        [one] 1 wejścia
       *[other] { $n_inputs } wejść
    }.
msg-auth-use_ssh-not_logged_in = nie jesteś zalogowany do { $host }
-dash =
    { IS_MINIMAL() ->
        [yes] -
       *[no] —
    }
msg-org-list-page_number = Strona { $page } z { $total }
msg-org-view-org_name =
    { OPT($full_name) ->
       *[none] { STYLE("bold", "bright-cyan") }{ $name }{ STYLE("reset") }
        [some] { STYLE("bold", "bright-cyan") }{ $full_name }{ STYLE("reset") } { STYLE("light-gray") }({ $name }){ STYLE("reset") }
    }
msg-org-view-member_count =
    { $member_count ->
        [one] { STYLE("bold") } 1 { STYLE("reset") } członek
       *[other] { STYLE("bold") }{ $member_count }{ STYLE("reset") } członków
    }
msg-org-view-team_count =
    { $team_count ->
        [one] { STYLE("bold") } 1 { STYLE("reset") } zespół
       *[other] { STYLE("bold") }{ $team_count }{ STYLE("reset") } zespoły
    }
msg-org-create-invalid_character =
    Nazwy organizacji mogą zawierać wyłącznie znaki alfanumeryczne, myślniki, podkreślenia lub kropki.
      Jeśli potrzebujesz nazwy z innymi znakami, spróbuj użyć flagi --full-name
msg-org-members-no_results = Brak wyników.
msg-org-members-page_number = Strona { $page } z { $total }
msg-org-repo-list-page_number = Strona { $page } z { $total }
msg-org-team-view-perms-issues = Zgłoszenia
msg-org-team-view-perms-pulls = Pull Requesty
msg-org-team-view-perms-projects = Projekty
msg-org-team-view-perms-releases = Wydania
msg-org-team-view-perms-packages = Pakiety
msg-org-team-repo-list-page_number = Strona { $page } z { $total }
msg-org-team-member-list-page_number = Strona { $page } z { $total }
msg-issue-create-success = utworzono zgłoszenie #{ $number }: { $title }
msg-issue-templates-none = Brak szablonów zgłoszeń oraz danych kontaktowych.
msg-issue-search-entry = #{ $number }: { $title } (utworzone przez { $author })
msg-issue-edit-title-empty = tytuł nie może być pusty
msg-issue-edit-title-no_newlines = tytuł nie może zawierać znaków nowej linii
msg-issue-close-success = Zamknięto zgłoszenie #{ $number }: "{ $title }"
msg-pr-not_found = nie znaleziono PR
msg-pr-create-agit_success = utworzono pull request: { $title }
msg-pr-create-success = utworzono pull request #{ $number }: { $title }
msg-pr-review-list-none = Brak recenzji.
msg-pr-merge-success = Scalono PR #{ $number } \"{ $title }\" do `{ $base_branch }`
msg-pr-checkout-dirty = Nie można wykonać checkoutu PR; katalog roboczy posiada niezacommitowane zmiany
msg-pr-checkout-not_fork = nie można określić rodzica, { $repo } nie jest forkiem
msg-repo-no_host_given = nie można odnaleźć repozytorium, nie podano hosta
msg-pr-search-entry = #{ $number }: { $title } (utworzony przez { $author })
msg-repo-create-success = utworzono nowe repozytorium pod adresem { $url }
msg-repo-create-branch_invalid_utf8 = nazwa gałęzi nie jest w poprawnym formacie utf-8
msg-repo-migrate-token_prompt = Token:
msg-repo-migrate-migrating = Migrowanie...
msg-repo-migrate-success = Zakończono! Wyświetl online pod adresem { $url }
msg-repo-view-name = { $repo_name }
msg-repo-view-is_fork = Fork { $parent }
msg-repo-view-is_mirror = Kopia lustrzana { $mirror_of }
msg-repo-view-external_tracker = Śledzenie zgłoszeń znajduje się pod adresem { $url }
msg-repo-readme-none = Repozytorium nie posiada README
msg-repo-view-url = Wyświetl online pod adresem { $url }
msg-repo-clone-downloading = { " " }Pobieranie... { NUMBER($percent, maximumFractionDigits: 2) }% ({ NUMBER($size, maximumFractionDigits: 2) }{ $units })
msg-repo-clone-finishing_up = Kończenie...
msg-repo-clone-success = Sklonowano { $repo } do { $path }
msg-repo-star-success = Dodano gwiazdkę do { $owner }/{ $repo }!
msg-repo-unstar-success = Usunięto gwiazdkę z { $owner }/{ $repo }!
msg-repo-delete-success = Usunięto { $owner }/{ $repo }
msg-repo-label-view-no_description = (brak opisu)
msg-user-search-page_zero = Nie istnieje strona 0
msg-user-search-fail = Wyszukiwanie zakończone niepowodzeniem
msg-user-search-none = Żaden użytkownik nie pasuje do tego zapytania
msg-repo-label-edit-success = Zmodyfikowano etykietę: { $label }
msg-repo-label-delete-success = Z powodzeniem usunięto etykietę { $label }
msg-repo-label-create-success = Z powodzeniem utworzono etykietę { $label }
msg-repo-delete-cancelled = Anulowano usunięcie
msg-user-block-success = Zablokowano { $user }
msg-user-unblock-success = Odblokowano { $user }
msg-user-orgs-none-self = Nie jesteś członkiem żadnej organizacji
msg-activity-commented_issue = { STYLE("bold") }{ $actor }{ STYLE("reset") } skomentował zgłoszenie { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") }
msg-activity-merged_pr = { STYLE("bold") }{ $actor }{ STYLE("reset") } scalił pull request { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") }
msg-activity-created_fork = { STYLE("bold") }{ $actor }{ STYLE("reset") } dodał forka repozytorium { STYLE("bold", "yellow") }{ $parent_repo_name }{ STYLE("reset") } to { STYLE("bold", "yellow") }{ $repo_name }{ STYLE("reset") }
msg-user-orgs-count =
    { $organizations ->
        [one] 1 organizacja
       *[other] { $organizations } organizacji
    }
msg-activity-created_mirror = { STYLE("bold") }{ $actor }{ STYLE("reset") } utworzył kopię lustrzaną { STYLE("bold", "yellow") }{ $repo_name }{ STYLE("reset") }
msg-activity-created_repo = { STYLE("bold") }{ $actor }{ STYLE("reset") } utworzył repozytorium { STYLE("bold", "yellow") }{ $repo_name }{ STYLE("reset") }
msg-activity-renamed_repo = { STYLE("bold") }{ $actor }{ STYLE("reset") } zmienił nazwę repozytorium z { STYLE("bold", "yellow") }\"{ $old_name }\"{ STYLE("reset") } na { STYLE("bold", "yellow") }{ $new_name }{ STYLE("reset") }
msg-activity-starred_repo = { STYLE("bold") }{ $actor }{ STYLE("reset") } dodał gwiazdkę do repozytorium { STYLE("bold", "yellow") }{ $repo_name }{ STYLE("reset") }
msg-activity-watched_repo = { STYLE("bold") }{ $actor }{ STYLE("reset") } dodał repozytorium { STYLE("bold", "yellow") }{ $repo_name }{ STYLE("reset") } do obserwowanych
msg-activity-pushed_commit = { STYLE("bold") }{ $actor }{ STYLE("reset") } wypchnął commit do { STYLE("bold", "bright-cyan") }{ $branch }{ STYLE("reset") } w { STYLE("bold", "yellow") }{ $repo_name }{ STYLE("reset") }
msg-activity-created_issue = { STYLE("bold") }{ $actor }{ STYLE("reset") } otworzył zgłoszenie { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") }
msg-activity-created_pr = { STYLE("bold") }{ $actor }{ STYLE("reset") } utworzył pull request { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") }
msg-activity-transferred_repo = { STYLE("bold") }{ $actor }{ STYLE("reset") } przekazał repozytorium { STYLE("bold", "yellow") }\"{ $old_name }\"{ STYLE("reset") } do { STYLE("bold", "yellow") }{ $new_name }{ STYLE("reset") }
msg-activity-pushed_tag = { STYLE("bold") }{ $actor }{ STYLE("reset") } wypchnął tag { STYLE("bold", "bright-cyan") }{ $tag_name }{ STYLE("reset") } do { STYLE("bold", "yellow") }{ $repo_name }{ STYLE("reset") }
msg-activity-closed_issue = { STYLE("bold") }{ $actor }{ STYLE("reset") } zamknął zgłoszenie { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") }
msg-activity-reopened_issue = { STYLE("bold") }{ $actor }{ STYLE("reset") } ponownie otworzył zgłoszenie { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") }
msg-activity-closed_pr = { STYLE("bold") }{ $actor }{ STYLE("reset") } zamknął pr { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") }
msg-activity-reopened_pr = { STYLE("bold") }{ $actor }{ STYLE("reset") } ponownie otworzył pr { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") }
msg-activity-deleted_tag = { STYLE("bold") }{ $actor }{ STYLE("reset") } usunął tag { STYLE("bold", "bright-cyan") }{ $tag_name }{ STYLE("reset") } z { STYLE("bold", "yellow") }{ $repo_name }{ STYLE("reset") }
msg-activity-deleted_branch = { STYLE("bold") }{ $actor }{ STYLE("reset") } usunął gałąź { STYLE("bold", "bright-cyan") }{ $branch }{ STYLE("reset") } z { STYLE("bold", "yellow") }{ $repo_name }{ STYLE("reset") }
msg-activity-approved_pr = { STYLE("bold") }{ $actor }{ STYLE("reset") } zatwierdził { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") }
msg-activity-rejected_pr = { STYLE("bold") }{ $actor }{ STYLE("reset") } zasugerował zmiany do { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") }
msg-activity-commented_pr = { STYLE("bold") }{ $actor }{ STYLE("reset") } skomentował pull request { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") }
msg-activity-created_release = { STYLE("bold") }{ $actor }{ STYLE("reset") } utworzył wydanie { STYLE("bold", "bright-cyan") }{ $release_name }{ STYLE("reset") } w { STYLE("bold", "yellow") }{ $repo_name }{ STYLE("reset") }
msg-user-key-list-count = łącznie kluczy: { $keys }
msg-user-key-list-header = { STYLE("bold") }Klucz { STYLE("bright-magenta") }{ $id }{ STYLE("reset") }
msg-user-key-list-title = { STYLE("bold") }Tytuł:{ STYLE("reset") }       { STYLE("bright-cyan") }{ $title }{ STYLE("reset") }
msg-user-key-delete-success = z powodzeniem usunięto klucz o identyfikatorze { $id }
msg-user-key-upload-keys_not_found = Nie znaleziono kluczy.
msg-user-gpg-upload-exporting = Eksportowanie klucza...
msg-org-members-entry =
    { OPT($full_name) ->
       *[none] { STYLE("bold", "bright-cyan") }{ $username }{ STYLE("reset") }
        [some] { STYLE("bold", "bright-cyan") }{ $full_name }{ STYLE("reset") } { STYLE("light-gray") }({ $username }){ STYLE("reset") }
    }
msg-org-label-add-success = Utworzono nową etykietę { $label }
msg-org-label-remove-success = Usunięto etykietę { $label }
msg-org-team-repo-add-success = Dodano { STYLE("bold") }{ $org }/{ $repo }{ STYLE("reset") } do zespołu { STYLE("bold", "bright-blue") }{ $team }{ STYLE("reset") }
msg-org-team-repo-rm-success = Usunięto { STYLE("bold") }{ $org }/{ $repo }{ STYLE("reset") } z zespołu { STYLE("bold", "bright-blue") }{ $team }{ STYLE("reset") }
msg-org-team-member-add-success = Dodano użytkownika { STYLE("bold", "bright-cyan") }{ $user }{ STYLE("reset") } do zespołu { STYLE("bold", "bright-blue") }{ $team }{ STYLE("reset") }
msg-org-team-member-rm-success = Usunięto użytkownika { STYLE("bold", "bright-cyan") }{ $user }{ STYLE("reset") } z zespołu { STYLE("bold", "bright-blue") }{ $team }{ STYLE("reset") }
msg-org-view-visibility =
    { $visibility ->
        [public] Publiczna
        [limited] Ograniczona
       *[private] Prywatna
    }
msg-org-create-invalid_starting_character =
    Nazwy organizacji mogą się rozpoczynać wyłącznie od znaków alfanumerycznych.
      Jeśli potrzebujesz nazwy zaczynającej się innymi znakami, spróbuj użyć flagi --full-name
msg-org-create-invalid_ending_character =
    Nazwy organizacji mogą kończyć się wyłącznie znakami alfanumerycznymi.
      Jeśli potrzebujesz nazwy kończącej się innymi znakami, spróbuj użyć flagi --full-name
msg-org-create-invalid_consecutive_characters =
    Nazwy organizacji nie mogą zawierać występujących po sobie znaków, które nie są alfanumeryczne.
      Jeśli potrzebujesz takiej nazwy, spróbuj użyć flagi --full-name
msg-org-create-success =
    utworzono nową organizację { $visibility ->
        [public] publiczną
        [limited] ograniczoną
       *[private] prywatną
    } { OPT($full_name) ->
       *[none] { STYLE("bold", "bright-cyan") }{ $name }{ STYLE("reset") }
        [some] { STYLE("bold", "bright-cyan") }{ $full_name }{ STYLE("reset") } { STYLE("light-gray") }({ $name }){ STYLE("reset") }
    }
msg-org-visibility-public = Jesteś publicznym członkiem organizacji { STYLE("bold", "bright-cyan") }{ $org_name }{ STYLE("reset") }
msg-org-visibility-private = Jesteś prywatnym członkiem organizacji { STYLE("bold", "bright-cyan") }{ $org_name }{ STYLE("reset") }
msg-org-visibility-set_public = Jesteś teraz publicznym członkiem organizacji { STYLE("bold", "bright-cyan") }{ $org_name }{ STYLE("reset") }
msg-org-visibility-set_private = Jesteś teraz prywatnym członkiem organizacji { STYLE("bold", "bright-cyan") }{ $org_name }{ STYLE("reset") }
msg-org-visibility-not_member = Nie jesteś członkiem organizacji { STYLE("bold", "bright-cyan") }{ $org_name }{ STYLE("reset") }
msg-org-label-edit-success = Zmieniono etykietę { $old_label } na { $label }
msg-org-team-view-read_only = Tylko Do Odczytu:
msg-org-team-view-read_write = Odczyt/Zapis:
msg-org-team-view-perms-wiki = Wiki
msg-org-team-view-perms-ext_wiki = Zewnętrzne Wiki
msg-org-team-view-perms-ext_issues = Zewnętrzne Zgłoszenia
msg-org-team-view-perms-actions = CI
msg-org-team-view-perms-code = Kod
msg-org-team-create-success =
    utworzono nowy zespół { $admin ->
        [yes] administracyjny
       *[no] { "" }
    } { STYLE("bright-blue", "bold") }{ $name }{ STYLE("reset") } in org { STYLE("bold") }{ $org }{ STYLE("reset") }
msg-org-team-delete-confirmation = Czy na pewno chcesz usunąć zespół { STYLE("bold") }{ $org }/{ $name }{ STYLE("reset") }?
    .yes =
        Tak
        tak
        T
        t
    .no =
        Nie
        nie
        N
        n
msg-issue-create-no_templates = { $owner }/{ $repo } nie posiada żadnych szablonów zgłoszeń
msg-issue-create-templates_required =
    { $owner }/{ $repo } wymaga użycia szablonu.
    Wybierz szablon za pomocą flagi `--template <NAME>`.
msg-issue-view-header =
    { STYLE("yellow") }{ $title } { STYLE("dark-grey") }#{ $number }{ STYLE("reset") }"
    Utworzone przez { STYLE("white") }{ $author }{ STYLE("reset") } { -dash } { $state ->
        [open] { STYLE("bright-green") }Otwarte{ STYLE("reset") }
        [closed] { STYLE("bright-red") }Zamknięte{ STYLE("reset") }
       *[other] $state
    }
msg-issue-view-comment_count =
    { $comments ->
        [one] 1 komentarz
       *[other] { $comments } komentarzy
    }
msg-issue-templates-blank_allowed = Dozwolone używanie flagi '--no-template'
msg-issue-templates-blank_not_allowed = Niedozwolone używanie flagi '--no-template'
msg-issue-view-comments-comment_header =
    { OPT($full_name) ->
       *[none] { STYLE("bold", "bright-cyan") }{ $username }{ STYLE("reset") } skomentował:
        [some] { STYLE("bold", "bright-cyan") }{ $full_name }{ STYLE("reset") } { STYLE("dark-gray") }({ $username }){ STYLE("reset") } skomentował:
    }
msg-issue-view-comments-attachments =
    { $attachments ->
        [one] 1 załącznik
       *[other] { $attachments } załączników
    }
msg-issue-assign-success =
    przypisano { $added ->
        [one] 1 użytkownika
       *[other] { $added } użytkowników
    } do { $owner }/{ $repo }#{ $number } { $duplicate ->
        [0] { "" }
        [one]
            { $added ->
                [0] (użytkownik już został przypisany)
               *[other] (1 użytkownik już został przypisany)
            }
       *[other]
            { $added ->
                [0] (wszyscy użytkownicy już zostali przypisani)
               *[other] ({ $duplicate } użytkowników już zostało przypisanych)
            }
    }
msg-pr-view-comment_count =
    { $comments ->
        [one] 1 komentarz
       *[other] { $comments } komentarzy
    }
msg-pr-review-list-comment_header =
    { STYLE("bold", "bright-cyan") }{ $commenter }{ STYLE("reset") } skomentował { OPT($resolver) ->
       *[none] { "" }
        [some] (komentarz oznaczony jako rozwiązany przez { $resolver })
    }:
msg-pr-create-agit_push_cfg_question =
    Czy chcesz ustawić wymaganą konfigurację git
    żeby polecenie `git push` działało poprawnie dla tego pr?
