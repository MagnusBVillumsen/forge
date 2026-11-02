-dash =
    { IS_MINIMAL() ->
        [yes] -
       *[no] —
    }
msg-whoami = sisäänkirjautuneena { $name }@{ $host }
msg-auth-login-canceled = Kirjautuminen peruttu
msg-auth-login-browser_success = Todennettu! Sulje tämä välilehti ja palaa takaisin päätteeseen.
msg-auth-login-browser_failure = Todennus epäonnistui.
msg-auth_logout-success = uloskirjauduttu { $host }
msg-auth-use_ssh-enabled = käytetään nyt SSH:ta palvelimeen { $host } oletusarvoisesti
msg-auth-add_token-prompt = uusi avain:
msg-auth-add_token-already_exists = avain palvelimelle { $host } on jo olemassa
msg-auth-list-none = Ei kirjautumisia.
msg-actions-variable-create-already_exists = muuttuja on jo olemassa, välitä --force korvataksesi sen.
msg-actions-variable-create-already_exists_forced = muuttuja on jo olemassa, päivitetään.
msg-actions-variable-delete-success = Muuttuja { $name } poistettu.
msg-org-list-no_results = Ei tuloksia.
msg-org-list-page_number = Sivu { $page }/{ $total }
msg-org-view-visibility =
    { $visibility ->
        [public] Julkinen
        [limited] Rajoitettu
       *[private] Yksityinen
    }
msg-org-view-member_count =
    { $member_count ->
        [one] { STYLE("bold") } 1 { STYLE("reset") } jäsen
       *[other] { STYLE("bold") }{ $member_count }{ STYLE("reset") } jäsentä
    }
msg-org-view-team_count =
    { $team_count ->
        [one] { STYLE("bold") } 1 { STYLE("reset") } tiimi
       *[other] { STYLE("bold") }{ $team_count }{ STYLE("reset") } tiimiä
    }
msg-org-members-no_results = Ei tuloksia.
msg-org-members-page_number = Sivu { $page }/{ $total }
msg-org-label-add-success = Luotu uusi nimilappu { $label }
msg-org-label-remove-success = Poistettu nimilappu { $label }
msg-org-repo-list-no_results = Ei tuloksia.
msg-org-repo-list-page_number = Sivu { $page }/{ $total }
msg-org-team-view-read_only = Vain luku:
msg-org-team-view-read_write = Luku/kirjoitus:
msg-org-team-view-perms-issues = Ongelmat
msg-org-team-view-perms-ext_issues = Ulkoiset ongelmat
msg-org-team-view-perms-pulls = Vetopyynnöt
msg-org-team-view-perms-projects = Projektit
msg-org-team-view-perms-code = Koodi
msg-org-team-view-perms-releases = Julkaisut
msg-org-team-view-perms-packages = Paketit
msg-org-team-repo-list-no_results = Ei tuloksia.
msg-org-team-repo-list-page_number = Sivu { $page }/{ $total }
msg-org-team-repo-add-success = Lisätty { STYLE("bold") }{ $org }/{ $repo }{ STYLE("reset") } tiimiin { STYLE("bold", "bright-blue") }{ $team }{ STYLE("reset") }
msg-org-team-repo-rm-success = Poistettu { STYLE("bold") }{ $org }/{ $repo }{ STYLE("reset") } tiimistä { STYLE("bold", "bright-blue") }{ $team }{ STYLE("reset") }
msg-org-team-member-list-no_results = Ei tuloksia.
msg-org-team-member-list-page_number = Sivu { $page }/{ $total }
msg-org-team-member-add-success = Lisätty { STYLE("bold", "bright-cyan") }{ $user }{ STYLE("reset") } tiimiin { STYLE("bold", "bright-blue") }{ $team }{ STYLE("reset") }
msg-org-team-member-rm-success = Poistettu { STYLE("bold", "bright-cyan") }{ $user }{ STYLE("reset") } tiimistä { STYLE("bold", "bright-blue") }{ $team }{ STYLE("reset") }
msg-issue-create-success = luotu ongelma #{ $number }: { $title }
msg-issue-view-comment_count =
    { $comments ->
        [one] 1 kommentti
       *[other] { $comments } kommenttia
    }
msg-issue-search-entry = #{ $number }: { $title } (tehnyt { $author })
msg-issue-templates-blank_allowed = '--no-template' on sallittu
msg-issue-templates-blank_not_allowed = '--no-template' ei ole sallittu
msg-issue-view-comments-comment_header =
    { OPT($full_name) ->
       *[none] { STYLE("bold", "bright-cyan") }{ $username }{ STYLE("reset") } sanoi:
        [some] { STYLE("bold", "bright-cyan") }{ $full_name }{ STYLE("reset") } { STYLE("dark-gray") }({ $username }){ STYLE("reset") } sanoi:
    }
