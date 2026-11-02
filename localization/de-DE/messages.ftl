-dash =
    { IS_MINIMAL() ->
        [yes] -
       *[no] —
    }
msg-whoami = Momentan angemeldet als: { $name }@{ $host }
msg-auth-login-oauth_unsupported =
    Diese Installation von forge unterstützt `login` für { $host_domain } nicht.

    Bitte besuchen Sie { $applications_url },
    um einen Token zu erstellen, und verwenden Sie diesen mit `forge auth add-key`, um sich anzumelden.
msg-auth-login-canceled = Anmeldung abgebrochen
msg-auth-login-browser_success = Authentifiziert! Schließen Sie diesen Tab und gehen sie zurück zu Ihrem Terminal.
msg-auth-login-browser_failure = Authentifikation fehlgeschlagen.
msg-auth_logout-success = Abgemeldet von: { $host }
msg-auth_logout-already_signed_out = Sie sind bereits von { $host } abgemeldet.
msg-auth-use_ssh-not_logged_in = Nicht bei { $host } angemeldet.
msg-auth-use_ssh-enabled = SSH wird jetzt standardmäßig für { $host } verwendet.
msg-auth-use_ssh-disabled = SSH wird nun standardmäßig für { $host } nicht mehr verwendet.
msg-auth-use_ssh-already_enabled = SSH wird bereits standardmäßig für { $host } verwendet.
msg-auth-use_ssh-already_disabled = SSH wird bereits standardmäßig für { $host } nicht verwendet.
msg-auth-add_token-prompt = neuer Schlüssel:
msg-auth-add_token-already_exists = Schlüssel für { $host } existiert bereits
msg-auth-list-none = Kein Logins.
msg-actions-variable-create-already_exists = Die Variable existiert bereits. Übergeben Sie --force, um sie zu ersetzen.
msg-actions-variable-create-already_exists_forced = Variable existiert bereits, aktualisiere...
msg-actions-variable-delete-success = Variable { $name } gelöscht.
msg-actions-dispatch-success =
    Workflow { $name } in { $ref } mit { $n_inputs ->
        [one] 1 Input
       *[other] { $n_inputs } Inputs
    } wurde beauftragt.
msg-org-list-no_results = Keine Ergebnisse.
msg-org-list-page_number = Seite { $page } von { $total }
msg-org-view-org_name =
    { OPT($full_name) ->
       *[none] { STYLE("bold", "bright-cyan") }{ $name }{ STYLE("reset") }
        [some] { STYLE("bold", "bright-cyan") }{ $full_name }{ STYLE("reset") } { STYLE("light-gray") }({ $name }){ STYLE("reset") }
    }
msg-org-view-visibility =
    { $visibility ->
        [public] Öffentlich
        [limited] Begrenzt
       *[private] Privat
    }
msg-org-view-member_count =
    { $member_count ->
        [one] { STYLE("bold") }1{ STYLE("reset") } Mitglied
       *[other] { STYLE("bold") }{ $member_count }{ STYLE("reset") } Mitglieder
    }
msg-org-view-team_count =
    { $team_count ->
        [one] { STYLE("bold") }1{ STYLE("reset") } Team
       *[other] { STYLE("bold") }{ $team_count }{ STYLE("reset") } Teams
    }
msg-org-create-invalid_character =
    Organisationsnamen können nur alphanumerische Zeichen, Striche, Unterstriche oder Punkte enthalten.
      Wenn Sie einen Namen mit anderen Zeichen verwenden möchten, versuchen Sie, die --full-name-Flag zu setzen.
msg-org-create-invalid_starting_character =
    Organisationsnamen können nur mit alphanumerischen Zeichen anfangen.
      Wenn Sie einen Namen, der mit anderen Zeichen anfängt, verwenden möchten, versuchen Sie, die --full-name-Flag zu setzen.
msg-org-create-invalid_ending_character =
    Organisationsnamen können nur mit alphanumerischen Zeichen enden.
      Wenn Sie einen Namen, der mit anderen Zeichen endet, verwenden möchten, versuchen Sie, die --full-name-Flag zu setzen.
msg-org-create-invalid_consecutive_characters =
    Organisationsnamen können keine aufeinanderfolgenden nichtalphanumerischen Zeichen enthalten.
      Wenn Sie dennoch einen solchen Namen verwenden möchten, versuchen Sie, die --full-name-Flag zu setzen.
msg-org-create-success =
    Neue { $visibility ->
        [public] öffentliche
        [limited] begrenzte
       *[private] private
    } Organisation { OPT($full_name) ->
       *[none] { STYLE("bold", "bright-cyan") }{ $name }{ STYLE("reset") }
        [some] { STYLE("bold", "bright-cyan") }{ $full_name }{ STYLE("reset") } { STYLE("light-gray") }({ $name }){ STYLE("reset") }
    } erstellt.
msg-org-members-no_results = keine Ergebnisse.
msg-org-members-page_number = Seite { $page } von { $total }
msg-org-members-entry =
    { OPT($full_name) ->
       *[none] { STYLE("bold", "bright-cyan") }{ $username }{ STYLE("reset") }
        [some] { STYLE("bold", "bright-cyan") }{ $full_name }{ STYLE("reset") } { STYLE("light-gray") }({ $username }){ STYLE("reset") }
    }
msg-org-visibility-public = Sie sind ein öffentliches Mitglied von { STYLE("bold", "bright-cyan") }{ $org_name }{ STYLE("reset") }
msg-org-visibility-private = Sie sind ein privates Mitglied von { STYLE("bold", "bright-cyan") }{ $org_name }{ STYLE("reset") }
msg-org-visibility-set_public = Sie sind nun ein öffentliches Mitglied von { STYLE("bold", "bright-cyan") }{ $org_name }{ STYLE("reset") }
msg-org-visibility-set_private = Sie sind nun ein privates Mitglied von { STYLE("bold", "bright-cyan") }{ $org_name }{ STYLE("reset") }
msg-org-visibility-not_member = Sie sind kein Mitglied von { STYLE("bold", "bright-cyan") }{ $org_name }{ STYLE("reset") }
msg-org-label-add-success = Neues Label { $label } erstellt.
msg-org-label-edit-success = Label von { $old_label } zu { $label } umgeändert.
msg-org-label-remove-success = Label { $label } entfernt.
msg-org-repo-list-no_results = Keine Ergebnisse.
msg-org-repo-list-page_number = Seite { $page } von { $total }
msg-org-team-view =
    { STYLE("bright-blue", "bold") }{ $name }{ STYLE("reset") } in Organisation { STYLE("bold") }{ $org }{ STYLE("reset") } { $admin ->
        [yes] { -dash } { STYLE("bright-red") }Admin{ STYLE("reset") }
       *[no] { "" }
    }
msg-org-team-view-read_only = nur lesen:
msg-org-team-view-read_write = lesen/schreiben:
msg-org-team-view-perms-wiki = Wikis
msg-org-team-view-perms-ext_wiki = Externe Wikis
msg-org-team-view-perms-issues = Issues
msg-org-team-view-perms-ext_issues = Externe Issues
msg-org-team-view-perms-pulls = Pull-Requests
msg-org-team-view-perms-projects = Projekte
msg-org-team-view-perms-actions = CI
msg-org-team-view-perms-code = Code
msg-org-team-view-perms-releases = Releases
msg-org-team-view-perms-packages = Pakete
msg-org-team-create-success =
    Neues { $admin ->
        [yes] Adminteam
       *[no] Team
    } { STYLE("bright-blue", "bold") }{ $name }{ STYLE("reset") } in Organisation { STYLE("bold") }{ $org }{ STYLE("reset") } erstellt.
