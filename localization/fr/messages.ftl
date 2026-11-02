msg-whoami = actuellement connecté en tant que { $name }@{ $host }
msg-auth-login-oauth_unsupported =
    Votre installation de forge be supporte pas `login` pour { $host_domain }

    Veuillez visiter { $applications_url }
    pour créer un jeton et utilisez pour vous connecter avec `forge auth add-key`
msg-auth-login-canceled = Connexion annulée
msg-auth-login-browser_success = Authentifié ! Vous pouvez désormais fermer cet onglet et retourner à votre terminal.
msg-auth-login-browser_failure = L’authentification a échoué
msg-auth_logout-success = déconnecté de { $host }
msg-auth-use_ssh-enabled = on utilisera désormais SSH pour { $host } par défaut
msg-auth-use_ssh-disabled = on n’utilisera plus SSH pour { $host } par défaut
msg-auth-use_ssh-already_enabled = SSH est déjà utilisé pour { $host } par défaut
msg-auth-use_ssh-already_disabled = SSH n’est déjà pas utilisé pour { $host } par défaut
msg-auth-add_token-prompt = nouvelle clé:
msg-auth-add_token-already_exists = une clé pour { $host } existe déjà
msg-actions-variable-create-already_exists = la variable existe déjà, utilisez --force pour la remplacer.
msg-actions-variable-create-already_exists_forced = la variable existe déjà, mise à jour.
msg-actions-variable-delete-success = Variable { $name } supprimée.
msg-org-list-no_results = Pas de résultats.
msg-org-list-page_number = Page { $page } de { $total }
msg-org-create-invalid_character =
    Les noms des organisations ne peuvent comporter que des caractères alphanumériques, des tirets, des tirets bas et des points.
      Si vous voulez un nom avec d’autres caractères, essayez de le configurer avec --full-name
msg-org-create-invalid_starting_character =
    Les noms des organisations ne peuvent commencer qu’avec des caractères alphanumériques.
      Si vous souhaitez un nom commençant par un autre caractère, essayez de le configurer avec --full-name
msg-org-create-invalid_ending_character =
    Les noms des organisations ne peuvent finir qu’avec des caractères alphanumériques.
      Si vous souhaitez un nom finissant par un autre caractère, essayez de le configurer avec --full-name
msg-issue-edit-title-empty = le titre ne peut pas être vide
msg-issue-edit-title-no_newlines = le titre ne peut pas contenir de retours à la ligne
msg-org-create-invalid_consecutive_characters =
    Les noms des organisations ne peuvent contenir deux caractères non-alphanumériques consécutifs.
      Si vous souhaitez un nom comme cela, essayez --full-name
msg-org-members-no_results = Pas de résultats.
msg-org-members-page_number = Page { $page } de { $total }
msg-org-label-add-success = Nouvelle étiquette { $label } créée
msg-org-label-remove-success = Étiquette { $label } retirée
msg-org-repo-list-no_results = Pas de résultats.
msg-org-repo-list-page_number = Page { $page } de { $total }