msg-issue-view-comments-attachments =
    { $attachments ->
        [one] 1 liite
       *[other] { $attachments } liitettä
    }
msg-issue-edit-title-empty = otsikko ei voi olla tyhjä
msg-issue-close-success = Suljettu ongelma #{ $number }: "{ $title }"
msg-pr-view-comment_count =
    { $comments ->
        [one] 1 kommentti
       *[other] { $comments } kommenttia
    }
msg-pr-create-success = luotu vetopyyntö #{ $number }: { $title }
msg-pr-create-agit_success = luotu vetopyyntö: { $title }
msg-pr-search-entry = #{ $number }: { $title } (tehnyt { $author })
msg-repo-create-remote_exists = Etävarasto nimellä \"{ $remote_name }\" on jo olemassa
msg-repo-create-branch_invalid_utf8 = haaran nimi on virheellistä utf-8:aa
msg-repo-migrate-username_prompt = Käyttäjänimi:
msg-repo-migrate-password_prompt = Salasana:
msg-repo-migrate-token_prompt = Poletti:
msg-repo-migrate-success = Valmis! Katso verkossa { $url }
msg-repo-view-name = { $repo_name }
msg-repo-view-primary_language = Ensisijainen kieli on { $language }
msg-repo-view-stars =
    { $stars ->
        [one] 1 tähti
       *[other] { $stars } tähteä
    }
msg-repo-view-forks =
    { $forks ->
        [one] 1 forkki
       *[other] { $forks } forkkia
    }
msg-repo-view-issues =
    { $issues ->
        [one] 1 ongelma
       *[other] { $issues } ongelmaa
    }
msg-repo-view-prs =
    { $pull_requests ->
        [one] 1 vetopyyntö
       *[other] { $pull_requests } vetopyyntöä
    }
msg-repo-view-releases =
    { $releases ->
        [one] 1 julkaisu
       *[other] { $releases } julkaisua
    }
msg-repo-view-external_tracker = Ongelmanseuranta on osoitteessa { $url }
msg-repo-view-url = Katso verkossa { $url }
msg-repo-readme-none = Tietovarastossa ei ole README-tiedostoa
msg-repo-clone-preparing = { "   " }Valmistellaan...
msg-repo-clone-downloading = { " " }Ladataan... { NUMBER($percent, maximumFractionDigits: 2) } % ({ NUMBER($size, maximumFractionDigits: 2) }{ $units })
msg-repo-clone-resolving = { "   " }Selvitetään... { NUMBER($percent, maximumFractionDigits: 2) } %
msg-repo-clone-finishing_up = Viimeistellään...
msg-repo-clone-success = Kloonattu { $repo } polkuun { $path }
msg-repo-star-success = Lisätty tähti { $owner }/{ $repo }!
msg-repo-unstar-success = Poistettu tähti tietovarastosta { $owner }/{ $repo }!
msg-repo-delete-success = Poistettu { $owner }/{ $repo }
msg-repo-label-view-archived = (arkistoitu)
msg-repo-label-view-no_description = (ei kuvausta)
msg-repo-label-create-success = Luotiin nimilappu { $label }
msg-repo-label-delete-success = Poistettiin nimilappu { $label }
msg-repo-label-edit-success = Muokattiin nimilappua: { $label }
msg-user-search-page_zero = Ei sivua 0
msg-user-search-fail = Haku epäonnistui
msg-user-search-none = Hakua vastaavia käyttäjiä ei löytynyt
msg-user-search-page_too_high =
    { $total_pages ->
        [one] Vain 1 sivu on olemassa
       *[other] Vain { $total_pages } sivua on olemassa
    }