msg-org-team-delete-confirmation = Sind Sie sicher, dass Sie { STYLE("bold") }{ $org }/{ $name }{ STYLE("reset") } löschen möchten? (j/N)
    .yes =
        Ja
        ja
        J
        j
    .no =
        Nein
        nein
        N
        n
msg-org-team-repo-list-no_results = Keine Ergebnisse.
msg-org-team-repo-list-page_number = Seite { $page } von { $total }
msg-org-team-repo-add-success = { STYLE("bold") }{ $org }/{ $repo }{ STYLE("reset") } zu Team { STYLE("bold", "bright-blue") }{ $team }{ STYLE("reset") } hinzugefügt.
msg-org-team-repo-rm-success = { STYLE("bold") }{ $org }/{ $repo }{ STYLE("reset") } von Team { STYLE("bold", "bright-blue") }{ $team }{ STYLE("reset") } entfernt.
msg-org-team-member-list-no_results = Keine Ergebnisse.
msg-org-team-member-list-page_number = Seite { $page } von { $total }
msg-org-team-member-add-success = { STYLE("bold") }{ $user }{ STYLE("reset") } zu Team { STYLE("bold", "bright-blue") }{ $team }{ STYLE("reset") } hinzugefügt.
msg-org-team-member-rm-success = { STYLE("bold", "bright-cyan") }{ $user }{ STYLE("reset") } von Team { STYLE("bold", "bright-blue") }{ $team }{ STYLE("reset") } entfernt.
msg-issue-create-no_templates = { $owner }/{ $repo } hat keine Issuevorlagen.
msg-issue-create-templates_required =
    { $owner }/{ $repo } setzt die Nutzung einer Issuevorlage vorraus.
    Bitte wählen Sie mit `--template <NAME>` eine Vorlage.
msg-issue-create-templates_enabled =
    { $owner }/{ $repo } verwendet Issuevorlagen.
    Bitte wählen Sie mit `--template <NAME>` eine Vorlage,
    oder verwenden Sie `--no-template`, um von Grund auf eine Issue zu schreiben.
msg-issue-create-success = Issue #{ $number } erstellt: { $title }
msg-issue-view-header =
    { STYLE("yellow") }{ $title } { STYLE("dark-grey") }#{ $number }{ STYLE("reset") }"
    Von { STYLE("white") }{ $author }{ STYLE("reset") } { -dash } { $state ->
        [open] { STYLE("bright-green") }Offen{ STYLE("reset") }
        [closed] { STYLE("bright-red") }Geschlossen{ STYLE("reset") }
       *[other] $state
    }
msg-issue-view-comment_count =
    { $comments ->
        [one] 1 Kommentar
       *[other] { $comments } Kommentare
    }
msg-issue-search-entry = #{ $number }: { $title } (von { $author })
msg-issue-templates-none = Keine Issuevorlagen oder Kontaktdaten.
msg-issue-templates-blank_allowed = '--no-template' ist zulässig
msg-issue-templates-blank_not_allowed = '--no-template' ist unzulässig
msg-issue-view-comments-comment_header =
    { OPT($full_name) ->
       *[none] { STYLE("bold", "bright-cyan") }{ $username }{ STYLE("reset") } schrieb:
        [some] { STYLE("bold", "bright-cyan") }{ $full_name }{ STYLE("reset") } { STYLE("dark-gray") }({ $username }){ STYLE("reset") } schrieb:
    }
msg-issue-view-comments-attachments =
    { $attachments ->
        [one] 1 Anhang
       *[other] { $attachments } Anhänge
    }
msg-issue-edit-title-empty = Der Titel darf nicht leer sein.
msg-issue-edit-title-no_newlines = Der Titel darf keine Zeilenumbrüche enthalten.
msg-issue-assign-success =
    { $added } Nutzer { $added ->
        [one] wurde
       *[other] wurden
    } zu { $owner }/{ $repo }#{ $number } zugewiesen. { $duplicate ->
        [0] { "" }
        [one]
            { $added ->
                [0] (Nutzer war bereits zuständig)
               *[other] (1 Nutzer war bereits zuständig)
            }
       *[other]
            { $added ->
                [0] (Alle Nutzer waren bereits zuständig)
               *[other] ({ $duplicate } Nutzer waren bereits zuständig)
            }
    }
msg-issue-unassign-success =
    Zuständigkeit { $removed ->
        [one] eines Nutzers
       *[other] von { $removed } Nutzern
    } wurde von { $owner }/{ $repo }#{ $number } entfernt. { $duplicate ->
        [0] { "" }
        [one]
            { $removed ->
                [0] (Nutzer war bereits nicht zuständig)
               *[other] (1 Nutzer war bereits nicht zuständig)
            }
       *[other]
            { $removed ->
                [0] (Alle Nutzer waren bereits nicht zuständig)
               *[other] ({ $duplicate } Nutzer waren bereits nicht zuständig)
            }
    }
msg-issue-close-success = Issue #{ $number } geschlossen: "{ $title }"
msg-pr-couldnt_guess = Die Zahl des Pull-Requests konnte nicht erraten werden, bitte angeben.
msg-pr-not_found = Pull-Request konnte nicht gefunden werden.
msg-pr-view-header =
    { STYLE("yellow") }{ $title } { STYLE("dark-grey") }#{ $number }{ STYLE("reset") }
    Von { STYLE("white") }{ $username }{ STYLE("reset") } { -dash } { $state ->
        [draft] { STYLE("light-grey") }Entwurf{ STYLE("reset") }
        [open] { STYLE("bright-green") }Offen{ STYLE("reset") }
        [merged] { STYLE("bright-magenta") }Zusammengeführt{ STYLE("reset") }
        [closed] { STYLE("bright-red") }Geschlossen{ STYLE("reset") }
       *[other] $state
    } { -dash } { STYLE("bright-green") }+{ $additions } { STYLE("bright-red") }-{ $deletions }{ STYLE("reset") }
    { OPT($head_branch) ->
       *[none] In `{ $base_branch }`
        [some] Von `{ $head_branch }` in `{ $base_branch }`
    }
msg-pr-view-comment_count =
    { $comments ->
        [one] 1 Kommentar
       *[other] { $comments } Kommentare
    }
msg-pr-status-merged = { STYLE("bright-magenta") }Zusammengeführt{ STYLE("reset") } von { $merged_by } am { DATETIME($merged_at, dateStyle: "long", timeStyle: "long") }
msg-pr-status-header =
    { $state ->
        [draft] { STYLE("light-grey") }Draft{ STYLE("reset") } { -dash } Entwurf PR kann nicht zusammengeführt werden
        [open]
            { STYLE("bright-green") }Open{ STYLE("reset") } { -dash } { $mergeable ->
               *[yes] Kann zusammengeführt werden
                [no] { STYLE("bright-red") }Hat Konflikte mit dem Ziel-Branch{ STYLE("reset") }
            }
        [closed] { STYLE("bright-red") }Geschlossen{ STYLE("reset") } { -dash } zum Zusammenführen wieder öffnen
       *[other] Unbekannt
    }
