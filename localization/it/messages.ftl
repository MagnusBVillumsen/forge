-dash =
    { IS_MINIMAL() ->
        [yes] -
       *[no] —
    }
msg-whoami = Attualmente connesso come { $name }@{ $host }
msg-auth-login-oauth_unsupported =
    La tua installazione di forge non supporta `login` per { $host_domain }

    Perfavore visita { $applications_url }
    per creare un token,e usalo per accedere con `forge auth add-key`
msg-auth-login-canceled = Accesso annullato
msg-auth-login-browser_success = Autenticato! Chiudi questa scheda e torna al tuo terminale.
msg-auth-login-browser_failure = Autenticazione non riuscita
msg-auth_logout-success = Disconnesso da { $host }
msg-auth-use_ssh-enabled = ora userà SSH per { $host } come impostazione predefinita
msg-auth-use_ssh-disabled = non userà più SSH per { $host } come impostazione predefinita
msg-auth-use_ssh-already_enabled = SSH è già utilizzato come impostazione predefinita per { $host }.
msg-auth-use_ssh-already_disabled = SSH non è già utilizzato come impostazione predefinita per { $host }.
msg-auth-add_token-prompt = nuova chiave:
msg-auth-add_token-already_exists = chiave per { $host } esiste già
msg-auth-list-none = Nessun accesso.
msg-actions-variable-create-already_exists = la variabile esiste già,aggiungi --force per rimpiazzarla.
msg-actions-variable-create-already_exists_forced = la variabile esiste già,riassegnando.
msg-actions-variable-delete-success = Variabile { $name } cancellata
msg-org-list-no_results = Nessun risultato.
msg-org-list-page_number = Pagina { $page } di { $total }
msg-org-view-member_count =
    { $member_count ->
        [one] { STYLE("bold") } 1 { STYLE("reset") } membro
       *[other] { STYLE("bold") }{ $member_count }{ STYLE("reset") } membri
    }
msg-org-view-team_count =
    { $team_count ->
        [one] { STYLE("bold") } 1 { STYLE("reset") } gruppo
       *[other] { STYLE("bold") }{ $team_count }{ STYLE("reset") } gruppi
    }
msg-org-create-invalid_character =
    Il nome di un organizzazione può solo contenere caratteri alfanumerici,trattini, underscore o punti.
      se vuoi un nome con altri caratteri,prova a impostare la flag --full-name
msg-org-create-invalid_starting_character =
    Il nome di un organizzazione può solo iniziare con caratteri alfanumerici.
      se vuoi un nome che inizia con altri caratteri,prova a impostare la flag --full-name
msg-org-create-invalid_ending_character =
    Il nome di un organizzazione può solo finire con caratteri alfanumerici.
      se vuoi un nome che finisca con altri caratteri,prova a impostare la flag --full-name