msg-user-view-joined_on = Liittynyt { STYLE("bold") }{ DATETIME($joined, dateStyle: "medium") }{ STYLE("reset") }
msg-user-follow-success = Seurattu { $username }
msg-user-unfollow-success = Lopetettu käyttäjän { $username } seuranta
msg-user-following-none-other = { $user } ei seuraa yhtäkään käyttäjää
msg-user-following-none-self = Et seuraa yhtäkään käyttäjää
msg-user-following-other = { $user } seuraa:
msg-user-following-self = Seuraat:
msg-user-followers-none-other = Käyttäjällä { $user } ei ole seuraajia
msg-user-followers-none-self = Sinulla ei ole seuraajia :(
msg-user-followers-other = Käyttäjää { $user } seuraavat:
msg-user-followers-self = Sinua seuraavat:
msg-user-block-success = Estetty { $user }
msg-user-unblock-success = Poistettu käyttäjän { $user } esto
msg-user-repos-none-starred-other = { $name } ei ole lisännyt tähteä yhteenkään tietovarastoon
msg-user-repos-none-starred-self = Et ole lisännyt tähteä yhteenkään tietovarastoon
msg-user-repos-none-other = Käyttäjä { $name } ei omista yhtäkään tietovarastoa
msg-user-repos-none-self = Et omista yhtäkään tietovarastoa
msg-user-orgs-none-other = { $user } ei ole yhdenkään organisaation jäsen
msg-user-orgs-none-self = Et ole yhdenkään organisaation jäsen
msg-user-orgs-count =
    { $organizations ->
        [one] 1 organisaatio
       *[other] { $organizations } organisaatiota
    }
msg-activity-created_fork = { STYLE("bold") }{ $actor }{ STYLE("reset") } forkkasi tietovaraston { STYLE("bold", "yellow") }{ $parent_repo_name }{ STYLE("reset") } tietovarastoksi { STYLE("bold", "yellow") }{ $repo_name }{ STYLE("reset") }
msg-activity-created_mirror = { STYLE("bold") }{ $actor }{ STYLE("reset") } loi peilin { STYLE("bold", "yellow") }{ $repo_name }{ STYLE("reset") }
msg-activity-created_repo = { STYLE("bold") }{ $actor }{ STYLE("reset") } loi tietovaraston { STYLE("bold", "yellow") }{ $repo_name }{ STYLE("reset") }
msg-activity-renamed_repo = { STYLE("bold") }{ $actor }{ STYLE("reset") } muutti tietovaraston { STYLE("bold", "yellow") }\"{ $old_name }\"{ STYLE("reset") } uudeksi nimeksi { STYLE("bold", "yellow") }{ $new_name }{ STYLE("reset") }
msg-activity-starred_repo = { STYLE("bold") }{ $actor }{ STYLE("reset") } lisäsi tähden tietovarastolle { STYLE("bold", "yellow") }{ $repo_name }{ STYLE("reset") }
msg-activity-watched_repo = { STYLE("bold") }{ $actor }{ STYLE("reset") } tarkkaili tietovarastoa { STYLE("bold", "yellow") }{ $repo_name }{ STYLE("reset") }
msg-activity-pushed_commit = { STYLE("bold") }{ $actor }{ STYLE("reset") } työnsi haaraan { STYLE("bold", "bright-cyan") }{ $branch }{ STYLE("reset") } tietovarastossa { STYLE("bold", "yellow") }{ $repo_name }{ STYLE("reset") }
msg-activity-created_issue = { STYLE("bold") }{ $actor }{ STYLE("reset") } avasi ongelman { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") }
msg-activity-created_pr = { STYLE("bold") }{ $actor }{ STYLE("reset") } loi vetopyynnön { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") }
msg-activity-pushed_tag = { STYLE("bold") }{ $actor }{ STYLE("reset") } työnsi tagin { STYLE("bold", "bright-cyan") }{ $tag_name }{ STYLE("reset") } tietovarastoon { STYLE("bold", "yellow") }{ $repo_name }{ STYLE("reset") }
msg-activity-commented_issue = { STYLE("bold") }{ $actor }{ STYLE("reset") } kommentoi ongelmaa { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") }
msg-activity-merged_pr = { STYLE("bold") }{ $actor }{ STYLE("reset") } yhdisti vetopyynnön { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") }
msg-activity-closed_issue = { STYLE("bold") }{ $actor }{ STYLE("reset") } sulki ongelman { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") }
msg-activity-reopened_issue = { STYLE("bold") }{ $actor }{ STYLE("reset") } avasi uudelleen ongelman { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") }
msg-activity-closed_pr = { STYLE("bold") }{ $actor }{ STYLE("reset") } sulki vetopyynnön { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") }
msg-activity-reopened_pr = { STYLE("bold") }{ $actor }{ STYLE("reset") } avasi uudelleen vetopyynnön { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") }
msg-activity-deleted_tag = { STYLE("bold") }{ $actor }{ STYLE("reset") } poisti tagin { STYLE("bold", "bright-cyan") }{ $tag_name }{ STYLE("reset") } tietovarastosta { STYLE("bold", "yellow") }{ $repo_name }{ STYLE("reset") }
msg-activity-deleted_branch = { STYLE("bold") }{ $actor }{ STYLE("reset") } poisti haaran { STYLE("bold", "bright-cyan") }{ $branch }{ STYLE("reset") } tietovarastosta { STYLE("bold", "yellow") }{ $repo_name }{ STYLE("reset") }
msg-activity-approved_pr = { STYLE("bold") }{ $actor }{ STYLE("reset") } hyväksyi { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") }
msg-activity-rejected_pr = { STYLE("bold") }{ $actor }{ STYLE("reset") } ehdotti muutoksia vetopyyntöön { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") }
msg-activity-commented_pr = { STYLE("bold") }{ $actor }{ STYLE("reset") } kommentoi vetopyyntöä { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") }
msg-activity-created_release = { STYLE("bold") }{ $actor }{ STYLE("reset") } loi julkaisun { STYLE("bold", "bright-cyan") }{ $release_name }{ STYLE("reset") } tietovarastossa { STYLE("bold", "yellow") }{ $repo_name }{ STYLE("reset") }
msg-user-edit-name-removal_hint = Käytä --unset poistaaksesi nimesi profiilistasi
msg-user-edit-location-removal_hint = Käytä --unset poistaaksesi sijaintisi profiilistasi
msg-user-edit-website-removal_hint = Käytä --unset poistaaksesi verkkosivustosi profiilistasi
msg-user-key-list-count = avaimia yhteensä: { $keys }
msg-user-key-list-header = { STYLE("bold") }Avain { STYLE("bright-magenta") }{ $id }{ STYLE("reset") }
msg-user-key-list-created_at = { STYLE("bold") }Luotu:{ STYLE("reset") }  { STYLE("bright-cyan") }{ DATETIME($created_at, dateStyle: "short", timeStyle: "medium") }{ STYLE("reset") }
msg-user-key-list-title = { STYLE("bold") }Nimi:{ STYLE("reset") }       { STYLE("bright-cyan") }{ $title }{ STYLE("reset") }
msg-user-key-list-type = { STYLE("bold") }Tyyppi:{ STYLE("reset") }        { STYLE("bright-cyan") }{ $key_type }{ STYLE("reset") }
msg-user-key-list-fingerprint = { STYLE("bold") }Sormenjälki:{ STYLE("reset") } { STYLE("bright-cyan") }{ $fingerprint }{ STYLE("reset") }
msg-user-key-upload-keys_not_found = Avaimia ei löytynyt.
msg-user-key-add-success = Avain luotu!
msg-user-gpg-list-count = avaimia yhteensä: { $keys }
msg-user-gpg-list-header = { STYLE("bold") }Avain { STYLE("bright-magenta") }{ $id }{ STYLE("reset") }
msg-user-gpg-list-key_id = { STYLE("bold") }Avain-ID:{ STYLE("reset") }              { STYLE("bright-cyan") }{ $key_id }{ STYLE("reset") }
msg-user-gpg-list-email =
    { STYLE("bright-cyan") }{ $email }{ STYLE("reset") } { $verified ->
        [yes] vahvistettu
       *[no] ei vahvistettu
    }
msg-user-gpg-list-subkey = { STYLE("bold") }Aliavain { STYLE("bright-magenta") }{ $id }{ STYLE("reset") }:
msg-user-gpg-upload-exporting = Viedään avainta...
msg-user-gpg-upload-success = Avain lisätty!
msg-user-gpg-verify-success = Vahvistus onnistui!
msg-user-gpg-verify-key_to_verify = Vahvistetaan tämä avain:
msg-user-gpg-verify-fetching_token = Noudetaan vahvistuspolettia...
msg-release-create-success = Luotu julkaisu { $name }
msg-release-list-entry =
    { $name } { $state ->
       *[neither] { "" }
        [draft] (luonnos)
        [prerelease] (esijulkaisu)
        [both] (luonnos, esijulkaisu)
    }
msg-release-view-header =
    { $name }
    Tehnyt { $author } { DATETIME($created_at, dateStyle: "long") }
msg-release-asset-create-success = Lisätty liite `{ $asset }` julkaisuun { $release }
msg-release-asset-delete-success = Poistettu liite `{ $asset }` julkaisusta { $release }
msg-tag-create-success = luotu tagi { $name }
msg-tag-delete-success = poistettu tagi { $name }
msg-version-update_check-hint = Tarkista uusi versio komennolla `forge version --check`
msg-version-update_check-current = Ajan tasalla!
msg-version-update_check-behind =
    Uusi versio saatavilla: { $new_version }
    Hae se osoitteesta { $url }
msg-version-update_check-ahead = Olet edellä viimeisintä julkaistua versiota