msg-pr-status-entry =
    { $state ->
        [success] { STYLE("bright-green") }Erfolg{ STYLE("reset") }
        [pending] { STYLE("yellow") }Ausstehened{ STYLE("reset") }
        [warning] { STYLE("bright-yellow") }Warnung{ STYLE("reset") }
        [failure] { STYLE("bright-red") }Fehlgeschlagen{ STYLE("reset") }
        [error] { STYLE("bright-red") }Fehler{ STYLE("reset") }
       *[other] Unbekannt
    } { -dash } { $context }
msg-pr-review-list-none = Kein Sichtungen.
msg-pr-review-list-only_stale = Nur alte oder abgelehnte Sichtungen. Nutzen Sie --all, um sie alle anzuzeigen.
msg-pr-review-list-review_header =
    { $review_type ->
        [approved] { STYLE("bright-green") }Genehmigt{ STYLE("reset") }
        [changes-requested] { STYLE("bright-yellow") }Änderungen angefragt{ STYLE("reset") }
        [comment] { STYLE("bright-yellow") }Kommentar{ STYLE("reset") }
        [pending] { STYLE("light-grey") }Ausstehende Sichtung{ STYLE("reset") }
       *[other] Unbekannt
    } von { STYLE("bold") }{ $reviewer }{ STYLE("reset") }
    { STYLE("dark-grey") }{ $comments ->
        [one] 1 Kommentar
       *[other] { $comments } Kommentare
    }, erstellt am { DATETIME($timestamp, dateStyle: "long", timeStyle: "short") }{ STYLE("reset") } { $state ->
        [stale] { STYLE("bold") }(alt){ STYLE("reset") }
        [dismissed] { STYLE("bold") }(abgelehnt){ STYLE("reset") }
       *[other] { "" }
    }
msg-pr-review-list-comment_position = In { STYLE("bold") }{ $path }:{ $position }{ STYLE("reset") }:
msg-pr-review-list-comment_header =
    { STYLE("bold", "bright-cyan") }{ $commenter }{ STYLE("reset") } kommentierte { OPT($resolver) ->
       *[none] { "" }
        [some] (erledigt von { $resolver })
    }:
msg-pr-create-cross_instance = Kann keinen Pull-Request zwischen Instanzen erstellen; Basis ist auf { $base_instance }, während der Kopf { $head_instance } verfolgt.
msg-pr-create-success = Pull-Request #{ $number } erstellt: { $title }
msg-pr-create-agit_success = Pull-Request erstellt: { $title }
msg-pr-create-agit_push_cfg_question =
    Möchten Sie die nötige Konfiguration für Git setzen,
    sodass `git push` für diesen PR verwendet werden kann?
msg-pr-create-agit_push_cfg_prompt = (j/N/?)
    .yes =
        Ja
        ja
        J
        j
    .no =
        Nein
        nein
        N
        n
    .help =
        Hilfe
        hilfe
        H
        h
        ?
msg-pr-create-agit_force_push_warning =
    { STYLE("bold") }Bemerkung:{ STYLE("reset") }
      `git push --force[-with-lease]` wird für AGit PRs nicht unterstützt.
      Sie können statdessen `git push -o force=true` verwenden.
msg-pr-create-agit_push_cfg_help = Dies würde die folgenden Konfigurationsoptionen setzen:
msg-pr-merge-commit_title_unsupported-rebase = Rebase unterstützt keinen Committitel
msg-pr-merge-commit_title_unsupported-ff = ff-only unterstützt keinen Committitel
msg-pr-merge-commit_title_unsupported-manual = Manuelles Zusammenführen unterstützt keinen Committitel
msg-pr-merge-default_message = Reviewed-on: { $pr_url }
msg-pr-merge-success = PR #{ $number } \"{ $title }\" wurde mit `{ $base_branch }` zusammengeführt
msg-pr-checkout-dirty = Kann PR nicht auschecken; Arbeitsordner hat nicht-commitete Änderungen
msg-pr-checkout-not_fork = Kann Vaterrepo nicht finden, { $repo } ist keine Fork
msg-pr-checkout-success =
    PR #{ $number } ausgecheckt: { $title }
    { $new_branch ->
       *[yes] Auf neuem Branch { $branch_name }
        [no] Branch wurde auf neusten Commit aktualisiert
    }
msg-pr-search-entry = #{ $number }: { $title } (von { $author })
msg-pr-view-diff-volatile = Änderungen in der Diff werden nicht beibehalten.
msg-repo-no_host_given = Repo kann nicht gefunden werden, keinen Host angegeben.
msg-repo-no_info_given =
    Keine Repoinformationen angegeben.

    Wenn Sie versuchen, mit dem Repo im momentanen Ordner zu arbeiten, versuchen Sie, ein Remote
    hinzuzufügen, die die Forgejoinstanz referenziert. Wenn Sie mehrere Remotes haben, versuchen Sie,
    eines davon als Upstream des momentanen Branches zu setzen.
    Sie können auch mit dem `--host`-Argument explizit einen Host angeben.
msg-repo-fallback_host-invalid_url = Warnung: `FJ_FALLBACK_HOST` ist keine gültige URL!
msg-repo-arg_no_owner = Reponame sollte im Format [HOST/]OWNER/NAME sein.
msg-repo-name_needed = Reponame konnte nicht gefunden werden, bitte angeben.
msg-repo-create-remote_exists = Ein Remote namens \"{ $remote_name }\" existiert bereits.
msg-repo-create-success = Neues Repo bei { $url } erstellt.
msg-repo-create-detached_head = HEAD ist auf keinem Branch; kann nicht auf ein Remote schieben.
msg-repo-create-branch_invalid_utf8 = Der Branchname ist kein gültiges UTF-8.
msg-repo-fork-conflicting_hosts = Die Hosts { $host_a } und { $host_b } stehen im Konflikt. Bitte geben Sie nur einen an.
msg-repo-fork-success = { $parent_owner }/{ $parent_name } wurde zu { $fork_name } geforkt.
msg-repo-migrate-git_only =
    Migration von einem `git`-Dienst unterstützt keine Gegenstände außer LFS.
    Bitte geben sie einen anderen Dienst an oder entfernen sie die anderen Gegenstände.
msg-repo-migrate-username_prompt = Nutzername:
msg-repo-migrate-password_prompt = Passwort:
msg-repo-migrate-token_prompt = Token:
msg-repo-migrate-migrating = Migriere...
msg-repo-migrate-success = Fertig! Online verfügbar bei { $url }
msg-repo-view-name = { $repo_name }
msg-repo-view-is_fork = Fork von { $parent }
msg-repo-view-is_mirror = Spiegel von { $mirror_of }
msg-repo-view-primary_language = Hauptsprache ist { $language }
msg-repo-view-stars =
    { $stars ->
        [one] 1 Favorit
       *[other] { $stars } Favoriten
    }
msg-repo-view-watching = { $watching } Beobachter
msg-repo-view-forks =
    { $forks ->
        [one] 1 fork
       *[other] { $forks } forks
    }
msg-repo-view-issues =
    { $issues ->
        [one] 1 Issue
       *[other] { $issues } Issues
    }
msg-repo-view-prs =
    { $pull_requests ->
        [one] 1 PR
       *[other] { $pull_requests } PRs
    }
msg-repo-view-releases =
    { $releases ->
        [one] 1 Release
       *[other] { $releases } Releases
    }
msg-repo-view-external_tracker = Issuetracker ist bei { $url }
msg-repo-view-url = Online öffnen bei { $url }
msg-repo-readme-none = Repo hat keine README
msg-repo-clone-preparing = { "  " }Vorbereiten...
msg-repo-clone-downloading = { "" }Herunterladen... { NUMBER($percent, maximumFractionDigits: 2) }% ({ NUMBER($size, maximumFractionDigits: 2) }{ $units })
msg-repo-clone-resolving = { "     " }Auflösen... { NUMBER($percent, maximumFractionDigits: 2) }%
msg-repo-clone-finishing_up = { "" }Fertig machen...
msg-repo-clone-success = { $repo } wurde nach { $path } geklont.
msg-repo-star-success = { $owner }/{ $repo } favorisiert!
msg-repo-unstar-success = { $owner }/{ $repo } entfavorisiert!
msg-repo-delete-confirmation_prompt = Sind Sie sicher, dass Sie { $owner }/{ $name } löschen möchten? (y/N)
    .yes =
        Ja
        ja
        J
        j
    .no =
        Nein
        nein
        N
        n
msg-repo-delete-success = { $owner }/{ $repo } gelöscht.
msg-repo-delete-cancelled = Nichts wurde gelöscht.
msg-repo-label-view-archived = (archiviert)
msg-repo-label-view-no_description = (keine Beschreibung)
msg-repo-label-create-success = Label { $label } erfolgreich erstellt.
msg-repo-label-delete-success = Label { $label } erfolgreich gelöscht.
msg-repo-label-edit-success = Label bearbeitet: { $label }
msg-user-search-page_zero = Es gibt keine nullte Seite.
msg-user-search-fail = Suche fehlgeschlagen
msg-user-search-none = Keine Nutzer passten auf diese Anfrage.
msg-user-search-page_too_high =
    { $total_pages ->
        [one] Es gibt nur eine Seite.
       *[other] Es gibt nur { $total_pages } Seiten.
    }
msg-user-search-footer =
    Zeige { STYLE("bold") }{ $first_index }{ -dash }{ $last_index }{ STYLE("reset") } von { STYLE("bold") }{ $total_results }{ STYLE("reset") } Ergebnissen ({ $page }/{ $total_pages })
    { $more ->
        [yes] Zeigen Sie mehr mit der `--page`-Flag an.
       *[no] { "" }
    }
msg-user-view-header =
    { STYLE("bright-cyan", "bold") }{ $username }{ STYLE("reset") } { OPT($pronouns) ->
       *[none] { "" }
        [some] { STYLE("light-grey") } { -dash } { STYLE("bold") }{ $pronouns }{ STYLE("reset") }
    }
    { $followers ->
        [one] { STYLE("bold") }1{ STYLE("reset") } Follower
       *[other] { STYLE("bold") }{ $followers }{ STYLE("reset") } Followers
    } { -dash } { STYLE("bold") }{ $following }{ STYLE("reset") } folge ich
    { OPT($website) ->
       *[none]
            { OPT($email) ->
               *[none] { "" }
                [some] { STYLE("bold") }{ $email }{ STYLE("reset") }
            }
        [some]
            { OPT($email) ->
               *[none] { STYLE("bold") }{ $website }{ STYLE("reset") }
                [some] { STYLE("bold") }{ $website }{ STYLE("reset") } { -dash } { STYLE("bold") }{ $email }{ STYLE("reset") }
            }
    }
msg-user-view-joined_on = Am { STYLE("bold") }{ DATETIME($joined, dateStyle: "medium") }{ STYLE("reset") } beigetreten.
msg-user-follow-success = { $username } gefolgt.
msg-user-unfollow-success = { $username } entfolgt.
msg-user-following-none-other = { $user } folgt niemandem.
msg-user-following-none-self = Sie folgen niemandem.
msg-user-following-other = { $user } folgt:
msg-user-following-self = Sie folgen:
msg-user-followers-none-other = { $user } hat keine Follower
msg-user-followers-none-self = Sie haben keine Follower :(
msg-user-followers-other = { $user } wird gefolgt von:
msg-user-followers-self = Sie werden gefolgt von:
msg-user-block-success = { $user } blockiert.
msg-user-unblock-success = { $user } entblockiert.
msg-user-repos-none-starred-other = { $name } hat keine Repos favorisiert.
msg-user-repos-none-starred-self = Sie haben keine Repos favorisiert.
msg-user-repos-none-other = { $name } besitzt keine Repos.
msg-user-repos-none-self = Sie besitzen keine Repos.
msg-user-repos-list_footer =
    Zeige { STYLE("bold") }{ $first_index }{ -dash }{ $last_index }{ STYLE("reset") } von { STYLE("bold") }{ $total_results }{ STYLE("reset") } Ergebnissen ({ $page }/{ $total_pages })
    { $more ->
        [yes] Zeigen Sie mehr mit der `--page`-Flag an.
       *[no] { "" }
    }
msg-user-orgs-none-other = { $user } ist kein Mitglied einer Organisation.
msg-user-orgs-none-self = Sie sind keine Mitglied einer Organisation.
msg-user-orgs-count =
    { $organizations ->
        [one] 1 Organisation
       *[other] { $organizations } Organisationen
    }
msg-activity-created_fork = { STYLE("bold") }{ $actor }{ STYLE("reset") } hat Fork { STYLE("bold", "yellow") }{ $parent_repo_name }{ STYLE("reset") } nach { STYLE("bold", "yellow") }{ $repo_name }{ STYLE("reset") } erstellt
msg-activity-created_mirror = { STYLE("bold") }{ $actor }{ STYLE("reset") } hat Spiegel { STYLE("bold", "yellow") }{ $repo_name }{ STYLE("reset") } erstellt
msg-activity-created_repo = { STYLE("bold") }{ $actor }{ STYLE("reset") } hat Repo { STYLE("bold", "yellow") }{ $repo_name }{ STYLE("reset") } erstellt
msg-activity-renamed_repo = { STYLE("bold") }{ $actor }{ STYLE("reset") } hat Repo von { STYLE("bold", "yellow") }\"{ $old_name }\"{ STYLE("reset") } zu { STYLE("bold", "yellow") }{ $new_name }{ STYLE("reset") } umbenannt
msg-activity-starred_repo = { STYLE("bold") }{ $actor }{ STYLE("reset") } hat Repo { STYLE("bold", "yellow") }{ $repo_name }{ STYLE("reset") } favorisiert
msg-activity-watched_repo = { STYLE("bold") }{ $actor }{ STYLE("reset") } hat angefangen, Repo { STYLE("bold", "yellow") }{ $repo_name }{ STYLE("reset") } zu beobachten
msg-activity-pushed_commit = { STYLE("bold") }{ $actor }{ STYLE("reset") } hat nach { STYLE("bold", "bright-cyan") }{ $branch }{ STYLE("reset") } auf { STYLE("bold", "yellow") }{ $repo_name }{ STYLE("reset") } geschoben
msg-activity-created_issue = { STYLE("bold") }{ $actor }{ STYLE("reset") } hat Issue { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") } erstellt
msg-activity-created_pr = { STYLE("bold") }{ $actor }{ STYLE("reset") } hat Pull-Request { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") } erstellt
msg-activity-transferred_repo = { STYLE("bold") }{ $actor }{ STYLE("reset") } hat Repo { STYLE("bold", "yellow") }\"{ $old_name }\"{ STYLE("reset") } nach { STYLE("bold", "yellow") }{ $new_name }{ STYLE("reset") } transferriert
msg-activity-pushed_tag = { STYLE("bold") }{ $actor }{ STYLE("reset") } hat Tag { STYLE("bold", "bright-cyan") }{ $tag_name }{ STYLE("reset") } nach { STYLE("bold", "yellow") }{ $repo_name }{ STYLE("reset") } geschoben
msg-activity-commented_issue = { STYLE("bold") }{ $actor }{ STYLE("reset") } hat zu Issue { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") } kommentiert
msg-activity-merged_pr = { STYLE("bold") }{ $actor }{ STYLE("reset") } hat Pull-Request { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") } zusammengeführt
msg-activity-closed_issue = { STYLE("bold") }{ $actor }{ STYLE("reset") } hat Issue { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") } geschlossen
msg-activity-reopened_issue = { STYLE("bold") }{ $actor }{ STYLE("reset") } hat Issue { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") } wieder geöffnet
msg-activity-closed_pr = { STYLE("bold") }{ $actor }{ STYLE("reset") } hat Pull-Request { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") } geschlossen
msg-activity-reopened_pr = { STYLE("bold") }{ $actor }{ STYLE("reset") } hat Pull-Request { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") } wieder geöffnet
msg-activity-deleted_tag = { STYLE("bold") }{ $actor }{ STYLE("reset") } hat Tag { STYLE("bold", "bright-cyan") }{ $tag_name }{ STYLE("reset") } von { STYLE("bold", "yellow") }{ $repo_name }{ STYLE("reset") } gelöscht
msg-activity-deleted_branch = { STYLE("bold") }{ $actor }{ STYLE("reset") } hat Branch { STYLE("bold", "bright-cyan") }{ $branch }{ STYLE("reset") } von { STYLE("bold", "yellow") }{ $repo_name }{ STYLE("reset") } gelöscht
msg-activity-approved_pr = { STYLE("bold") }{ $actor }{ STYLE("reset") } hat { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") } genehmigt
msg-activity-rejected_pr = { STYLE("bold") }{ $actor }{ STYLE("reset") } hat Änderungen für { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") } angefragt
msg-activity-commented_pr = { STYLE("bold") }{ $actor }{ STYLE("reset") } hat zu Pull-Request { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") } kommentiert
msg-activity-created_release = { STYLE("bold") }{ $actor }{ STYLE("reset") } hat Release { STYLE("bold", "bright-cyan") }{ $release_name }{ STYLE("reset") } auf { STYLE("bold", "yellow") }{ $repo_name }{ STYLE("reset") } erstellt
msg-user-edit-name-removal_hint = Nutzen Sie --unset, um Ihren Namen von Ihrem Profil zu löschen
msg-user-edit-pronouns-removal_hint = Nutzen Sie --unset, um Ihre Pronomen von Ihrem Profil zu löschen
msg-user-edit-location-removal_hint = Nutzen Sie --unset, um Ihren Ort von Ihrem Profil zu löschen
msg-user-edit-website-removal_hint = Nutzen Sie --unset, um Ihre Webseite von Ihrem Profil zu löschen
msg-user-key-list-count = gesamte Schlüssel: { $keys }
msg-user-key-list-header = { STYLE("bold") }Schlüssel { STYLE("bright-magenta") }{ $id }{ STYLE("reset") }
msg-user-key-list-title = { STYLE("bold") }Titel:{ STYLE("reset") }         { STYLE("bright-cyan") }{ $title }{ STYLE("reset") }
msg-user-key-list-created_at = { STYLE("bold") }Erstellt am:{ STYLE("reset") }   { STYLE("bright-cyan") }{ DATETIME($created_at, dateStyle: "short", timeStyle: "medium") }{ STYLE("reset") }
msg-user-key-list-type = { STYLE("bold") }Typ:{ STYLE("reset") }           { STYLE("bright-cyan") }{ $key_type }{ STYLE("reset") }
msg-user-key-list-fingerprint = { STYLE("bold") }Fingerabdruck:{ STYLE("reset") } { STYLE("bright-cyan") }{ $fingerprint }{ STYLE("reset") }
msg-user-key-delete-success = Schlüssel mit ID { $id } erfolgreich gelöscht.
msg-user-key-upload-home_not_found = Persönlicher Ordner konnte nicht gefunden werden. Bitte geben Sie explizit einen Pfad für die Schlüsseldatei an.
msg-user-key-upload-keys_not_found = Keine Schlüssel gefunden.
msg-user-key-upload-confirm_key_file_prompt =
    Erratene Schlüsseldatei: { $path }
    Sieht das gut Aus? (j/N)
    .yes =
        Ja
        ja
        J
        j
    .no =
        Nein
        nein
        N
        n
msg-user-key-add-file_unconfirmed = Nutzer hat erratene Schlüsseldatei nicht bestätigt.
msg-user-key-add-unexpected_extension =
    '{ $path }' endet nicht mit '.pub'. Sind Sie sicher, dass dies kein privater Schlüssel ist?
     Wenn Sie dennoch fortfahren möchten, übergeben Sie --force.
msg-user-key-add-invalid_key =
    '{ $path }' sieht aus wie ein privater Schlüssel oder ungültige Daten!
     Wenn Sie dennoch fortfahren möchten, übergeben Sie --force.
msg-user-key-add-no_title = Schlüsseldatei konnte nicht erraten werden. Bitte übergeben Sie sie explizit und prüfen sie Ihre Schlüsseldatei.
msg-user-key-upload-confirm_key_title_prompt =
    Erratener Titel: { STYLE("bright-cyan") }{ $title }{ STYLE("reset") }
    Sieht das gut aus? (j/N)
    .yes =
        Ja
        ja
        J
        j
    .no =
        Nein
        nein
        N
        n
msg-user-key-add-title_unconfirmed = Nutzer hat erratenen Titel nicht bestätigt.
msg-user-key-add-success = Schlüssel erfolgreich erstellt!
msg-user-gpg-list-count = gesamte Schlüssel: { $keys }
msg-user-gpg-list-header = { STYLE("bold") }Schlüssel { STYLE("bright-magenta") }{ $id }{ STYLE("reset") }
msg-user-gpg-list-key_id = { STYLE("bold") }Schlüssel ID:{ STYLE("reset") }                     { STYLE("bright-cyan") }{ $key_id }{ STYLE("reset") }
msg-user-gpg-list-can_sign =
    { STYLE("bold") }Kann signieren:{ STYLE("reset") }                   { $can_sign ->
        [yes] { STYLE("bright-green") }true{ STYLE("reset") }
       *[no] { STYLE("bright-red") }false{ STYLE("reset") }
    }
msg-user-gpg-list-can_encrypt_comms =
    { STYLE("bold") }Kann Kommunikation verschlüsseln:{ STYLE("reset") } { $can_encrypt_comms ->
        [yes] { STYLE("bright-green") }true{ STYLE("reset") }
       *[no] { STYLE("bright-red") }false{ STYLE("reset") }
    }
msg-user-gpg-list-can_encrypt_storage =
    { STYLE("bold") }Kann Speicher verschlüsseln:{ STYLE("reset") }      { $can_encrypt_storage ->
        [yes] { STYLE("bright-green") }true{ STYLE("reset") }
       *[no] { STYLE("bright-red") }false{ STYLE("reset") }
    }
msg-user-gpg-list-can_certify =
    { STYLE("bold") }Kann zertifizieren:{ STYLE("reset") }               { $can_certify ->
        [yes] { STYLE("bright-green") }true{ STYLE("reset") }
       *[no] { STYLE("bright-red") }false{ STYLE("reset") }
    }
msg-user-gpg-list-verified =
    { STYLE("bold") }Verifiziert:{ STYLE("reset") }                      { $verified ->
        [yes] { STYLE("bright-green") }true{ STYLE("reset") }
       *[no] { STYLE("bright-red") }false{ STYLE("reset") }
    }
msg-user-gpg-list-email =
    { STYLE("bright-cyan") }{ $email }{ STYLE("reset") } { $verified ->
        [yes] verifiziert
       *[no] nicht verifiziert
    }
msg-user-gpg-list-subkey = { STYLE("bold") }Unterschlüssel { STYLE("bright-magenta") }{ $id }{ STYLE("reset") }:
msg-user-gpg-upload-exporting = Exportiere Schlüssel...
msg-user-gpg-upload-export_failed =
    Schlüsselexport fehlgeschlagen. { OPT($status_code) ->
       *[none] { "" }
        [some] GPG Status: { $status_code }
    }
msg-user-gpg-upload-success = Schlüssel erfolgreich hinzugefügt!
msg-user-gpg-verify-fetching_token = Hole Verifizierungstoken...
msg-user-gpg-verify-signing_token = Signiere Verifizierungstoken mit Schlüssel '{ $key_name }'...
msg-user-gpg-verify-signing_failed =
    Verifizierungstoken konnte nicht signiert werden. { OPT($status_code) ->
       *[none] { "" }
        [some] GPG Status: { $status_code }
    }
msg-user-gpg-verify-key_to_verify = Verifiziere diesen Schlüssel:
msg-user-gpg-verify-success = Verifizierung erfolgreich!
msg-user-gpg-delete-confirmation_prompt = Das Löschen eines GPG Schlüssels führt dazu, dass alle mit diesem Schlüssel signierten Commits ihre Verifizierung verlieren. Fortfahren? (j/N)
    .yes =
        Ja
        ja
        J
        j
    .no =
        Nein
        nein
        N
        n
msg-user-gpg-delete-unconfirmed = Nutzer hat Prozess abgebrochen.
msg-user-gpg-delete-success = Schlüssel mit ID { $id } erfolgreich gelöscht.
msg-release-create-must_specify_tag = Tag muss mit `--tag` oder `--create-tag` angegeben werden.
msg-release-create-tag_flags_conflict = `--tag` und `--create-tag` schließen sich gegenseitig aus. Wählen Sie bitte nur eine der Optionen.
msg-release-create-success = Release { $name } erstellt.
msg-release-list-entry =
    { $name } { $state ->
       *[neither] { "" }
        [draft] (Entwurf)
        [prerelease] (Pre-Release)
        [both] (Entwurf, Pre-Release)
    }
msg-release-view-header =
    { $name }
    Von { $author } am { DATETIME($created_at, dateStyle: "long") }
msg-release-asset-create-success = Anhang `{ $asset }` zu { $release } angefügt
msg-release-asset-delete-success = Anhang `{ $asset }` von { $release } gelöscht
msg-release-asset-download-success =
    { OPT($file) ->
       *[none] { $asset } heruntergeladen
        [some] { $asset } nach { $file } heruntergeladen
    }
msg-tag-create-success = Tag { $name } erstellt
msg-tag-delete-success = Tag { $name } gelöscht
msg-version-update_check-hint = Prüfen Sie mit `forge version --check` auf eine neue Version
msg-version-update_check-current = Neuste Version!
msg-version-update_check-behind =
    Neue Version verfügbar: { $new_version }
    Laden Sie sie hier herunter { $url }
msg-version-update_check-ahead = Sie sind der neusten veröffentlichten Version voraus.
msg-wiki-clone-success = Wiki von { $repo } nach { $path } geklont
help-arg-remote = Das lokale Git Remote, das auf das Zielrepo zeigt
help-arg-repo = Das Zielrepo der Aktion
help-cmd-auth-login = Anmeldung auf einer Instanz
help-cmd-auth-login-long =
    Anmeldung auf einer Instanz

    Öffnet eine Anmeldeseite in ihrem Webbrowser
help-cmd-auth-logout = Löscht die lokalen Anmeldedaten zu einer Instanz
help-cmd-auth-use_ssh = (De-)aktiviert SSH als Standard für gegebene Instanzen
help-cmd-auth-add_token = Fügt ein Anwendungstoken für eine Instanz hinzu
help-cmd-auth-add_token-long =
    Fügt ein Anwendungstoken für eine Instanz hinzu

    Verwenden sie diese Option, wenn `forge auth login` nicht funktionieren sollte.
help-arg-auth-add_token-token = Der Schlüssel, der hinzugefügt werden soll. Ist dieser nicht vorhanden, wird er aus der Standardeingabe gelesen
help-cmd-auth-list = Zählt alle Instanzen auf, auf denen sie aktuell angemeldet sind
help-cmd-actions-variables-list = Zählt die Variablen auf
help-arg-actions-variables-list-verbose = owner_id und repo_id werden ebenfalls ausgegeben
help-cmd-actions-variables-create = Erstelle eine neue Variable
help-arg-actions-variables-create-name = Der Name der neuen Variable
help-arg-actions-variables-create-data = Der Wert, der in der Variable gespeichert werden soll. Lassen sie diesen aus, um den Texteditor aufzurufen
help-arg-actions-variables-create-force = Ersetzt bestehende Variablen
help-cmd-actions-variables-delete = Löscht eine Variable
help-arg-actions-variables-delete-name = Die zu löschende Variable
help-cmd-actions-dispatch = Stößt einen Workflow an
help-arg-actions-dispatch-name = Name des Workflows, der angestoßen werden soll
help-arg-actions-dispatch-ref = Git-Revision, auf welcher der Workflow angestoßen werden soll
help-arg-org-options-full_name = Der Anzeigename der Organisation
help-arg-org-options-full_name-long =
    Der Anzeigename der Organisation

    Dies hat nicht die Einschränkungen des `name`-Arguments und kann beliebigen UTF-8-Text beinhalten
help-arg-org-options-description = Die Beschreibung der Organisation
help-arg-org-options-email = Die Kontakt-E-Mail-Adresse der Organisation
help-arg-org-options-location = Der Standort der Organisation
help-arg-org-options-website = Die Website der Organisation
help-arg-org-options-visibility = Das Sichtbarkeitslevel der Organisation
help-arg-org-options-admin_can_change_team_access = Einstellung, ob der Administrator eines Repos den Zugang von Teams der Organisation zum Repo ändern kann
help-cmd-org-create = Erstelle eine neue Organisation
help-arg-org-create-name = Der Benutzername für die Organisation
help-arg-org-create-name-long =
    Der Benutzername für die Organisation

    Dieser darf nur alphanumerische Zeichen, Binde- und Unterstrich und Punkte beinhalten.
    Er muss mit einem alphanumerischen Zeichen starten und darf keine aufeinanderfolgenden
    Binde- und Unterstriche oder Punkte enthalten.

    Wollen sie einen Namen ohne diese Einschränkungen, steht die `--full-name`-Option zur Verfügung.
help-cmd-actions-tasks = Listet die Aufgaben einer Repo auf
help-arg-actions-tasks-page = Die Seite, die angezeigt werden soll. Beinhaltet immer bis zu 20 Aufgaben
help-cmd-actions-variables = Liste Variablen auf und verwalte diese
help-arg-actions-dispatch-inputs = Werte, die der Ausführung als Eingaben übergeben werden sollen
help-cmd-actions-secrets = Liste Geheimnisse auf und verwalte diese
help-cmd-actions-secrets-list = Liste Geheimnisse auf
help-cmd-actions-secrets-create = Erstelle ein neues Geheimnis für Aktionen
help-arg-actions-secrets-create-name = Der Name des neuen Geheimnisses
help-arg-actions-secrets-create-data = Die Daten, die in dem Geheimnis gespeichert werden sollen
help-cmd-actions-secrets-delete = Lösche ein Geheimnis für Aktionen
help-arg-actions-secrets-delete-name = Das Geheimnis, das gelöscht werden soll
help-cmd-org-list = Liste alle Organisationen auf
help-arg-org-list-page = Welche Seite der Ergebnisse angezeigt werden soll
help-arg-org-list-only_member_of = Liste Organisationen auf, bei denen Sie Mitglied sind
help-cmd-org-view = Zeige Informationen über eine Organisation an
help-arg-org-view-name = Der Name der anzuzeigenden Organisation
help-cmd-org-edit = Bearbeite die Informationen einer Organisation
help-arg-org-edit-name = Der Name der zu bearbeitenden Organisation
help-arg-org-edit-name-long =
    Der Name der zu bearbeitenden Organisation

    Beachten Sie, dass dies der Nutzername ist, *nicht* der Anzeigename.
help-cmd-org-activity = Zeige die Aktivität einer Organisation an
help-arg-org-activity-name = Der Name der Organisation, deren Aktivität angezeigt werden soll
help-cmd-org-members = Liste Mitglieder einer Organisation auf
help-arg-org-members-org = Der Name der Organisation, deren Mitglieder angezeigt werden sollen
help-arg-org-members-page = Welche Seite der Ergebnisse angezeigt werden soll

help-cmd-milestone-search = Suche Meilensteine
help-arg-milestone-search-state = Filtern nach Zustand
help-arg-milestone-search-title = Filtern nach Titel
help-cmd-milestone-create = Erstelle einen neuen Meilenstein
help-arg-milestone-create-title = Titel des zu erstellenden Meilensteins
help-arg-milestone-create-description = Beschreibung des zu erstellenden Meilensteins. Lassen sie diese aus, um den Texteditor aufzurufen
help-arg-milestone-create-state = Zustand des zu erstellenden Meilensteins
help-cmd-milestone-view = Zeige einen Meilenstein an
help-arg-milestone-view-title = Titel oder ID des anzuzeigenden Meilensteins
help-cmd-milestone-edit = Bearbeite einen Meilenstein
help-arg-milestone-edit-title = Titel des zu bearbeitenden Meilensteins
help-arg-milestone-edit-description = Neue Beschreibung für den Meilenstein
help-arg-milestone-edit-state = Neuer Zustand für den Meilenstein
help-arg-milestone-edit-new_title = Neuer Titel für den Meilenstein
help-cmd-milestone-delete = Lösche einen Meilenstein
help-arg-milestone-delete-title = Titel oder ID des zu löschenden Meilensteins

msg-milestone-search-total = {$milestones ->
        [one] 1 Meilenstein
       *[other] {$milestones} Meilensteine
    }
msg-milestone-search-entry = {$title} { $state ->
       *[open] ({STYLE("green")}offen{STYLE("reset")})
        [closed] ({STYLE("red")}geschlossen{STYLE("reset")})
    } {$open} offen, {$closed} geschlossen
msg-milestone-view =
    {STYLE("bold")}{$title}{STYLE("reset")} { $state ->
       *[open] ({STYLE("green")}offen{STYLE("reset")})
        [closed] ({STYLE("red")}geschlossen{STYLE("reset")})
    }
    {STYLE("bright-blue")}{$open} offen, {$closed} geschlossen{STYLE("reset")}
    erstellt am {$created_at}, aktualisiert am {$updated_at}
    { OPT($due_on) ->
        [none] kein Fälligkeitsdatum
       *[some] fällig: {$due_on}
    }{ OPT($description) ->
        [none] {""}
       *[some] {""}

       {$description}
    }
msg-milestone-deleted = Meilenstein gelöscht
msg-milestone-not_found = Der angegebene Meilenstein konnte nicht gefunden werden

help-arg-org-options-visibility-long =
    Die Sichtbarkeit der Organisation

    Öffentliche Organisationen können von jedermann eingesehen werden, begrenzte
    Organisationen nur von angemeldeten Benutzern und private Organisationen nur
    von ihren eigenen Mitgliedern.
help-cmd-org-visibility = Lasse dir die Sichtbarkeit deiner Mitgliedschaft in einer Organisation anzeigen und ändere sie.
help-arg-org-visibility-org = Der Name der Organisation, für die deine Sichtbarkeit angezeigt werden soll
help-arg-org-visibility-set = Ändere deine Sichtbarkeit
help-cmd-org-label-list = Alle Issue-Labels einer Organisation auflisten
help-arg-org-label-list-org = Der Name der Organisation, deren Labels aufgelistet werden sollen
help-cmd-org-label-add = Ein neues Issue-Label zu einer Organisation hinzufügen
help-arg-org-label-add-org = Der Name der Organisation, zu der das Label hinzugefügt werden soll
help-arg-org-label-add-name = Der Name des hinzuzufügenden Labels
help-arg-org-label-add-color = Der Hexadezimalcode des hinzuzufügenden Labels
help-arg-org-label-add-description = Eine Beschreibung des Zwecks des Labels
help-cmd-org-label-edit = Issue-Label einer Organisation bearbeiten
help-arg-org-label-edit-org = Der Name der Organisation, zu der das Label gehört
help-arg-org-label-edit-name = Der Name des zu bearbeitenden Labels
help-arg-org-label-edit-new_name = Das Label umbenennen
help-arg-org-label-edit-color = Dem Label einen neuen Hexadezimalcode geben
help-arg-org-label-edit-description = Eine Beschreibung des Zwecks des Labels hinzufügen
help-cmd-org-label-rm = Ein Issue-Label aus einer Organisation entfernen
help-arg-org-label-rm-org = Der Name der Organisation, zu der das Label gehört
help-arg-org-label-rm-label = Der Name des Labels, das aus der Organisation entfernt werden soll
help-cmd-org-repo-list = Alle Repos auflisten, die dieser Organisation gehören
help-arg-org-repo-list-org = Der Name der Organisation, deren Repos aufgelistet werden sollen
help-arg-org-repo-list-page = Welche Seite der Ergebnisse angezeigt werden soll
help-cmd-org-repo-create = Ein neues Repository in dieser Organisation anlegen
help-arg-org-repo-create-org = Der Name der Organisation, in der das Repo angelegt werden soll
help-cmd-org-team-list = Alle Teams in einer Organisation einsehen
help-arg-org-team-list-org = Der Name der Organisation, deren Teams aufgelistet werden sollen
help-cmd-org-team-view = Information über ein einzelnes Team anzeigen
help-arg-org-team-view-org = Der Name der Organisation, zu der das Team gehört
help-arg-org-team-view-name = Der Name des anzuzeigenden Teams
help-arg-org-team-options-description = Eine Beschreibung dessen, was das Team macht
help-arg-org-team-options-read_permissions = Eine durch Kommata getrennte Liste von Leseberechtigungen, die diesem Team erteilt werden sollen
help-arg-org-team-options-read_permissions-long =
    Eine durch Kommata getrennte Liste von Leseberechtigungen, die diesem Team erteilt werden sollen

    Liste der Berechtigungen:
     - wiki
     - ext_wiki
     - issues
     - ext_issues
     - pulls
     - projects
     - actions
     - code
     - releases
     - packages

    Alternativ kannst du `all` benutzen, um jede Leseberechtigung zu erteilen.
help-arg-org-team-options-write_permissions = Eine durch Kommata getrennte Liste von Lese- und Schreibberechtigungen, die diesem Team erteilt werden sollen
help-arg-org-team-options-write_permissions-long =
    Eine durch Kommata getrennte Liste von Lese-und-Schreibberechtigungen, die diesem Team erteilt werden sollen

    Liste der Berechtigungen:
     - wiki
     - ext_wiki
     - issues
     - ext_issues
     - pulls
     - projects
     - actions
     - code
     - releases
     - packages

    Alternativ kannst du `all` verwenden, um jede Lese-und-Schreibberechtigung zu gewähren.
help-cmd-org-team-create = Neues Team erstellen
help-arg-org-team-create-org = Der Name der Organisation, in der das Team erstellt werden soll
help-arg-org-team-create-name = Der Name des neuen Teams
help-arg-org-team-create-name-long =
    Der Name des neuen Teams

    Dieser darf nur alphanumerische Zeichen enthalten
help-arg-org-team-create-can_create_repos = Mitgliedern dieses Teams erlauben, Repos in der Organisation zu erstellen
help-arg-org-team-create-include_all_repos = Diesem Team Zugriff auf jedes Repo gewähren
help-arg-org-team-create-admin = Diesem Team Administratorrechte in der Organisation gewähren
help-cmd-org-team-edit = Die Informationen und Berechtigungen eines Teams bearbeiten
help-arg-org-team-edit-org = Der Name der Organisation, zu der das Team gehört
help-arg-org-team-edit-name = Der Name des zu bearbeitenden Teams
help-arg-org-team-edit-can_create_repos = Mitgliedern dieses Teams erlauben, Repos in der Organisation zu erstellen
help-arg-org-team-edit-include_all_repos = Diesem Team Zugriff auf jedes Repo gewähren
help-arg-org-team-edit-admin = Diesem Team Administratorrechte in der Organisation erteilen
help-cmd-org-team-delete = Ein Team aus einer Organisation löschen
help-cmd-org-team-delete-long =
    Ein Team aus einer Organisation löschen

    Beachte, dass dadurch die Repos des Teams NICHT gelöscht werden!
help-arg-org-team-delete-org = Der Name der Organisation, zu der das Team gehört
help-arg-org-team-delete-name = Der Name des zu löschenden Teams
help-cmd-org-team-repo-list = Alle Repos auflisten, auf die dieses Team Zugriff hat
help-arg-org-team-repo-list-org = Der Name der Organisation, zu der das Team gehört
help-arg-org-team-repo-list-team = Der Name des Teams, dessen Repos angezeigt werden sollen
help-arg-org-team-repo-list-page = Welche Seite der Ergebnisse angezeigt werden soll
help-cmd-org-team-repo-add = Einem Team Zugriff auf ein existierendes Repo gewähren
help-arg-org-team-repo-add-org = Der Name der Organisation, zu der das Team gehört
help-arg-org-team-repo-add-team = Der Name des Teams, zu dem ein Repo hinzugefügt werden soll
help-arg-org-team-repo-add-repo = Der Name des Repos, das zum Team hinzugefügt werden soll
help-cmd-org-team-repo-rm = Einem Team den Zugriff auf ein Repo entziehen
help-cmd-org-team-repo-rm-long =
    Einem Team den Zugriff auf ein Repo entziehen

    Beachte, dass das Repo dadurch NICHT gelöscht wird!
help-arg-org-team-repo-rm-org = Der Name der Organisation, zu der das Team gehört
help-arg-org-team-repo-rm-team = Der Name des Teams, aus dem das Repo entfernt werden soll
help-arg-org-team-repo-rm-repo = Der Name des Repos, das aus dem Team entfernt werden soll
help-cmd-org-team-member-list = Alle Mitglieder eines Teams auflisten
help-arg-org-team-member-list-org = Der Name der Organisation, zu der das Team gehört
help-arg-org-team-member-list-team = Der Name des Teams, dessen Mitglieder angezeigt werden sollen
help-arg-org-team-member-list-page = Welche Seite der Ergebnisse angezeigt weden soll
help-cmd-org-team-member-add = Jemanden zu einem Team hinzufügen
help-arg-org-team-member-add-org = Der Name der Organisation, zu der das Team gehört
help-arg-org-team-member-add-team = Der Name des Teams, zu dem ein Benutzer hinzugefügt werden soll
help-arg-org-team-member-add-user = Der Name des Benutzers, der dem Team hinzugefügt werden soll
help-cmd-org-team-member-rm = Jemanden aus einem Team entfernen
help-arg-org-team-member-rm-org = Der Name der Organisation, zu der das Team gehört
help-arg-org-team-member-rm-team = Der Name des Teams, aus dem der Benutzer entfernt werden soll
help-arg-org-team-member-rm-user = Der Name des Benutzers, der aus dem Team entfernt werden soll
help-cmd-issue-create = Ein neues Issue in einem Repo erstellen
help-arg-issue-create-title = Titel des Issues
help-arg-issue-create-body = Der Textkörper des Issues
help-arg-issue-create-body-long =
    Der Textkörper des Issues

    Wenn du dies leer lässt, wird dein Textbearbeitungsprogramm geöffnet werden, es sei denn, --body-file ist angegeben.
help-arg-issue-create-body_file = Die Datei, aus welcher der Textkörper des Issues gelesen werden soll
help-arg-issue-create-template = Die beim Erstellen eines Issues zu verwendende Vorlage
